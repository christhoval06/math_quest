import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class BuddyScoreDivider extends StatelessWidget {
  final int player1Score;
  final int player2Score;
  final int pointsToWin;
  final VoidCallback onClose;

  const BuddyScoreDivider({
    super.key,
    required this.player1Score,
    required this.player2Score,
    required this.pointsToWin,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: AppColors.textPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onClose,
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!
                  .buddyScore(player1Score, player2Score),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ),
          Flexible(
            child: Text(
              AppLocalizations.of(context)!.firstToPoints(pointsToWin),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.secondaryOrange,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
