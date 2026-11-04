import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class ResetProgressDialog extends StatelessWidget {
  const ResetProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        AppLocalizations.of(context)!.resetProgressTitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(AppLocalizations.of(context)!.resetProgressDescription),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            AppLocalizations.of(context)!.resetNow,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
