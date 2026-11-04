import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.safeKidsEdition('1.0.0'),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            AppLocalizations.of(context)!.localProgressBackup,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
