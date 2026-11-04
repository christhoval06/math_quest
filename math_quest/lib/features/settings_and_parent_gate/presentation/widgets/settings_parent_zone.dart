import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class SettingsParentZone extends StatelessWidget {
  static const screenLimits = [15, 30, 45, 0];
  static const targetStandards = ['Pre-K', 'Grade 1', 'Grade 2', 'Grade 3+'];

  final String activeProfileName;
  final int screenLimitMinutes;
  final String targetMathStandard;
  final Color primaryColor;
  final ValueChanged<int> onScreenLimitSelected;
  final ValueChanged<String> onTargetStandardSelected;
  final VoidCallback onResetProgress;

  const SettingsParentZone({
    super.key,
    required this.activeProfileName,
    required this.screenLimitMinutes,
    required this.targetMathStandard,
    required this.primaryColor,
    required this.onScreenLimitSelected,
    required this.onTargetStandardSelected,
    required this.onResetProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ParentZoneIcon(),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.parentZone,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.parentZoneDescription,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            AppLocalizations.of(context)!.dailyScreenLimit(activeProfileName),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _ChoiceRow<int>(
            values: screenLimits,
            selected: screenLimitMinutes,
            labelFor: (minutes) => minutes == 0
                ? AppLocalizations.of(context)!.unlimited
                : AppLocalizations.of(context)!.minutesShort(minutes),
            selectedColor: primaryColor,
            onSelected: onScreenLimitSelected,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.targetMathStandard,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _ChoiceRow<String>(
            values: targetStandards,
            selected: targetMathStandard,
            labelFor: (standard) => switch (standard) {
              'Pre-K' => AppLocalizations.of(context)!.gradePreK,
              'Grade 1' => AppLocalizations.of(context)!.gradeOne,
              'Grade 2' => AppLocalizations.of(context)!.gradeTwo,
              'Grade 3+' => AppLocalizations.of(context)!.gradeThreePlus,
              _ => standard,
            },
            selectedColor: const Color(0xFF0284C7),
            onSelected: onTargetStandardSelected,
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onResetProgress,
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.errorRed,
              size: 18,
            ),
            label: Text(
              AppLocalizations.of(context)!.resetCurrentHero,
              style: const TextStyle(
                color: AppColors.errorRed,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParentZoneIcon extends StatelessWidget {
  const _ParentZoneIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.lock_rounded,
        color: AppColors.textPrimary,
        size: 20,
      ),
    );
  }
}

class _ChoiceRow<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final String Function(T value) labelFor;
  final Color selectedColor;
  final ValueChanged<T> onSelected;

  const _ChoiceRow({
    required this.values,
    required this.selected,
    required this.labelFor,
    required this.selectedColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: values
          .map(
            (value) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  onTap: () => onSelected(value),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: selected == value ? selectedColor : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected == value
                            ? selectedColor
                            : AppColors.borderLight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        labelFor(value),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: selected == value
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
