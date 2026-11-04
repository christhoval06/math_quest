import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/profile_localizations.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/welcome_splash_state.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class WelcomeProfileSwitcher extends StatelessWidget {
  final WelcomeSplashState state;
  final Future<void> Function(String profileId) onProfileSelected;
  final VoidCallback onAddProfile;

  const WelcomeProfileSwitcher({
    super.key,
    required this.state,
    required this.onProfileSelected,
    required this.onAddProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.whosPlaying,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context)!.profileSwitcherDescription,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _profilesContent(context),
        if (state.profilesStatus == WelcomeProfilesStatus.data &&
            state.canAddProfile)
          OutlinedButton.icon(
            onPressed: onAddProfile,
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              size: 18,
              color: AppColors.primaryDarkBlue,
            ),
            label: Text(
              AppLocalizations.of(context)!.addChildProfile,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.primaryDarkBlue,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderLight, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _profilesContent(BuildContext context) {
    switch (state.profilesStatus) {
      case WelcomeProfilesStatus.loading:
        return const Center(
          key: Key('welcome-profiles-loading'),
          child: CircularProgressIndicator(),
        );
      case WelcomeProfilesStatus.error:
        return const SizedBox(key: Key('welcome-profiles-error'), height: 48);
      case WelcomeProfilesStatus.data:
        if (state.profiles.isEmpty) {
          return const SizedBox(key: Key('welcome-profiles-empty'), height: 8);
        }
        return Column(
          children: [
            for (final profile in state.profiles) _profileRow(context, profile),
          ],
        );
    }
  }

  Widget _profileRow(BuildContext context, WelcomeProfileViewData profile) {
    return Semantics(
      button: true,
      selected: profile.isActive,
      child: InkWell(
        key: Key('welcome-profile-${profile.id}'),
        onTap: () => onProfileSelected(profile.id),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 10),
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
                backgroundColor: const Color(0xFFF1F5F9),
                child: Text(
                  profile.avatar,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${localizedProfileGrade(AppLocalizations.of(context)!, profile.gradeLabel)} • 🪙 ${profile.starCoins}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (profile.isActive)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.successGreen,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
