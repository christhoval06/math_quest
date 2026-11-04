import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class MissionHelperToggles extends StatelessWidget {
  final bool visualAidsEnabled;
  final bool soundEnabled;
  final bool isExamMode;
  final ValueChanged<bool> onVisualAidsChanged;
  final ValueChanged<bool> onSoundChanged;

  const MissionHelperToggles({
    super.key,
    required this.visualAidsEnabled,
    required this.soundEnabled,
    required this.isExamMode,
    required this.onVisualAidsChanged,
    required this.onSoundChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(),
        const SizedBox(height: 12),
        Material(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.borderLight),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SwitchListTile(
                  value: visualAidsEnabled,
                  onChanged: isExamMode ? null : onVisualAidsChanged,
                  title: Text(
                    AppLocalizations.of(context)!.visualCountingAids,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!.visualAidsDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  activeThumbColor: AppColors.successGreen,
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: soundEnabled,
                  onChanged: onSoundChanged,
                  title: Text(
                    AppLocalizations.of(context)!.soundEffectsCheering,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!.soundCheeringDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  activeThumbColor: AppColors.successGreen,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ],
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
            '4',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          AppLocalizations.of(context)!.funHelpers,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
