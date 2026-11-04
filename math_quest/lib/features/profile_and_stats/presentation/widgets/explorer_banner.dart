import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class ExplorerBanner extends StatelessWidget {
  final String profileName;
  final Color primaryColor;
  final Color secondaryColor;
  final Color borderColor;
  final int streakDays;
  final int stars;
  final int level;
  final VoidCallback onOpenTrophyRoom;

  const ExplorerBanner({
    super.key,
    this.profileName = '',
    required this.primaryColor,
    required this.secondaryColor,
    required this.borderColor,
    required this.streakDays,
    required this.stars,
    required this.level,
    required this.onOpenTrophyRoom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.08),
            secondaryColor.withValues(alpha: 0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileName.isEmpty
                          ? AppLocalizations.of(context)!.explorerLabel
                          : AppLocalizations.of(context)!
                                .explorerName(profileName),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFB45309),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.readyForQuest,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF78350F),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context)!.starryWaiting,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Text('🚀', style: TextStyle(fontSize: 28)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onOpenTrophyRoom,
            child: Row(
              children: [
                _MiniStat(
                  icon: '🔥',
                  label: AppLocalizations.of(context)!.daysCount(streakDays),
                  sub: AppLocalizations.of(context)!.streakLabel,
                ),
                const SizedBox(width: 8),
                _MiniStat(
                  icon: '⭐',
                  label: '$stars',
                  sub: AppLocalizations.of(context)!.starsLabel,
                ),
                const SizedBox(width: 8),
                _MiniStat(
                  icon: '🛡️',
                  label: AppLocalizations.of(context)!.profileLevel(level),
                  sub: AppLocalizations.of(context)!.rankLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String icon;
  final String label;
  final String sub;

  const _MiniStat({required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
