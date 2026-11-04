import 'package:flutter/material.dart';
import 'package:math_quest/features/gameplay/presentation/models/gameplay_localizations.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class AdventureBossBanner extends StatelessWidget {
  final String bossName;
  final String bossEmoji;
  final Color primaryColor;

  const AdventureBossBanner({
    super.key,
    required this.bossName,
    required this.bossEmoji,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(bossEmoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              AppLocalizations.of(context)!.targetBoss(
                localizedAdventureLandmark(
                  AppLocalizations.of(context)!,
                  bossName,
                ),
              ),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
