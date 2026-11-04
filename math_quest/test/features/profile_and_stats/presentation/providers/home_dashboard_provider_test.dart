import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';
import 'package:math_quest/features/math_engine/domain/entities/superpower_challenge.dart';
import 'package:math_quest/features/math_engine/presentation/providers/challenge_engine_provider.dart';
import 'package:math_quest/features/mission_setup/domain/entities/daily_mission.dart';
import 'package:math_quest/features/mission_setup/presentation/providers/daily_mission_provider.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart';

void main() {
  group('HomeDashboardState', () {
    test('maps profile counters and challenge content', () {
      final state = HomeDashboardState.fromSources(
        profile: _profile,
        missionState: _missionState(progress: 3),
        challengeState: _challengeState,
      );

      expect(state.profileName, 'Leo');
      expect(state.starCoins, 875);
      expect(state.streakDays, 12);
      expect(state.level, 7);
      expect(state.stars, 340);
      expect(state.tip.icon, '🧠');
      expect(state.tip.title, 'Test trick');
      expect(state.tip.description, 'A mapped challenge description.');
    });

    test('uses existing dashboard defaults when profile is missing', () {
      final state = HomeDashboardState.fromSources(
        profile: null,
        missionState: _missionState(progress: 3),
        challengeState: _challengeState,
      );

      expect(state.starCoins, 1420);
      expect(state.streakDays, 5);
      expect(state.level, 4);
    });

    test('maps incomplete mission progress', () {
      final mission = HomeDashboardState.fromSources(
        profile: _profile,
        missionState: _missionState(progress: 3),
        challengeState: _challengeState,
      ).mission;

      expect(mission.currentProgress, 3);
      expect(mission.targetCount, 10);
      expect(mission.progressFraction, 0.3);
      expect(mission.progressPercent, 30);
      expect(mission.status, DailyMissionStatus.inProgress);
    });

    test('maps completed unclaimed mission as ready to claim', () {
      final mission = HomeDashboardState.fromSources(
        profile: _profile,
        missionState: _missionState(progress: 10),
        challengeState: _challengeState,
      ).mission;

      expect(mission.progressFraction, 1.0);
      expect(mission.progressPercent, 100);
      expect(mission.status, DailyMissionStatus.readyToClaim);
    });

    test('claimed status takes precedence over completion', () {
      final mission = HomeDashboardState.fromSources(
        profile: _profile,
        missionState: _missionState(progress: 10, isClaimed: true),
        challengeState: _challengeState,
      ).mission;

      expect(mission.status, DailyMissionStatus.claimed);
    });

    test('clamps progress above the mission target', () {
      final mission = HomeDashboardState.fromSources(
        profile: _profile,
        missionState: _missionState(progress: 14),
        challengeState: _challengeState,
      ).mission;

      expect(mission.currentProgress, 14);
      expect(mission.progressFraction, 1.0);
      expect(mission.progressPercent, 100);
      expect(mission.status, DailyMissionStatus.readyToClaim);
    });
  });

  group('HomeDashboardController', () {
    test('claims the mission once and returns its reward', () async {
      var claimCount = 0;
      final controller = HomeDashboardController(
        claimRewardAction: () async {
          claimCount++;
          return const ClaimedMissionReward(
            coinReward: 50,
            badgeRewardTitle: 'Test Badge',
          );
        },
        prepareMissionAction: _unusedPreparation,
        prepareChallengeAction: _unusedPreparation,
      );

      final reward = await controller.claimDailyMissionReward();

      expect(claimCount, 1);
      expect(reward.coinReward, 50);
      expect(reward.badgeRewardTitle, 'Test Badge');
    });

    test('prepares the daily mission once', () {
      var prepareCount = 0;
      final controller = HomeDashboardController(
        claimRewardAction: _unusedClaim,
        prepareMissionAction: () {
          prepareCount++;
          return const PreparedDashboardSession(MathOperation.subtraction);
        },
        prepareChallengeAction: _unusedPreparation,
      );

      final session = controller.prepareDailyMission();

      expect(prepareCount, 1);
      expect(session.operation, MathOperation.subtraction);
    });

    test('prepares the superpower challenge once', () {
      var prepareCount = 0;
      final controller = HomeDashboardController(
        claimRewardAction: _unusedClaim,
        prepareMissionAction: _unusedPreparation,
        prepareChallengeAction: () {
          prepareCount++;
          return const PreparedDashboardSession(MathOperation.multiplication);
        },
      );

      final session = controller.prepareSuperpowerChallenge();

      expect(prepareCount, 1);
      expect(session.operation, MathOperation.multiplication);
    });

    test('preserves claim failures for the caller', () async {
      final expectedError = StateError('claim failed');
      final controller = HomeDashboardController(
        claimRewardAction: () async => throw expectedError,
        prepareMissionAction: _unusedPreparation,
        prepareChallengeAction: _unusedPreparation,
      );

      await expectLater(
        controller.claimDailyMissionReward(),
        throwsA(same(expectedError)),
      );
    });

    test('coalesces overlapping reward claims', () async {
      var claimCount = 0;
      final completer = Completer<ClaimedMissionReward>();
      final controller = HomeDashboardController(
        claimRewardAction: () {
          claimCount++;
          return completer.future;
        },
        prepareMissionAction: _unusedPreparation,
        prepareChallengeAction: _unusedPreparation,
      );

      final first = controller.claimDailyMissionReward();
      final second = controller.claimDailyMissionReward();

      expect(claimCount, 1);
      completer.complete(
        const ClaimedMissionReward(
          coinReward: 50,
          badgeRewardTitle: 'Test Badge',
        ),
      );
      final rewards = await Future.wait([first, second]);
      expect(rewards.map((reward) => reward.coinReward), [50, 50]);
    });
  });
}

Future<ClaimedMissionReward> _unusedClaim() async {
  return const ClaimedMissionReward(coinReward: 0, badgeRewardTitle: 'Unused');
}

PreparedDashboardSession _unusedPreparation() {
  return const PreparedDashboardSession(MathOperation.addition);
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

DailyMissionState _missionState({
  required int progress,
  bool isClaimed = false,
}) {
  return DailyMissionState(
    mission: const DailyMission(
      id: 'test-mission',
      title: 'Solve 10 Addition Puzzles',
      targetOperation: MathOperation.addition,
      difficulty: DifficultyLevel.easy,
      targetCount: 10,
      coinReward: 50,
      badgeRewardTitle: 'Test Badge',
      badgeRewardId: 'test-badge',
    ),
    currentProgress: progress,
    isClaimed: isClaimed,
  );
}

final _challengeState = ChallengeEngineState(
  todaysChallenge: SuperpowerChallenge(
    id: 'test-challenge',
    title: 'Test trick',
    description: 'A mapped challenge description.',
    icon: '🧠',
    operation: MathOperation.addition,
    difficulty: DifficultyLevel.easy,
    problemGenerator: () => const MathProblem(
      num1: 1,
      num2: 1,
      operation: MathOperation.addition,
      correctAnswer: 2,
      options: [2, 3, 4, 5],
    ),
  ),
);
