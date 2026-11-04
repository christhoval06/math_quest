import 'package:math_quest/core/theme/visual_theme_model.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/settings_preferences.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';

enum SettingsProfilesStatus { loading, data, error }

class SettingsProfileViewData {
  final String id;
  final String name;
  final String gradeLabel;
  final String avatar;
  final int level;
  final int starCoins;
  final bool isActive;

  const SettingsProfileViewData({
    required this.id,
    required this.name,
    required this.gradeLabel,
    required this.avatar,
    required this.level,
    required this.starCoins,
    required this.isActive,
  });
}

class SettingsState {
  final SettingsPreferences preferences;
  final SettingsProfilesStatus profilesStatus;
  final List<SettingsProfileViewData> profiles;
  final String? profilesErrorMessage;
  final String? activeProfileId;
  final int starCoins;
  final VisualThemeType selectedTheme;
  final String localeCode;
  final String targetMathStandard;

  SettingsState({
    required this.preferences,
    required this.profilesStatus,
    required List<SettingsProfileViewData> profiles,
    required this.profilesErrorMessage,
    required this.activeProfileId,
    required this.starCoins,
    required this.selectedTheme,
    required this.localeCode,
    required this.targetMathStandard,
  }) : profiles = List.unmodifiable(profiles);

  factory SettingsState.fromSources({
    required SettingsPreferences preferences,
    required SettingsProfilesStatus profilesStatus,
    required List<UserProfile> profiles,
    required Object? profilesError,
    required UserProfile? activeProfile,
    required VisualThemeType selectedTheme,
    required String localeCode,
  }) {
    return SettingsState(
      preferences: preferences,
      profilesStatus: profilesStatus,
      profiles: profiles
          .map(
            (profile) => SettingsProfileViewData(
              id: profile.id,
              name: profile.name,
              gradeLabel: profile.gradeLabel,
              avatar: profile.avatar,
              level: profile.level,
              starCoins: profile.starCoins,
              isActive: profile.id == activeProfile?.id,
            ),
          )
          .toList(growable: false),
      profilesErrorMessage: profilesError?.toString(),
      activeProfileId: activeProfile?.id,
      starCoins: activeProfile?.starCoins ?? 340,
      selectedTheme: selectedTheme,
      localeCode: localeCode,
      targetMathStandard: activeProfile == null
          ? 'Grade 2'
          : preferences.targetMathStandardFor(
              activeProfile.id,
              activeProfile.gradeLabel,
            ),
    );
  }

  double get sfxVolume => preferences.sfxVolume;

  double get musicVolume => preferences.musicVolume;

  bool get voiceReadAloud => preferences.voiceReadAloud;

  bool get hapticBuzz => preferences.hapticBuzz;

  int get screenLimitMinutes => preferences.screenLimitMinutes;

  ResponseMode get responseMode => preferences.responseMode;

  SettingsProfileViewData? get activeProfile {
    for (final profile in profiles) {
      if (profile.isActive) return profile;
    }
    return null;
  }
}
