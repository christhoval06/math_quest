import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';
import 'package:math_quest/features/gameplay/presentation/models/gameplay_localizations.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class LevelNodeWidget extends StatelessWidget {
  final AdventureLevel level;
  final VoidCallback onTap;

  const LevelNodeWidget({super.key, required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLocked = level.status == LevelStatus.locked;
    final isActive = level.status == LevelStatus.active;
    final isCompleted = level.status == LevelStatus.completed;

    Color nodeColor;
    if (isCompleted) {
      nodeColor = AppColors.successGreen;
    } else if (isActive) {
      nodeColor = AppColors.secondaryOrange;
    } else {
      nodeColor = const Color(0xFFCBD5E1); // Muted Slate
    }

    return Column(
      children: [
        GestureDetector(
          onTap: isLocked ? null : onTap,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Outer Glowing Ring for Active Level
              if (isActive)
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.secondaryOrange.withValues(alpha: 0.4),
                      width: 6,
                    ),
                  ),
                ),

              // Main Circular Button
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: nodeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: nodeColor.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: isLocked
                      ? const Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 26,
                        )
                      : Text(
                          level.isBoss ? '👑' : '${level.levelNumber}',
                          style: TextStyle(
                            fontSize: level.isBoss ? 28 : 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              // Star Rating for Completed Levels
              if (isCompleted)
                Positioned(
                  bottom: -10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        return Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: i < level.stars
                              ? AppColors.secondaryOrange
                              : const Color(0xFFE2E8F0),
                        );
                      }),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          localizedAdventureLandmark(
            AppLocalizations.of(context)!,
            level.title,
          ),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isLocked ? AppColors.textMuted : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
