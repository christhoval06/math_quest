import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/mission_setup/presentation/providers/custom_mission_provider.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/domain/repositories/i_profile_repository.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';

void main() {
  group('CustomMissionState', () {
    test('defaults match the existing custom mission screen', () {
      final state = CustomMissionState();

      expect(state.selectedOperations, {MathOperation.addition});
      expect(state.isExamMode, isFalse);
      expect(state.selectedDifficulty, DifficultyLevel.medium);
      expect(state.selectedTimerSeconds, 60);
      expect(state.selectedQuestionCount, 10);
      expect(state.visualAidsEnabled, isTrue);
      expect(state.soundEnabled, isTrue);
      expect(state.starCoins, 340);
      expect(state.streakDays, 5);
      expect(state.launchButtonLabel, 'Launch Mission! (10 Questions)');
    });

    test('takes an immutable snapshot of selected operations', () {
      final operations = <MathOperation>{MathOperation.addition};
      final state = CustomMissionState(selectedOperations: operations);

      operations.add(MathOperation.division);

      expect(state.selectedOperations, {MathOperation.addition});
      expect(
        () => state.selectedOperations.add(MathOperation.subtraction),
        throwsUnsupportedError,
      );
    });

    test('profile refresh updates counters without resetting form', () async {
      final repository = _FakeProfileRepository(_profile);
      final container = ProviderContainer(
        overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(profileNotifierProvider.notifier).loadProfile();
      final controller = container.read(customMissionControllerProvider);
      controller.toggleOperation(MathOperation.multiplication);
      controller.selectTimer(120);

      expect(container.read(customMissionProvider).starCoins, 875);
      expect(container.read(customMissionProvider).streakDays, 12);

      repository.profile = _profile.copyWith(starCoins: 920, currentStreak: 13);
      await container.read(profileNotifierProvider.notifier).loadProfile();
      final refreshed = container.read(customMissionProvider);

      expect(refreshed.starCoins, 920);
      expect(refreshed.streakDays, 13);
      expect(refreshed.selectedTimerSeconds, 120);
      expect(refreshed.selectedOperations, {
        MathOperation.addition,
        MathOperation.multiplication,
      });
    });
  });

  group('CustomMissionController', () {
    late CustomMissionState state;
    late List<_Preparation> preparations;

    CustomMissionController createController() {
      return CustomMissionController(
        readState: () => state,
        writeState: (next) => state = next,
        prepareSessionAction:
            ({
              required operation,
              required difficulty,
              required visualAidsEnabled,
            }) {
              preparations.add(
                _Preparation(operation, difficulty, visualAidsEnabled),
              );
            },
      );
    }

    setUp(() {
      state = CustomMissionState();
      preparations = [];
    });

    test('adds and removes operations while keeping one selected', () {
      final controller = createController();

      controller.toggleOperation(MathOperation.multiplication);
      expect(state.selectedOperations, {
        MathOperation.addition,
        MathOperation.multiplication,
      });

      controller.toggleOperation(MathOperation.addition);
      expect(state.selectedOperations, {MathOperation.multiplication});

      controller.toggleOperation(MathOperation.multiplication);
      expect(state.selectedOperations, {MathOperation.multiplication});
    });

    test('mode changes enforce visual aid rules', () {
      final controller = createController();

      controller.setExamMode(true);
      expect(state.isExamMode, isTrue);
      expect(state.visualAidsEnabled, isFalse);

      controller.setVisualAidsEnabled(true);
      expect(state.visualAidsEnabled, isFalse);

      controller.setExamMode(false);
      expect(state.isExamMode, isFalse);
      expect(state.visualAidsEnabled, isTrue);
    });

    test('selection methods update their matching fields', () {
      final controller = createController();

      controller.selectDifficulty(DifficultyLevel.hard);
      controller.selectTimer(30);
      controller.setSoundEnabled(false);
      controller.selectQuestionCount(25);

      expect(state.selectedDifficulty, DifficultyLevel.hard);
      expect(state.selectedTimerSeconds, 30);
      expect(state.soundEnabled, isFalse);
      expect(state.selectedQuestionCount, 25);
    });

    test('invalid timer values throw without changing state', () {
      final controller = createController();

      expect(() => controller.selectTimer(45), throwsArgumentError);
      expect(state.selectedTimerSeconds, 60);
    });

    test('invalid question counts throw without changing state', () {
      final controller = createController();

      for (final count in [5, 12, 55]) {
        expect(
          () => controller.selectQuestionCount(count),
          throwsArgumentError,
        );
      }
      expect(state.selectedQuestionCount, 10);
    });

    test('prepare mission snapshots values and prepares once', () {
      final controller = createController();
      controller.toggleOperation(MathOperation.division);
      controller.selectDifficulty(DifficultyLevel.hard);
      controller.selectTimer(120);
      controller.selectQuestionCount(25);
      controller.setSoundEnabled(false);

      final mission = controller.prepareMission();

      expect(preparations, hasLength(1));
      expect(preparations.single.operation, MathOperation.addition);
      expect(preparations.single.difficulty, DifficultyLevel.hard);
      expect(preparations.single.visualAidsEnabled, isTrue);
      expect(mission.allowedOperations, [
        MathOperation.addition,
        MathOperation.division,
      ]);
      expect(mission.difficulty, DifficultyLevel.hard);
      expect(mission.timerSeconds, 120);
      expect(mission.isExamMode, isFalse);
      expect(mission.totalQuestions, 25);
      expect(mission.visualAidsEnabled, isTrue);
      expect(mission.soundEnabled, isFalse);

      controller.toggleOperation(MathOperation.multiplication);
      expect(mission.allowedOperations, [
        MathOperation.addition,
        MathOperation.division,
      ]);
      expect(
        () => mission.allowedOperations.add(MathOperation.subtraction),
        throwsUnsupportedError,
      );
    });
  });
}

class _Preparation {
  final MathOperation operation;
  final DifficultyLevel difficulty;
  final bool visualAidsEnabled;

  const _Preparation(this.operation, this.difficulty, this.visualAidsEnabled);
}

class _FakeProfileRepository implements IProfileRepository {
  UserProfile? profile;

  _FakeProfileRepository(this.profile);

  @override
  Future<UserProfile?> getActiveProfile() async => profile;

  @override
  Future<List<UserProfile>> getAllProfiles() async => [?profile];

  @override
  Future<void> saveProfile(UserProfile profile) async {
    this.profile = profile;
  }

  @override
  Future<void> setActiveProfileId(String id) async {}
}

const _profile = UserProfile(
  id: 'profile-1',
  name: 'Leo',
  gradeLabel: 'Grade 2',
  avatar: '🚀',
  level: 7,
  starCoins: 875,
  xp: 500,
  currentStreak: 12,
  dailyGoal: 10,
  masteryTracks: {},
  unlockedBadgeIds: [],
);
