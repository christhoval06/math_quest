import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/profile_localizations.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class WelcomeProfilePill extends StatelessWidget {
  final String avatar;
  final String name;
  final String gradeLabel;
  final VoidCallback onTap;

  const WelcomeProfilePill({
    super.key,
    required this.avatar,
    required this.name,
    required this.gradeLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(avatar, style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.playingAs(
                  name,
                  localizedProfileGrade(
                    AppLocalizations.of(context)!,
                    gradeLabel,
                  ),
                ),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
