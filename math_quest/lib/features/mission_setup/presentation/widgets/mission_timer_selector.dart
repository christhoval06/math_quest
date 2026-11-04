import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class MissionTimerSelector extends StatelessWidget {
  final int selectedSeconds;
  final ValueChanged<int> onSelected;

  const MissionTimerSelector({
    super.key,
    required this.selectedSeconds,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(),
        const SizedBox(height: 12),
        Row(
          children: [
            _pill(
              0,
              AppLocalizations.of(context)!.noTimer,
              AppLocalizations.of(context)!.relaxAndLearn,
            ),
            const SizedBox(width: 10),
            _pill(
              30,
              AppLocalizations.of(context)!.secondsCount(30),
              AppLocalizations.of(context)!.rapidDash,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _pill(
              60,
              AppLocalizations.of(context)!.secondsCount(60),
              AppLocalizations.of(context)!.standardPace,
            ),
            const SizedBox(width: 10),
            _pill(
              120,
              AppLocalizations.of(context)!.twoMinutes,
              AppLocalizations.of(context)!.deepFocus,
            ),
          ],
        ),
      ],
    );
  }

  Widget _pill(int seconds, String title, String subtitle) {
    final selected = selectedSeconds == seconds;
    return Expanded(
      child: InkWell(
        onTap: () => onSelected(seconds),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEFF6FF) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primaryBlue : AppColors.borderLight,
              width: selected ? 2 : 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: selected
                      ? AppColors.primaryDarkBlue
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
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
            '3',
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
            AppLocalizations.of(context)!.chooseTimer,
            style: const TextStyle(
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
