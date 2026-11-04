import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/core/theme/theme_provider.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/home_dashboard_localizations.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/daily_mission_card.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/explorer_banner.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/game_modes_section.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/home_dashboard_app_bar.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/superpower_tip_card.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(visualThemeProvider);
    final state = ref.watch(homeDashboardProvider);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: HomeDashboardAppBar(
        starCoins: state.starCoins,
        streakDays: state.streakDays,
        onSettings: () => Navigator.pushNamed(context, AppRoutes.settings),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                ExplorerBanner(
                  profileName: state.profileName,
                  primaryColor: theme.primary,
                  secondaryColor: theme.secondary,
                  borderColor: theme.border,
                  streakDays: state.streakDays,
                  stars: state.stars,
                  level: state.level,
                  onOpenTrophyRoom: () =>
                      Navigator.pushNamed(context, AppRoutes.trophyRoom),
                ),
                const SizedBox(height: 20),
                DailyMissionCard(
                  data: state.mission,
                  primaryColor: theme.primary,
                  onClaim: () => _claimMission(context, ref),
                  onContinue: () => _continueMission(context, ref),
                ),
                const SizedBox(height: 24),
                GameModesSection(
                  onQuickPlay: () =>
                      Navigator.pushNamed(context, AppRoutes.activeGame),
                  onPracticeArena: () =>
                      Navigator.pushNamed(context, AppRoutes.customMission),
                  onAdventureIsland: () =>
                      Navigator.pushNamed(context, AppRoutes.adventureIsland),
                  onBuddyChallenge: () =>
                      Navigator.pushNamed(context, AppRoutes.buddyChallenge),
                ),
                const SizedBox(height: 24),
                SuperpowerTipCard(
                  data: state.tip,
                  onLaunch: () => _launchChallenge(context, ref),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _claimMission(BuildContext context, WidgetRef ref) async {
    final reward = await ref
        .read(homeDashboardControllerProvider)
        .claimDailyMissionReward();
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.missionRewardAdded(
            reward.coinReward,
            localizedMissionBadge(
              AppLocalizations.of(context)!,
              reward.badgeRewardId,
              reward.badgeRewardTitle,
            ),
          ),
        ),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  void _continueMission(BuildContext context, WidgetRef ref) {
    final session = ref
        .read(homeDashboardControllerProvider)
        .prepareDailyMission();
    Navigator.pushNamed(
      context,
      AppRoutes.activeGame,
      arguments: ActiveGameArgs(
        timerSeconds: 0,
        allowedOperations: [session.operation],
        preservePreparedSession: true,
      ),
    );
  }

  void _launchChallenge(BuildContext context, WidgetRef ref) {
    final session = ref
        .read(homeDashboardControllerProvider)
        .prepareSuperpowerChallenge();
    Navigator.pushNamed(
      context,
      AppRoutes.activeGame,
      arguments: ActiveGameArgs(
        levelNumber: null,
        timerSeconds: 0,
        allowedOperations: [session.operation],
        preservePreparedSession: true,
      ),
    );
  }
}
