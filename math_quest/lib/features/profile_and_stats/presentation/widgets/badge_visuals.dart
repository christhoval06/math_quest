import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/all_badges_state.dart';
import 'package:math_quest/l10n/app_localizations.dart';

Color badgeTierColor(BadgeTier tier) => switch (tier) {
  BadgeTier.bronze => const Color(0xFF9A542D),
  BadgeTier.silver => const Color(0xFF52657C),
  BadgeTier.gold => const Color(0xFF9A690D),
  BadgeTier.diamond => const Color(0xFF6554C0),
};

/// A consistent, softly tinted setting for each achievement's artwork.
class BadgeEmblem extends StatelessWidget {
  final BadgeViewData badge;
  final double size;

  const BadgeEmblem({super.key, required this.badge, required this.size});

  @override
  Widget build(BuildContext context) {
    final color = badgeTierColor(badge.tier);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: badge.isUnlocked ? 0.1 : 0.06),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Center(
        child: ExcludeSemantics(
          child: Text(
            badge.icon,
            textScaler: TextScaler.noScaling,
            style: TextStyle(fontSize: size * 0.46, height: 1),
          ),
        ),
      ),
    );
  }
}

class BadgeMetadata extends StatelessWidget {
  final BadgeViewData badge;
  final bool compact;

  const BadgeMetadata({super.key, required this.badge, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = badgeTierColor(badge.tier);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        _tag(l10n.badgeTier(badge.tier.name), color),
        _tag(
          l10n.badgeCategory(badge.category, badge.category),
          AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _tag(String text, Color color) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 6 : 12,
      vertical: compact ? 4 : 7,
    ),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: compact ? 9 : 11,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0.25,
      ),
    ),
  );
}

class BadgeStatus extends StatelessWidget {
  final BadgeViewData badge;
  final bool compact;

  const BadgeStatus({super.key, required this.badge, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = badge.isUnlocked
        ? const Color(0xFF26815B)
        : AppColors.textSecondary;
    final label = (badge.isUnlocked ? l10n.badgeUnlocked : l10n.badgeLocked)
        .replaceFirst('✅ ', '')
        .replaceFirst('🔒 ', '');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(
            badge.isUnlocked
                ? Icons.check_circle_outline_rounded
                : Icons.lock_outline_rounded,
            size: compact ? 13 : 16,
            color: color,
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
