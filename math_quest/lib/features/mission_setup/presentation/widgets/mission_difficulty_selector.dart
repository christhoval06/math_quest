import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';

class MissionDifficultySelector extends StatelessWidget {
  final DifficultyLevel selectedDifficulty;
  final ValueChanged<DifficultyLevel> onSelected;

  const MissionDifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(),
        const SizedBox(height: 12),
        _tile(
          DifficultyLevel.easy,
          AppLocalizations.of(context)!.difficultyEasy,
          AppLocalizations.of(context)!.easyDigits,
          AppLocalizations.of(context)!.easyDescription,
        ),
        const SizedBox(height: 10),
        _tile(
          DifficultyLevel.medium,
          AppLocalizations.of(context)!.difficultyMedium,
          AppLocalizations.of(context)!.mediumDigits,
          AppLocalizations.of(context)!.mediumDescription,
        ),
        const SizedBox(height: 10),
        _tile(
          DifficultyLevel.hard,
          AppLocalizations.of(context)!.difficultyHard,
          AppLocalizations.of(context)!.hardDigits,
          AppLocalizations.of(context)!.hardDescription,
        ),
      ],
    );
  }

  Widget _tile(
    DifficultyLevel difficulty,
    String title,
    String badge,
    String description,
  ) {
    final selected = selectedDifficulty == difficulty;
    return InkWell(
      onTap: () => onSelected(difficulty),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.successGreen : AppColors.borderLight,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? AppColors.successGreen : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          badge,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 11,
          backgroundColor: AppColors.secondaryOrange,
          child: Text(
            '2',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.chooseDifficulty,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
