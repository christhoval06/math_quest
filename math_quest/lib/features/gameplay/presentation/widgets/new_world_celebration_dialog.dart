import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/gameplay/presentation/models/adventure_island_state.dart';
import 'package:math_quest/features/gameplay/presentation/models/gameplay_localizations.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class NewWorldCelebrationDialog extends StatelessWidget {
  final AdventureCelebrationViewData celebration;
  final VoidCallback onAcknowledge;

  const NewWorldCelebrationDialog({
    super.key,
    required this.celebration,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Text(celebration.emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.worldBossDefeated,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.secondaryOrange,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.welcomeToWorld(
              localizedAdventureWorld(
                AppLocalizations.of(context)!,
                celebration.worldName,
              ),
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.newIslandDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: onAcknowledge,
            child: Text(
              AppLocalizations.of(context)!.exploreNewIsland,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
