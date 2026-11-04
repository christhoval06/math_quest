import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class MissionQuestionSelector extends StatelessWidget {
  final int selectedCount;
  final bool isExamMode;
  final ValueChanged<int> onChanged;

  const MissionQuestionSelector({
    super.key,
    required this.selectedCount,
    required this.isExamMode,
    required this.onChanged,
  });

  Color get _accent =>
      isExamMode ? AppColors.secondaryOrange : AppColors.primaryBlue;

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
                '5',
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
                AppLocalizations.of(context)!.numberOfQuestions,
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
              AppLocalizations.of(context)!.questionCount(selectedCount),
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
                value: selectedCount.toDouble(),
                min: 10,
                max: 50,
                divisions: 8,
                activeColor: _accent,
                inactiveColor: const Color(0xFFE2E8F0),
                label: AppLocalizations.of(context)!
                    .questionCount(selectedCount),
                onChanged: (value) => onChanged(value.toInt()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [10, 15, 25, 50].map((count) {
                  final selected = selectedCount == count;
                  return InkWell(
                    onTap: () => onChanged(count),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? _accent : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: selected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
