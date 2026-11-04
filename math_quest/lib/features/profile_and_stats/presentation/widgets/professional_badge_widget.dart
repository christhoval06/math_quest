import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/all_badges_state.dart';

class ProfessionalBadgeWidget extends StatelessWidget {
  final BadgeViewData badge;
  final double size;

  const ProfessionalBadgeWidget({
    super.key,
    required this.badge,
    this.size = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 Metallic Tier Gradients
    List<Color> gradientColors;
    Color borderColor;
    Color ribbonColor;

    if (!badge.isUnlocked) {
      // Locked: Matte Slate Metal
      gradientColors = [const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)];
      borderColor = const Color(0xFF94A3B8);
      ribbonColor = const Color(0xFF64748B);
    } else {
      switch (badge.tier) {
        case BadgeTier.bronze:
          gradientColors = [const Color(0xFFFDBA74), const Color(0xFFC2410C)];
          borderColor = const Color(0xFF9A3412);
          ribbonColor = const Color(0xFFC2410C);
          break;
        case BadgeTier.silver:
          gradientColors = [const Color(0xFFF8FAFC), const Color(0xFF94A3B8)];
          borderColor = const Color(0xFF64748B);
          ribbonColor = const Color(0xFF475569);
          break;
        case BadgeTier.gold:
          gradientColors = [const Color(0xFFFEF08A), const Color(0xFFF59E0B)];
          borderColor = const Color(0xFFD97706);
          ribbonColor = const Color(0xFFB45309);
          break;
        case BadgeTier.diamond:
          gradientColors = [const Color(0xFFBAE6FD), const Color(0xFF6366F1)];
          borderColor = const Color(0xFF4338CA);
          ribbonColor = const Color(0xFF4F46E5);
          break;
      }
    }

    return FittedBox(
      fit: BoxFit.scaleDown, // 👈 Scales down gracefully if height is tight!
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // 1. Outer Beveled Metallic Ring
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: badge.isUnlocked
                          ? borderColor.withOpacity(0.35)
                          : Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: borderColor, width: size * 0.04),
                ),
              ),

              // 2. Inner Recessed Plate
              Container(
                width: size * 0.78,
                height: size * 0.78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badge.isUnlocked
                      ? Colors.white
                      : const Color(0xFFF1F5F9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    badge.isUnlocked ? badge.icon : '🔒',
                    style: TextStyle(
                      fontSize: size * 0.38,
                      color: badge.isUnlocked ? null : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ),

              // 3. Top-Light Glossy Sheen Reflection
              if (badge.isUnlocked)
                Positioned(
                  top: size * 0.08,
                  child: Container(
                    width: size * 0.52,
                    height: size * 0.22,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.all(
                        Radius.elliptical(size * 0.5, size * 0.2),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),

          // 4. Ribbon Tag (e.g. "SPEED", "MASTERY")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: ribbonColor.withOpacity(badge.isUnlocked ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: ribbonColor.withOpacity(badge.isUnlocked ? 0.3 : 0.15),
                width: 0.8,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!
                  .badgeCategory(badge.category, badge.category),
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: badge.isUnlocked ? ribbonColor : const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
