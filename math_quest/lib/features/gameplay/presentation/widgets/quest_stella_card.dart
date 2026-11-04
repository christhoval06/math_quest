import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class QuestStellaCard extends StatelessWidget {
  final int accuracyPercentage;
  final String profileName;

  const QuestStellaCard({
    super.key,
    required this.accuracyPercentage,
    this.profileName = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        children: [
          const Text('🌟', style: TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.stellaCoach,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFB45309),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  accuracyPercentage >= 90
                      ? AppLocalizations.of(context)!.stellaExcellent(
                          profileName.isEmpty
                              ? AppLocalizations.of(context)!.explorerLabel
                              : profileName,
                        )
                      : AppLocalizations.of(context)!.stellaEncouragement,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF78350F),
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
