import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class TrophyStatsGrid extends StatelessWidget {
  final int totalSolved;
  final int todaySolved;
  final double averageAccuracy;
  final int streakDays;
  final int unlockedBadgesCount;
  final int totalBadgesCount;
  final Color primaryColor;

  const TrophyStatsGrid({
    super.key,
    required this.totalSolved,
    this.todaySolved = 0,
    required this.averageAccuracy,
    required this.streakDays,
    required this.unlockedBadgesCount,
    required this.totalBadgesCount,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _StatCard(
              label: AppLocalizations.of(context)!.totalSolvedLabel,
              value: '$totalSolved',
              sublabel: AppLocalizations.of(context)!.solvedToday(todaySolved),
              subColor: AppColors.successGreen,
              icon: '✅',
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: AppLocalizations.of(context)!.accuracyLabel,
              value: totalSolved == 0
                  ? '--%'
                  : '${(averageAccuracy * 100).toInt()}%',
              sublabel: AppLocalizations.of(context)!.practiceAccuracy,
              subColor: primaryColor,
              icon: '🎯',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _StatCard(
              label: AppLocalizations.of(context)!.streakLabel,
              value: AppLocalizations.of(context)!.daysCount(streakDays),
              sublabel: AppLocalizations.of(context)!.unstoppable,
              subColor: AppColors.secondaryOrange,
              icon: '⚡',
            ),
            _StatCard(
              label: AppLocalizations.of(context)!.trophiesLabel,
              value: '$unlockedBadgesCount / $totalBadgesCount',
              sublabel: AppLocalizations.of(context)!
                  .badgesRemaining(totalBadgesCount - unlockedBadgesCount),
              subColor: AppColors.accentPurple,
              icon: '🏆',
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sublabel;
  final Color subColor;
  final String icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sublabel,
    required this.subColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(icon, style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: subColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
