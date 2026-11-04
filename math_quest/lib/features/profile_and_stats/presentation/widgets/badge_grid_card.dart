import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/all_badges_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/badge_visuals.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class BadgeGridCard extends StatelessWidget {
  final BadgeViewData badge;
  final VoidCallback onTap;

  const BadgeGridCard({super.key, required this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: badge.isUnlocked
                  ? badgeTierColor(badge.tier).withValues(alpha: 0.3)
                  : AppColors.borderLight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: BadgeEmblem(badge: badge, size: 56)),
              const SizedBox(height: 12),
              Text(
                l10n.gameBadgeTitle(badge.id, badge.title),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              BadgeMetadata(badge: badge, compact: true),
              const SizedBox(height: 10),
              BadgeStatus(badge: badge, compact: true),
            ],
          ),
        ),
      ),
    );
  }
}
