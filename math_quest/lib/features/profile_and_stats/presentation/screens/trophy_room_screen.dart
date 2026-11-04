import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/core/theme/theme_provider.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/trophy_room_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/badge_showcase_section.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/mastery_track_card.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/trophy_stats_grid.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/weekly_practice_chart_card.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class TrophyRoomScreen extends ConsumerWidget {
  const TrophyRoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(visualThemeProvider);

    // 🧠 PURE LOGIC SEPARATION: All math & Hive querying happens in the provider!
    final state = ref.watch(trophyRoomProvider);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          AppLocalizations.of(context)!.navTrophies,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        actions: [
          _TopBadge(
            icon: '🪙',
            label: '${state.starCoins}',
            color: const Color(0xFFFFFBEB),
            borderColor: const Color(0xFFFDE68A),
            textColor: const Color(0xFFB45309),
          ),
          const SizedBox(width: 8),
          _TopBadge(
            icon: '🔥',
            label: AppLocalizations.of(context)!.daysShort(state.streakDays),
            color: const Color(0xFFFFF7ED),
            borderColor: const Color(0xFFFFEDD5),
            textColor: AppColors.secondaryOrange,
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                // 1. Trophy Banner
                _TrophyHeaderBanner(
                  primaryColor: theme.primary,
                  borderColor: theme.border,
                ),
                const SizedBox(height: 18),

                // 2. Performance Stats Grid (Reads pre-computed stats)
                TrophyStatsGrid(
                  totalSolved: state.totalSolved,
                  todaySolved: state.todaySolved,
                  averageAccuracy: state.averageAccuracy,
                  streakDays: state.streakDays,
                  unlockedBadgesCount: state.unlockedCount,
                  totalBadgesCount: state.totalBadgesCount,
                  primaryColor: theme.primary,
                ),
                const SizedBox(height: 24),

                // 3. Weekly Practice Chart (Reads pre-formatted weeklyData)
                WeeklyPracticeChartCard(
                  weeklyData: state.weeklyData,
                  primaryColor: theme.primary,
                ),
                const SizedBox(height: 24),

                // 4. Math Mastery Tracks
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.mathMasteryTracks,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .operationsCount(state.masteryTracks.length),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (state.masteryTracks.isEmpty)
                  Text(AppLocalizations.of(context)!.noMasteryData),
                for (final track in state.masteryTracks) ...[
                  MasteryTrackCard(track: track),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 20),

                // 5. Recent Badges Showcase
                BadgeShowcaseSection(
                  unlockedBadgeIds: state.unlockedBadgeIds,
                  primaryColor: theme.primary,
                ),
                const SizedBox(height: 24),

                // 6. Parent Diagnostic Report Button
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.parentReport),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.parentDiagnosticTitle,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrophyHeaderBanner extends StatelessWidget {
  final Color primaryColor;
  final Color borderColor;

  const _TrophyHeaderBanner({
    required this.primaryColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.08),
            primaryColor.withOpacity(0.18),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Text('🏆', style: TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.superMathematician,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.trophyRoomTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)!.keepShining,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBadge extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final Color borderColor;
  final Color textColor;

  const _TopBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
