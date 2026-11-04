import 'package:math_quest/features/profile_and_stats/presentation/models/home_dashboard_localizations.dart';
import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart';

class DailyMissionCard extends StatelessWidget {
  final DailyMissionViewData data;
  final Color primaryColor;
  final Future<void> Function() onClaim;
  final VoidCallback onContinue;

  const DailyMissionCard({
    super.key,
    required this.data,
    required this.primaryColor,
    required this.onClaim,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = data.status != DailyMissionStatus.inProgress;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('🎯', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context)!.todaysMission,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+${data.coinReward}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.localizedTitle(AppLocalizations.of(context)!),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: data.progressFraction,
              minHeight: 10,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation(
                isCompleted
                    ? AppColors.successGreen
                    : AppColors.secondaryOrange,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .missionProgress(data.currentProgress, data.targetCount),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                '${data.progressPercent}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isCompleted
                      ? AppColors.successGreen
                      : AppColors.secondaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.dailyMissionReward(
              data.coinReward,
              data.localizedBadge(AppLocalizations.of(context)!),
            ),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0288D1),
            ),
          ),
          const SizedBox(height: 14),
          _buildAction(context),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    switch (data.status) {
      case DailyMissionStatus.claimed:
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.successGreen,
                size: 20,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  AppLocalizations.of(context)!.missionCompletedToday,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.successGreen,
                  ),
                ),
              ),
            ],
          ),
        );
      case DailyMissionStatus.readyToClaim:
        return _ClaimMissionButton(
          coinReward: data.coinReward,
          primaryColor: primaryColor,
          onClaim: onClaim,
        );
      case DailyMissionStatus.inProgress:
        return ElevatedButton(
          onPressed: onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryOrange,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.continueMission,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        );
    }
  }
}

class _ClaimMissionButton extends StatefulWidget {
  final int coinReward;
  final Color primaryColor;
  final Future<void> Function() onClaim;

  const _ClaimMissionButton({
    required this.coinReward,
    required this.primaryColor,
    required this.onClaim,
  });

  @override
  State<_ClaimMissionButton> createState() => _ClaimMissionButtonState();
}

class _ClaimMissionButtonState extends State<_ClaimMissionButton> {
  bool _isClaiming = false;

  Future<void> _claim() async {
    if (_isClaiming) return;
    setState(() => _isClaiming = true);
    try {
      await widget.onClaim();
    } finally {
      if (mounted) setState(() => _isClaiming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isClaiming ? null : _claim,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.primaryColor,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        AppLocalizations.of(context)!.claimMissionReward(widget.coinReward),
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
