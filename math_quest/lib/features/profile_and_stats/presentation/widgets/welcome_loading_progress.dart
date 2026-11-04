import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/l10n/app_localizations.dart';

String welcomeLoadingStatus(double progress, AppLocalizations l10n) {
  if (progress < 0.45) return l10n.chargingBoosters;
  if (progress < 0.90) return l10n.warmingSuperpowers;
  return l10n.readyForAdventure;
}

class WelcomeLoadingProgress extends StatelessWidget {
  final double progress;

  const WelcomeLoadingProgress({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).toInt();
    final ready = progress >= 0.95;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  welcomeLoadingStatus(progress, AppLocalizations.of(context)!),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: ready
                      ? AppColors.successGreen
                      : AppColors.secondaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation(
                ready ? AppColors.successGreen : AppColors.secondaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
