import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';

class SettingsResponseModeSelector extends StatelessWidget {
  final ResponseMode selectedMode;
  final ValueChanged<ResponseMode> onChanged;

  const SettingsResponseModeSelector({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.responseMode,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context)!.responseModeDescription,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _ModeCard(
                mode: ResponseMode.choice,
                title: AppLocalizations.of(context)!.responseChoice,
                subtitle: AppLocalizations.of(context)!
                    .responseChoiceDescription,
                icon: Icons.grid_view_rounded,
                isSelected: selectedMode == ResponseMode.choice,
                onTap: onChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ModeCard(
                mode: ResponseMode.write,
                title: AppLocalizations.of(context)!.responseWrite,
                subtitle: AppLocalizations.of(context)!
                    .responseWriteDescription,
                icon: Icons.edit_rounded,
                isSelected: selectedMode == ResponseMode.write,
                onTap: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  final ResponseMode mode;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<ResponseMode> onTap;

  const _ModeCard({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.accentPurple : AppColors.textMuted;
    return Semantics(
      selected: isSelected,
      button: true,
      label: AppLocalizations.of(context)!.responseModeSemantics(title),
      child: InkWell(
        key: Key('response-mode-${mode.name}'),
        onTap: () => onTap(mode),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accentPurple.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.accentPurple
                  : AppColors.borderLight,
              width: isSelected ? 2.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 22),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.accentPurple,
                      size: 17,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isSelected
                      ? AppColors.accentPurple
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
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
