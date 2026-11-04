import 'package:math_quest/features/profile_and_stats/presentation/models/home_dashboard_localizations.dart';
import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart';

class SuperpowerTipCard extends StatelessWidget {
  final SuperpowerTipViewData data;
  final VoidCallback onLaunch;

  const SuperpowerTipCard({
    super.key,
    required this.data,
    required this.onLaunch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(data.icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.superpowerTipHeading,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondaryOrange,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.localizedTitle(AppLocalizations.of(context)!),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.localizedDescription(AppLocalizations.of(context)!),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: onLaunch,
            child: Text(
              AppLocalizations.of(context)!.tryNextChallenge,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDarkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
