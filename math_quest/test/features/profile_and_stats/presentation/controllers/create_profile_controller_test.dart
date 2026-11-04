import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/create_profile_controller.dart';

void main() {
  test('defaults and selectable options are immutable', () {
    final controller = _controller();

    expect(controller.state.name, isEmpty);
    expect(controller.state.selectedAvatar, '👦');
    expect(controller.state.selectedGrade, 'Grade 2');
    expect(controller.state.avatars, [
      '👦',
      '👧',
      '🚀',
      '🦊',
      '🦁',
      '🐼',
      '🐯',
      '🐨',
      '🐸',
      '🦉',
    ]);
    expect(controller.state.grades.map((grade) => grade.title), [
      'Kindergarten',
      'Grade 1',
      'Grade 2',
      'Grade 3+',
    ]);
    expect(() => controller.state.avatars.add('🐙'), throwsUnsupportedError);
    expect(
      () => controller.state.grades.add(controller.state.grades.first),
      throwsUnsupportedError,
    );
  });

  test(
    'selection actions update matching values and reject unknown options',
    () {
      final controller = _controller();

      controller.setName('  Maya  ');
      controller.selectAvatar('🚀');
      controller.selectGrade('Grade 3+');

      expect(controller.state.name, '  Maya  ');
      expect(controller.state.selectedAvatar, '🚀');
      expect(controller.state.selectedGrade, 'Grade 3+');
      expect(() => controller.selectAvatar('🐙'), throwsArgumentError);
      expect(() => controller.selectGrade('College'), throwsArgumentError);
    },
  );

  test(
    'submit creates exact starter profile then completes onboarding',
    () async {
      final events = <String>[];
      UserProfile? created;
      final now = DateTime(2026, 10, 23, 9, 30);
      final controller = CreateProfileController(
        createProfileAction: (profile) async {
          events.add('create');
          created = profile;
        },
        completeOnboardingAction: () async => events.add('complete'),
        now: () => now,
        createId: (_) => 'child-fixed',
      );
      controller.setName('  Maya  ');
      controller.selectAvatar('🚀');
      controller.selectGrade('Grade 3+');

      final result = await controller.submit();

      expect(events, ['create', 'complete']);
      expect(identical(result, created), isTrue);
      expect(result.id, 'child-fixed');
      expect(result.name, 'Maya');
      expect(result.gradeLabel, 'Grade 3+');
      expect(result.avatar, '🚀');
      expect(result.level, 1);
      expect(result.starCoins, 100);
      expect(result.xp, 0);
      expect(result.currentStreak, 1);
      expect(result.lastActiveDate, now);
      expect(result.dailyGoal, 10);
      expect(result.unlockedBadgeIds, isEmpty);
      expect(result.masteryTracks.keys, [
        'addition',
        'subtraction',
        'multiplication',
        'division',
      ]);
      for (final track in result.masteryTracks.values) {
        expect(track.level, 1);
        expect(track.title, 'Sprout Explorer');
        expect(track.totalSolved, 0);
        expect(track.accuracy, 0);
      }
      expect(controller.state.isSubmitting, isFalse);
      expect(controller.state.errorMessage, isNull);
    },
  );

  test('blank name uses Explorer fallback', () async {
    UserProfile? created;
    final controller = _controller(
      createProfileAction: (profile) async => created = profile,
    );
    controller.setName('   ');

    await controller.submit();

    expect(created?.name, 'Explorer');
  });

  test('overlapping submits share one profile creation', () async {
    var createCount = 0;
    var completionCount = 0;
    final gate = Completer<void>();
    final controller = _controller(
      createProfileAction: (_) {
        createCount++;
        return gate.future;
      },
      completeOnboardingAction: () async => completionCount++,
    );

    final first = controller.submit();
    final second = controller.submit();

    expect(identical(first, second), isTrue);
    expect(createCount, 1);
    expect(controller.state.isSubmitting, isTrue);
    gate.complete();
    await Future.wait([first, second]);
    expect(createCount, 1);
    expect(completionCount, 1);
  });

  test('failed submission is retryable and preserves original error', () async {
    final expectedError = StateError('storage failed');
    var attempts = 0;
    final controller = _controller(
      createProfileAction: (_) async {
        attempts++;
        if (attempts == 1) throw expectedError;
      },
    );

    await expectLater(controller.submit(), throwsA(same(expectedError)));
    expect(controller.state.isSubmitting, isFalse);
    expect(controller.state.errorMessage, contains('storage failed'));

    final profile = await controller.submit();
    expect(profile.name, 'Explorer');
    expect(attempts, 2);
    expect(controller.state.errorMessage, isNull);
  });

  test(
    'retry after onboarding failure does not create a duplicate profile',
    () async {
      final expectedError = StateError('onboarding storage failed');
      var profileWrites = 0;
      var onboardingWrites = 0;
      final controller = _controller(
        createProfileAction: (_) async => profileWrites++,
        completeOnboardingAction: () async {
          onboardingWrites++;
          if (onboardingWrites == 1) throw expectedError;
        },
      );

      await expectLater(controller.submit(), throwsA(same(expectedError)));
      final profile = await controller.submit();

      expect(profile.id, 'child-test');
      expect(profileWrites, 1);
      expect(onboardingWrites, 2);
      expect(controller.state.errorMessage, isNull);
    },
  );
}

CreateProfileController _controller({
  Future<void> Function(UserProfile)? createProfileAction,
  Future<void> Function()? completeOnboardingAction,
}) {
  return CreateProfileController(
    createProfileAction: createProfileAction ?? (_) async {},
    completeOnboardingAction: completeOnboardingAction ?? () async {},
    now: () => DateTime(2026, 10, 23),
    createId: (_) => 'child-test',
  );
}
