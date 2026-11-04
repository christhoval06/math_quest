import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class GameModesSection extends StatelessWidget {
  final VoidCallback onQuickPlay;
  final VoidCallback onPracticeArena;
  final VoidCallback onAdventureIsland;
  final VoidCallback onBuddyChallenge;

  const GameModesSection({
    super.key,
    required this.onQuickPlay,
    required this.onPracticeArena,
    required this.onAdventureIsland,
    required this.onBuddyChallenge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              AppLocalizations.of(context)!.gameModes,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.allUnlocked,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.successGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ModeCard(
              title: AppLocalizations.of(context)!.quickPlay,
              badge: AppLocalizations.of(context)!.quickPlayDuration,
              badgeColor: const Color(0xFFFFF1F2),
              badgeTextColor: const Color(0xFFE11D48),
              subtitle: AppLocalizations.of(context)!.quickPlayDescription,
              cta: AppLocalizations.of(context)!.playNowAction,
              icon: '⚡',
              onTap: onQuickPlay,
            ),
            const SizedBox(width: 12),
            _ModeCard(
              title: AppLocalizations.of(context)!.practiceArena,
              badge: AppLocalizations.of(context)!.customModeBadge,
              badgeColor: const Color(0xFFEFF6FF),
              badgeTextColor: const Color(0xFF2563EB),
              subtitle: AppLocalizations.of(context)!.practiceDescription,
              cta: AppLocalizations.of(context)!.configureAction,
              icon: '🛠️',
              onTap: onPracticeArena,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ModeCard(
              title: AppLocalizations.of(context)!.adventureIsland,
              badge: AppLocalizations.of(context)!.storyModeBadge,
              badgeColor: const Color(0xFFF0FDF4),
              badgeTextColor: const Color(0xFF16A34A),
              subtitle: AppLocalizations.of(context)!.adventureDescription,
              cta: AppLocalizations.of(context)!.exploreAction,
              icon: '🏝️',
              onTap: onAdventureIsland,
            ),
            const SizedBox(width: 12),
            _ModeCard(
              title: AppLocalizations.of(context)!.buddyChallenge,
              badge: AppLocalizations.of(context)!.twoPlayersBadge,
              badgeColor: const Color(0xFFFAF5FF),
              badgeTextColor: const Color(0xFF9333EA),
              subtitle: AppLocalizations.of(context)!.buddyDescription,
              cta: AppLocalizations.of(context)!.battleAction,
              icon: '👥',
              onTap: onBuddyChallenge,
            ),
          ],
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String badge;
  final Color badgeColor;
  final Color badgeTextColor;
  final String subtitle;
  final String cta;
  final String icon;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.subtitle,
    required this.cta,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
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
                  Text(icon, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                cta,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDarkBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
