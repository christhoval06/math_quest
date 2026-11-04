import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/core/audio/sound_provider.dart';
import 'package:math_quest/core/haptics/haptic_provider.dart';
import 'package:math_quest/core/localization/locale_provider.dart';
import 'package:math_quest/core/services/screen_time_provider.dart';
import 'package:math_quest/core/theme/theme_provider.dart';
import 'package:math_quest/features/gameplay/presentation/providers/adventure_provider.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';
import 'package:math_quest/features/settings_and_parent_gate/data/providers/settings_repository_provider.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/settings_preferences.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/controllers/settings_controller.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/settings_state.dart';

class _SettingsPreferencesNotifier extends StateNotifier<SettingsPreferences> {
  _SettingsPreferencesNotifier(super.state);

  void replace(SettingsPreferences preferences) => state = preferences;
}

final _settingsPreferencesProvider =
    StateNotifierProvider<_SettingsPreferencesNotifier, SettingsPreferences>((
      ref,
    ) {
      final repository = ref.watch(settingsRepositoryProvider);
      return _SettingsPreferencesNotifier(repository.loadPreferences());
    });

final settingsProvider = Provider<SettingsState>((ref) {
  final preferences = ref.watch(_settingsPreferencesProvider);
  final activeProfile = ref.watch(profileNotifierProvider);
  final profilesValue = ref.watch(allProfilesProvider);
  final theme = ref.watch(visualThemeProvider);
  final locale = ref.watch(localeProvider);

  var profilesStatus = SettingsProfilesStatus.loading;
  var profiles = const <UserProfile>[];
  Object? profilesError;
  profilesValue.when(
    data: (value) {
      profilesStatus = SettingsProfilesStatus.data;
      profiles = value;
    },
    loading: () {},
    error: (error, _) {
      profilesStatus = SettingsProfilesStatus.error;
      profilesError = error;
    },
  );

  return SettingsState.fromSources(
    preferences: preferences,
    profilesStatus: profilesStatus,
    profiles: profiles,
    profilesError: profilesError,
    activeProfile: activeProfile,
    selectedTheme: theme.type,
    localeCode: locale.languageCode,
  );
});

final responseModeProvider = Provider<ResponseMode>((ref) {
  return ref.watch(
    _settingsPreferencesProvider.select(
      (preferences) => preferences.responseMode,
    ),
  );
});

final settingsControllerProvider = Provider<SettingsController>((ref) {
  final preferencesNotifier = ref.watch(_settingsPreferencesProvider.notifier);
  final random = Random();
  final controller = SettingsController(
    readPreferences: () => ref.read(_settingsPreferencesProvider),
    writePreferences: preferencesNotifier.replace,
    readActiveProfileId: () => ref.read(profileNotifierProvider)?.id,
    readTheme: () => ref.read(visualThemeProvider).type,
    readLocaleCode: () => ref.read(localeProvider).languageCode,
    repository: ref.read(settingsRepositoryProvider),
    soundService: ref.read(soundServiceProvider),
    hapticService: ref.read(hapticServiceProvider),
    switchProfileAction: (profileId) =>
        ref.read(profileNotifierProvider.notifier).switchProfile(profileId),
    setThemeAction: (type) =>
        ref.read(visualThemeProvider.notifier).setTheme(type),
    setLocaleAction: (languageCode) =>
        ref.read(localeProvider.notifier).setLocale(languageCode),
    updateScreenLimitAction: (minutes) =>
        ref.read(screenTimeProvider.notifier).updateLimitFromSettings(minutes),
    resetAdventureAction: () =>
        ref.read(adventureProvider.notifier).resetAdventureProgress(),
    parentGateGenerator: ParentGateChallengeGenerator(random.nextInt),
  );
  controller.synchronizeAudio();
  controller.synchronizeHaptics();
  return controller;
});

/// Eager app-level hook that applies persisted runtime preferences before
/// gameplay can emit sound or haptic feedback.
final settingsRuntimeInitializationProvider = Provider<void>((ref) {
  ref.watch(settingsControllerProvider);
});
