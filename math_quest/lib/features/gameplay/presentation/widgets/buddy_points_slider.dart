import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class BuddyPointsSlider extends StatelessWidget {
  final int selectedPoints;
  final List<int> allowedPoints;
  final ValueChanged<int> onChanged;

  const BuddyPointsSlider({
    super.key,
    required this.selectedPoints,
    required this.allowedPoints,
    required this.onChanged,
  }) : assert(allowedPoints.length > 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 11,
              backgroundColor: AppColors.secondaryOrange,
              child: Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.pointsToWin,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.pointsCount(selectedPoints),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: AppColors.primaryDarkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              Slider(
                value: selectedPoints.toDouble(),
                min: allowedPoints.first.toDouble(),
                max: allowedPoints.last.toDouble(),
                divisions: allowedPoints.length - 1,
                activeColor: AppColors.primaryBlue,
                inactiveColor: const Color(0xFFE2E8F0),
                label: AppLocalizations.of(context)!
                    .pointsCount(selectedPoints),
                onChanged: (value) => onChanged(value.round()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${allowedPoints.first}', style: _endpointStyle),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.pointsTargetDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  Text('${allowedPoints.last}', style: _endpointStyle),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const _endpointStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w800,
  color: AppColors.textSecondary,
);
