import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class SettingsLanguageSelector extends StatelessWidget {
  final String localeCode;
  final ValueChanged<String> onChanged;

  const SettingsLanguageSelector({
    super.key,
    required this.localeCode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.language,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.selectLanguage,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              DropdownButton<String>(
                value: localeCode,
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(14),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('🇺🇸 English')),
                  DropdownMenuItem(value: 'es', child: Text('🇪🇸 Español')),
                  DropdownMenuItem(value: 'pt', child: Text('🇧🇷 Português')),
                ],
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
