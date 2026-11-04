import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/profile_localizations.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/settings_state.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class SettingsProfilesSection extends StatelessWidget {
  final SettingsProfilesStatus status;
  final List<SettingsProfileViewData> profiles;
  final String? errorMessage;
  final ValueChanged<String> onSwitchProfile;
  final VoidCallback onAddProfile;

  const SettingsProfilesSection({
    super.key,
    required this.status,
    required this.profiles,
    this.errorMessage,
    required this.onSwitchProfile,
    required this.onAddProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.whosPlaying,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.profileSlotsUsed(profiles.length),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (status == SettingsProfilesStatus.loading)
          const Center(child: CircularProgressIndicator())
        else if (status == SettingsProfilesStatus.error)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.errorBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              AppLocalizations.of(context)!.profilesUnavailable,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.errorRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else ...[
          for (final profile in profiles) ...[
            _ProfileCard(
              profile: profile,
              onSwitch: () => onSwitchProfile(profile.id),
            ),
            const SizedBox(height: 10),
          ],
          if (profiles.length < 3)
            OutlinedButton.icon(
              onPressed: onAddProfile,
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                size: 18,
                color: AppColors.primaryDarkBlue,
              ),
              label: Text(
                AppLocalizations.of(context)!.addChildProfile,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.primaryDarkBlue,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppColors.borderLight,
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.allProfileSlotsUsed,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final SettingsProfileViewData profile;
  final VoidCallback onSwitch;

  const _ProfileCard({required this.profile, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: profile.isActive ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: profile.isActive
              ? AppColors.successGreen
              : AppColors.borderLight,
          width: profile.isActive ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE2E8F0),
            child: Text(profile.avatar, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .profileLevel(profile.level),
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
                  '${localizedProfileGrade(AppLocalizations.of(context)!, profile.gradeLabel)} • 🪙 ${profile.starCoins}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (profile.isActive)
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.successGreen,
                  size: 20,
                ),
                SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!.profileActive,
                  style: const TextStyle(
                    color: AppColors.successGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          else
            TextButton(
              onPressed: onSwitch,
              child: Text(
                AppLocalizations.of(context)!.switchProfile,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.primaryDarkBlue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
