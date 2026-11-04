import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/parent_diagnostic_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/parent_diagnostic_provider.dart';

void main() {
  test('missing profile uses safe baseline defaults and injected date', () {
    final state = ParentDiagnosticState.fromProfile(
      profile: null,
      reportDate: DateTime(2026, 10, 23),
    );

    expect(state.name, 'Leo');
    expect(state.grade, 'Grade 2');
    expect(state.avatar, '👦');
    expect(state.reportDateLabel, '10/23/2026');
    expect(state.totalSolved, 0);
    expect(state.overallAccuracy, 0);
    expect(state.readinessProgress, 0.1);
    expect(state.readinessLabel, 'Baseline Gathering');
    expect(state.operations, isEmpty);
  });

  test('maps totals active-track average and readiness recommendation', () {
    final state = ParentDiagnosticState.fromProfile(
      profile: _profile({
        'addition': _track(MathOperationType.addition, 10, 0.95),
        'subtraction': _track(MathOperationType.subtraction, 20, 0.75),
        'multiplication': _track(MathOperationType.multiplication, 0, 1),
      }),
      reportDate: DateTime(2026, 10, 23),
    );

    expect(state.totalSolved, 30);
    expect(state.overallAccuracy, closeTo(0.85, 0.0001));
    expect(state.readinessProgress, closeTo(0.85, 0.0001));
    expect(state.readinessLabel, '85% Mastery');
    expect(
      state.readinessSummary,
      contains('begun building foundational skills'),
    );
  });

  test('maps every operation status threshold', () {
    final state = ParentDiagnosticState.fromProfile(
      profile: _profile({
        'addition': _track(MathOperationType.addition, 0, 1),
        'subtraction': _track(MathOperationType.subtraction, 5, 0.69),
        'multiplication': _track(MathOperationType.multiplication, 5, 0.70),
        'division': _track(MathOperationType.division, 5, 0.90),
      }),
      reportDate: DateTime(2026, 10, 23),
    );

    expect(state.operations.map((operation) => operation.status), [
      DiagnosticOperationStatus.pending,
      DiagnosticOperationStatus.needsPractice,
      DiagnosticOperationStatus.onTrack,
      DiagnosticOperationStatus.mastered,
    ]);
    expect(state.operations.map((operation) => operation.title), [
      'ADDITION',
      'SUBTRACTION',
      'MULTIPLICATION',
      'DIVISION',
    ]);
    expect(state.operations[1].accuracyLabel, '69% Accuracy');
    expect(state.operations.first.accuracyLabel, 'No rounds completed');
  });

  test('malformed mastery values produce finite clamped presentation data', () {
    final state = ParentDiagnosticState.fromProfile(
      profile: _profile({
        'addition': _track(MathOperationType.addition, 5, double.nan),
        'subtraction': _track(MathOperationType.subtraction, -4, 2),
      }),
      reportDate: DateTime(2026, 10, 23),
    );

    expect(state.totalSolved, 5);
    expect(state.overallAccuracy, 0);
    expect(state.readinessProgress.isFinite, isTrue);
    expect(state.readinessProgress, inInclusiveRange(0, 1));
    expect(state.operations[0].accuracyPercent, 0);
    expect(state.operations[1].totalSolved, 0);
    expect(state.operations[1].status, DiagnosticOperationStatus.pending);
  });

  test('more than fifty solved questions uses strong-readiness copy', () {
    final state = ParentDiagnosticState.fromProfile(
      profile: _profile({
        'addition': _track(MathOperationType.addition, 51, 0.92),
      }),
      reportDate: DateTime(2026, 10, 23),
    );

    expect(
      state.readinessSummary,
      contains('strong foundational number sense'),
    );
  });

  test('reopening the provider refreshes the report date', () async {
    var currentDate = DateTime(2026, 10, 23);
    final container = ProviderContainer(
      overrides: [
        parentDiagnosticClockProvider.overrideWithValue(() => currentDate),
        parentDiagnosticProfileSourceProvider.overrideWithValue(null),
      ],
    );
    addTearDown(container.dispose);

    final firstVisit = container.listen(
      parentDiagnosticProvider,
      (_, _) {},
      fireImmediately: true,
    );
    expect(
      container.read(parentDiagnosticProvider).reportDateLabel,
      '10/23/2026',
    );
    firstVisit.close();
    await container.pump();

    currentDate = DateTime(2026, 10, 24);
    final secondVisit = container.listen(
      parentDiagnosticProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(secondVisit.close);

    expect(
      container.read(parentDiagnosticProvider).reportDateLabel,
      '10/24/2026',
    );
  });
}

UserProfile _profile(Map<String, MasteryTrack> tracks) => UserProfile(
  id: 'profile-1',
  name: 'Maya',
  gradeLabel: 'Grade 3',
  avatar: '🚀',
  level: 2,
  starCoins: 100,
  xp: 50,
  currentStreak: 3,
  dailyGoal: 10,
  masteryTracks: tracks,
  unlockedBadgeIds: const [],
);

MasteryTrack _track(MathOperationType operation, int solved, double accuracy) =>
    MasteryTrack(
      operation: operation,
      level: 1,
      title: 'Explorer',
      totalSolved: solved,
      accuracy: accuracy,
    );
