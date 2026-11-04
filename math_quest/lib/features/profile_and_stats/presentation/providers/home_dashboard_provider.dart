import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/presentation/providers/challenge_engine_provider.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_notifier.dart';
import 'package:math_quest/features/mission_setup/presentation/providers/daily_mission_provider.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';

enum DailyMissionStatus { inProgress, readyToClaim, claimed }

class DailyMissionViewData {
  final String missionId;
  final String badgeRewardId;
  final String title;
  final int coinReward;
  final String badgeRewardTitle;
  final int currentProgress;
  final int targetCount;
  final double progressFraction;
  final int progressPercent;
  final DailyMissionStatus status;

  const DailyMissionViewData({
    this.missionId = '',
    this.badgeRewardId = '',
    required this.title,
    required this.coinReward,
    required this.badgeRewardTitle,
    required this.currentProgress,
    required this.targetCount,
    required this.progressFraction,
    required this.progressPercent,
    required this.status,
  });
}

class SuperpowerTipViewData {
  final String challengeId;
  final String icon;
  final String title;
  final String description;

  const SuperpowerTipViewData({
    this.challengeId = '',
    required this.icon,
    required this.title,
    required this.description,
  });
}

class HomeDashboardState {
  final String profileName;
  final int starCoins;
  final int streakDays;
  final int level;
  final int stars;
  final DailyMissionViewData mission;
  final SuperpowerTipViewData tip;

  const HomeDashboardState({
    this.profileName = '',
    required this.starCoins,
    required this.streakDays,
    required this.level,
    this.stars = 340,
    required this.mission,
    required this.tip,
  });

  factory HomeDashboardState.fromSources({
    required UserProfile? profile,
    required DailyMissionState missionState,
    required ChallengeEngineState challengeState,
  }) {
    final missionStatus = missionState.isClaimed
        ? DailyMissionStatus.claimed
        : missionState.isCompleted
        ? DailyMissionStatus.readyToClaim
        : DailyMissionStatus.inProgress;
    final mission = missionState.mission;
    final challenge = challengeState.todaysChallenge;

    return HomeDashboardState(
      profileName: profile?.name ?? '',
      starCoins: profile?.starCoins ?? 1420,
      streakDays: profile?.currentStreak ?? 5,
      level: profile?.level ?? 4,
      mission: DailyMissionViewData(
        missionId: mission.id,
        badgeRewardId: mission.badgeRewardId,
        title: mission.title,
        coinReward: mission.coinReward,
        badgeRewardTitle: mission.badgeRewardTitle,
        currentProgress: missionState.currentProgress,
        targetCount: mission.targetCount,
        progressFraction: missionState.progressFraction,
        progressPercent: missionState.progressPercent,
        status: missionStatus,
      ),
      tip: SuperpowerTipViewData(
        challengeId: challenge.id,
        icon: challenge.icon,
        title: challenge.title,
        description: challenge.description,
      ),
    );
  }
}

class ClaimedMissionReward {
  final String badgeRewardId;
  final int coinReward;
  final String badgeRewardTitle;

  const ClaimedMissionReward({
    this.badgeRewardId = '',
    required this.coinReward,
    required this.badgeRewardTitle,
  });
}

class PreparedDashboardSession {
  final MathOperation operation;

  const PreparedDashboardSession(this.operation);
}

class HomeDashboardController {
  final Future<ClaimedMissionReward> Function() claimRewardAction;
  final PreparedDashboardSession Function() prepareMissionAction;
  final PreparedDashboardSession Function() prepareChallengeAction;
  Future<ClaimedMissionReward>? _claimInFlight;

  HomeDashboardController({
    required this.claimRewardAction,
    required this.prepareMissionAction,
    required this.prepareChallengeAction,
  });

  Future<ClaimedMissionReward> claimDailyMissionReward() {
    return _claimInFlight ??= Future.sync(claimRewardAction).whenComplete(() {
      _claimInFlight = null;
    });
  }

  PreparedDashboardSession prepareDailyMission() => prepareMissionAction();

  PreparedDashboardSession prepareSuperpowerChallenge() =>
      prepareChallengeAction();
}

final homeDashboardProvider = Provider<HomeDashboardState>((ref) {
  return HomeDashboardState.fromSources(
    profile: ref.watch(profileNotifierProvider),
    missionState: ref.watch(dailyMissionProvider),
    challengeState: ref.watch(challengeEngineProvider),
  );
});

final homeDashboardControllerProvider = Provider<HomeDashboardController>((
  ref,
) {
  return HomeDashboardController(
    claimRewardAction: () async {
      final mission = ref.read(dailyMissionProvider).mission;
      await ref.read(dailyMissionProvider.notifier).claimReward();
      return ClaimedMissionReward(
        badgeRewardId: mission.badgeRewardId,
        coinReward: mission.coinReward,
        badgeRewardTitle: mission.badgeRewardTitle,
      );
    },
    prepareMissionAction: () {
      final mission = ref.read(dailyMissionProvider).mission;
      ref
          .read(practiceSessionProvider.notifier)
          .resetSession(
            operation: mission.targetOperation,
            difficulty: mission.difficulty,
          );
      return PreparedDashboardSession(mission.targetOperation);
    },
    prepareChallengeAction: () {
      final challenge = ref.read(challengeEngineProvider).todaysChallenge;
      ref.read(challengeEngineProvider.notifier).launchChallenge();
      return PreparedDashboardSession(challenge.operation);
    },
  );
});
