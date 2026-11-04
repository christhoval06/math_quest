import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:math_quest/core/audio/i_sound_service.dart';
import 'package:math_quest/core/audio/sound_provider.dart';
import 'package:math_quest/core/haptics/haptic_provider.dart';
import 'package:math_quest/core/haptics/i_haptic_service.dart';
import 'package:math_quest/core/localization/locale_provider.dart';
import 'package:math_quest/core/theme/theme_provider.dart';
import 'package:math_quest/core/theme/visual_theme_model.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/domain/repositories/i_profile_repository.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';
import 'package:math_quest/features/settings_and_parent_gate/data/providers/settings_repository_provider.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/settings_preferences.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/repositories/i_settings_repository.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/settings_state.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/providers/settings_provider.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'math_quest_settings_provider_',
    );
    Hive.init(hiveDirectory.path);
    await Hive.openBox<dynamic>('app_settings_box');
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('state maps active profile coins and immutable profile view data', () {
    final source = <UserProfile>[_leo];

    final state = SettingsState.fromSources(
      preferences: SettingsPreferences(),
      profilesStatus: SettingsProfilesStatus.data,
      profiles: source,
      profilesError: null,
      activeProfile: _leo,
      selectedTheme: VisualThemeType.galaxyQuest,
      localeCode: 'en',
    );
    source.clear();

    expect(state.starCoins, 875);
    expect(state.activeProfileId, 'leo');
    expect(state.profiles, hasLength(1));
    expect(state.profiles.single.name, 'Leo');
    expect(state.profiles.single.isActive, isTrue);
    expect(
      () => state.profiles.add(state.profiles.single),
      throwsUnsupportedError,
    );
  });

  test('missing profiles use safe coin and target-standard fallbacks', () {
    final state = SettingsState.fromSources(
      preferences: SettingsPreferences(),
      profilesStatus: SettingsProfilesStatus.data,
      profiles: const [],
      profilesError: null,
      activeProfile: null,
      selectedTheme: VisualThemeType.galaxyQuest,
      localeCode: 'en',
    );

    expect(state.starCoins, 340);
    expect(state.activeProfileId, isNull);
    expect(state.targetMathStandard, 'Grade 2');
  });

  test('loading and error profile sources preserve preference state', () {
    final preferences = SettingsPreferences(
      sfxVolume: 0.25,
      musicVolume: 0.4,
      screenLimitMinutes: 45,
    );

    for (final status in [
      SettingsProfilesStatus.loading,
      SettingsProfilesStatus.error,
    ]) {
      final state = SettingsState.fromSources(
        preferences: preferences,
        profilesStatus: status,
        profiles: const [],
        profilesError: status == SettingsProfilesStatus.error
            ? StateError('profiles failed')
            : null,
        activeProfile: null,
        selectedTheme: VisualThemeType.candyLand,
        localeCode: 'es',
      );

      expect(state.sfxVolume, 0.25);
      expect(state.musicVolume, 0.4);
      expect(state.screenLimitMinutes, 45);
      expect(state.selectedTheme, VisualThemeType.candyLand);
      expect(state.localeCode, 'es');
    }
  });

  test('profile refresh updates cards without resetting preferences', () async {
    final profiles = _FakeProfileRepository([_leo], activeId: 'leo');
    final settings = _FakeSettingsRepository(
      SettingsPreferences(sfxVolume: 0.25, musicVolume: 0.4),
    );
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(profiles),
        settingsRepositoryProvider.overrideWithValue(settings),
      ],
    );
    addTearDown(container.dispose);

    await container.read(profileNotifierProvider.notifier).loadProfile();
    await container.read(allProfilesProvider.future);
    final initial = container.read(settingsProvider);
    expect(initial.sfxVolume, 0.25);
    expect(initial.profiles.single.starCoins, 875);

    profiles.savedProfiles = [_leo.copyWith(starCoins: 920)];
    await container.read(profileNotifierProvider.notifier).loadProfile();
    await container.read(allProfilesProvider.future);
    final refreshed = container.read(settingsProvider);

    expect(refreshed.sfxVolume, 0.25);
    expect(refreshed.musicVolume, 0.4);
    expect(refreshed.profiles.single.starCoins, 920);
  });

  test('profiles resolve independent saved standards and grade fallback', () {
    final preferences = SettingsPreferences(
      targetMathStandards: const {'leo': 'Grade 3+'},
    );

    final leoState = SettingsState.fromSources(
      preferences: preferences,
      profilesStatus: SettingsProfilesStatus.data,
      profiles: const [_leo, _mia],
      profilesError: null,
      activeProfile: _leo,
      selectedTheme: VisualThemeType.galaxyQuest,
      localeCode: 'en',
    );
    final miaState = SettingsState.fromSources(
      preferences: preferences,
      profilesStatus: SettingsProfilesStatus.data,
      profiles: const [_leo, _mia],
      profilesError: null,
      activeProfile: _mia,
      selectedTheme: VisualThemeType.galaxyQuest,
      localeCode: 'en',
    );

    expect(leoState.targetMathStandard, 'Grade 3+');
    expect(miaState.targetMathStandard, 'Grade 1');
  });

  test('theme and locale provider changes update composed state', () async {
    final profiles = _FakeProfileRepository([_leo], activeId: 'leo');
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(profiles),
        settingsRepositoryProvider.overrideWithValue(
          _FakeSettingsRepository(SettingsPreferences()),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(profileNotifierProvider.notifier).loadProfile();
    await container.read(allProfilesProvider.future);

    await container
        .read(visualThemeProvider.notifier)
        .setTheme(VisualThemeType.underwater);
    await container.read(localeProvider.notifier).setLocale('pt');

    final state = container.read(settingsProvider);
    expect(state.selectedTheme, VisualThemeType.underwater);
    expect(state.localeCode, 'pt');
  });

  test('response mode provider exposes the global preference', () {
    final container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(
          _FakeSettingsRepository(
            SettingsPreferences(responseMode: ResponseMode.write),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(responseModeProvider), ResponseMode.write);
  });

  test('runtime initialization applies persisted haptic preference', () {
    final haptics = _FakeHapticService();
    final container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(
          _FakeSettingsRepository(SettingsPreferences(hapticBuzz: false)),
        ),
        hapticServiceProvider.overrideWithValue(haptics),
        soundServiceProvider.overrideWithValue(_FakeSoundService()),
      ],
    );
    addTearDown(container.dispose);

    container.read(settingsRuntimeInitializationProvider);

    expect(haptics.enabled, isFalse);
  });
}

class _FakeHapticService implements IHapticService {
  bool? enabled;

  @override
  Future<void> selection() async {}

  @override
  Future<void> answerSubmitted() async {}

  @override
  Future<void> correctAnswer() async {}

  @override
  Future<void> incorrectAnswer() async {}

  @override
  void setEnabled(bool enabled) => this.enabled = enabled;
}

class _FakeSoundService implements ISoundService {
  @override
  Future<void> playTap() async {}

  @override
  Future<void> playCorrect() async {}

  @override
  Future<void> playWrong() async {}

  @override
  Future<void> playStar(int starIndex) async {}

  @override
  Future<void> playVictory() async {}

  @override
  void setSfxVolume(double volume) {}

  @override
  void setMusicVolume(double volume) {}
}

class _FakeSettingsRepository implements ISettingsRepository {
  SettingsPreferences preferences;

  _FakeSettingsRepository(this.preferences);

  @override
  SettingsPreferences loadPreferences() => preferences;

  @override
  Future<void> saveHapticBuzz(bool enabled) async {}

  @override
  Future<void> saveMusicVolume(double value) async {}

  @override
  Future<void> saveResponseMode(ResponseMode mode) async {}

  @override
  Future<void> saveScreenLimitMinutes(int minutes) async {}

  @override
  Future<void> saveSfxVolume(double value) async {}

  @override
  Future<void> saveTargetMathStandard(
    String profileId,
    String standard,
  ) async {}

  @override
  Future<void> saveVoiceReadAloud(bool enabled) async {}
}

class _FakeProfileRepository implements IProfileRepository {
  List<UserProfile> savedProfiles;
  String activeId;

  _FakeProfileRepository(this.savedProfiles, {required this.activeId});

  @override
  Future<UserProfile?> getActiveProfile() async {
    return savedProfiles.where((profile) => profile.id == activeId).firstOrNull;
  }

  @override
  Future<List<UserProfile>> getAllProfiles() async => [...savedProfiles];

  @override
  Future<void> saveProfile(UserProfile profile) async {}

  @override
  Future<void> setActiveProfileId(String id) async {
    activeId = id;
  }
}

const _leo = UserProfile(
  id: 'leo',
  name: 'Leo',
  gradeLabel: 'Grade 2',
  avatar: '🚀',
  level: 7,
  starCoins: 875,
  xp: 500,
  currentStreak: 12,
  dailyGoal: 10,
  masteryTracks: {},
  unlockedBadgeIds: [],
);

const _mia = UserProfile(
  id: 'mia',
  name: 'Mia',
  gradeLabel: 'Grade 1',
  avatar: '🦄',
  level: 3,
  starCoins: 410,
  xp: 200,
  currentStreak: 4,
  dailyGoal: 8,
  masteryTracks: {},
  unlockedBadgeIds: [],
);
