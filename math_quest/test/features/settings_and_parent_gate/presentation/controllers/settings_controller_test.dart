import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:math_quest/core/audio/i_sound_service.dart';
import 'package:math_quest/core/haptics/i_haptic_service.dart';
import 'package:math_quest/core/theme/visual_theme_model.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/settings_preferences.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/repositories/i_settings_repository.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/controllers/settings_controller.dart';

void main() {
  late SettingsPreferences preferences;
  late String? activeProfileId;
  late VisualThemeType theme;
  late String localeCode;
  late _FakeSettingsRepository repository;
  late _FakeSoundService soundService;
  late _FakeHapticService hapticService;
  late List<String> profileSwitches;
  late List<VisualThemeType> themeChanges;
  late List<String> localeChanges;
  late List<int> screenLimitChanges;
  late int resetCount;

  SettingsController createController({
    Future<void> Function(String)? switchProfileAction,
    Future<void> Function(VisualThemeType)? setThemeAction,
    Future<void> Function(String)? setLocaleAction,
  }) {
    return SettingsController(
      readPreferences: () => preferences,
      writePreferences: (next) => preferences = next,
      readActiveProfileId: () => activeProfileId,
      readTheme: () => theme,
      readLocaleCode: () => localeCode,
      repository: repository,
      soundService: soundService,
      hapticService: hapticService,
      switchProfileAction:
          switchProfileAction ?? (id) async => profileSwitches.add(id),
      setThemeAction:
          setThemeAction ??
          (next) async {
            themeChanges.add(next);
            theme = next;
          },
      setLocaleAction:
          setLocaleAction ??
          (next) async {
            localeChanges.add(next);
            localeCode = next;
          },
      updateScreenLimitAction: screenLimitChanges.add,
      resetAdventureAction: () async => resetCount++,
      parentGateGenerator: ParentGateChallengeGenerator((_) => 2),
    );
  }

  setUp(() {
    preferences = SettingsPreferences();
    activeProfileId = 'leo';
    theme = VisualThemeType.galaxyQuest;
    localeCode = 'en';
    repository = _FakeSettingsRepository();
    soundService = _FakeSoundService();
    hapticService = _FakeHapticService();
    profileSwitches = [];
    themeChanges = [];
    localeChanges = [];
    screenLimitChanges = [];
    resetCount = 0;
  });

  test('persistent preference methods update their matching values', () async {
    final controller = createController();

    await controller.setSfxVolume(0.25);
    await controller.setMusicVolume(0.4);
    await controller.setVoiceReadAloud(false);
    await controller.setHapticBuzz(false);
    await controller.setScreenLimitMinutes(45);
    await controller.setResponseMode(ResponseMode.write);

    expect(preferences.sfxVolume, 0.25);
    expect(preferences.musicVolume, 0.4);
    expect(preferences.voiceReadAloud, isFalse);
    expect(preferences.hapticBuzz, isFalse);
    expect(preferences.screenLimitMinutes, 45);
    expect(preferences.responseMode, ResponseMode.write);
    expect(repository.sfxValues, [0.25]);
    expect(repository.musicValues, [0.4]);
    expect(repository.voiceValues, [false]);
    expect(repository.hapticValues, [false]);
    expect(repository.screenLimitValues, [45]);
    expect(repository.responseModeValues, [ResponseMode.write]);
    expect(soundService.sfxVolumes, [0.25]);
    expect(soundService.musicVolumes, [0.4]);
    expect(screenLimitChanges, [45]);
    expect(hapticService.enabledValues, [false]);
  });

  test('cross-feature methods delegate once with requested values', () async {
    final controller = createController();

    await controller.switchProfile('mia');
    await controller.setTheme(VisualThemeType.underwater);
    await controller.setLocale('pt');
    await controller.resetAdventureProgress();

    expect(profileSwitches, ['mia']);
    expect(themeChanges, [VisualThemeType.underwater]);
    expect(localeChanges, ['pt']);
    expect(resetCount, 1);
  });

  test(
    'target standard persists for the active profile and updates state',
    () async {
      final controller = createController();

      await controller.setTargetMathStandard('Grade 3+');

      expect(repository.targetStandardValues, [('leo', 'Grade 3+')]);
      expect(preferences.targetMathStandards, {'leo': 'Grade 3+'});
    },
  );

  test('challenge creation uses the injected deterministic generator', () {
    final challenge = createController().createParentGateChallenge();

    expect(challenge.firstFactor, 8);
    expect(challenge.secondFactor, 8);
  });

  test(
    'invalid values throw before state repository or service mutation',
    () async {
      final controller = createController();

      for (final volume in [-0.1, 1.1, double.nan, double.infinity]) {
        await expectLater(controller.setSfxVolume(volume), throwsArgumentError);
        await expectLater(
          controller.setMusicVolume(volume),
          throwsArgumentError,
        );
      }
      for (final minutes in [-1, 10, 60]) {
        await expectLater(
          controller.setScreenLimitMinutes(minutes),
          throwsArgumentError,
        );
      }
      for (final code in ['', 'fr', 'EN']) {
        await expectLater(controller.setLocale(code), throwsArgumentError);
      }
      for (final standard in ['', 'Kindergarten', 'Grade 4']) {
        await expectLater(
          controller.setTargetMathStandard(standard),
          throwsArgumentError,
        );
      }

      expect(preferences.sfxVolume, 0.8);
      expect(preferences.musicVolume, 0.6);
      expect(preferences.screenLimitMinutes, 30);
      expect(repository.totalSaveCalls, 0);
      expect(soundService.sfxVolumes, isEmpty);
      expect(soundService.musicVolumes, isEmpty);
      expect(localeChanges, isEmpty);
      expect(screenLimitChanges, isEmpty);
    },
  );

  test(
    'target standard without active profile fails before persistence',
    () async {
      activeProfileId = null;
      final controller = createController();

      await expectLater(
        controller.setTargetMathStandard('Grade 1'),
        throwsStateError,
      );

      expect(repository.targetStandardValues, isEmpty);
      expect(preferences.targetMathStandards, isEmpty);
    },
  );

  test(
    'failed audio writes restore runtime volume and preserve state',
    () async {
      repository.throwOnSfx = true;
      repository.throwOnMusic = true;
      final controller = createController();

      await expectLater(controller.setSfxVolume(0.2), throwsStateError);
      await expectLater(controller.setMusicVolume(0.3), throwsStateError);

      expect(preferences.sfxVolume, 0.8);
      expect(preferences.musicVolume, 0.6);
      expect(soundService.sfxVolumes, [0.2, 0.8]);
      expect(soundService.musicVolumes, [0.3, 0.6]);
    },
  );

  test('failed theme and locale writes reapply previous values', () async {
    var themeAttempts = 0;
    var localeAttempts = 0;
    final controller = createController(
      setThemeAction: (next) async {
        themeChanges.add(next);
        theme = next;
        if (themeAttempts++ == 0) throw StateError('theme write failed');
      },
      setLocaleAction: (next) async {
        localeChanges.add(next);
        localeCode = next;
        if (localeAttempts++ == 0) throw StateError('locale write failed');
      },
    );

    await expectLater(
      controller.setTheme(VisualThemeType.dinoMath),
      throwsStateError,
    );
    await expectLater(controller.setLocale('es'), throwsStateError);

    expect(themeChanges, [
      VisualThemeType.dinoMath,
      VisualThemeType.galaxyQuest,
    ]);
    expect(localeChanges, ['es', 'en']);
    expect(theme, VisualThemeType.galaxyQuest);
    expect(localeCode, 'en');
  });

  test('other persistence failures preserve preference state', () async {
    repository.throwOnVoice = true;
    repository.throwOnHaptic = true;
    repository.throwOnScreenLimit = true;
    repository.throwOnTargetStandard = true;
    repository.throwOnResponseMode = true;
    final controller = createController();

    await expectLater(controller.setVoiceReadAloud(false), throwsStateError);
    await expectLater(controller.setHapticBuzz(false), throwsStateError);
    await expectLater(controller.setScreenLimitMinutes(15), throwsStateError);
    await expectLater(
      controller.setTargetMathStandard('Grade 1'),
      throwsStateError,
    );
    await expectLater(
      controller.setResponseMode(ResponseMode.write),
      throwsStateError,
    );

    expect(preferences.voiceReadAloud, isTrue);
    expect(preferences.hapticBuzz, isTrue);
    expect(preferences.screenLimitMinutes, 30);
    expect(preferences.targetMathStandards, isEmpty);
    expect(preferences.responseMode, ResponseMode.choice);
    expect(screenLimitChanges, isEmpty);
    expect(hapticService.enabledValues, isEmpty);
  });

  test('synchronize audio applies persisted startup volumes', () {
    preferences = SettingsPreferences(sfxVolume: 0.35, musicVolume: 0.45);

    createController().synchronizeAudio();

    expect(soundService.sfxVolumes, [0.35]);
    expect(soundService.musicVolumes, [0.45]);
  });

  test('synchronize haptics applies persisted startup preference', () {
    preferences = SettingsPreferences(hapticBuzz: false);

    createController().synchronizeHaptics();

    expect(hapticService.enabledValues, [false]);
  });

  test('overlapping preference writes are applied in request order', () async {
    final firstWrite = Completer<void>();
    repository.sfxWriteBarriers.add(firstWrite);
    final controller = createController();

    final sfxFuture = controller.setSfxVolume(0.2);
    await Future<void>.delayed(Duration.zero);
    final hapticFuture = controller.setHapticBuzz(false);
    final latestSfxFuture = controller.setSfxVolume(0.9);
    await Future<void>.delayed(Duration.zero);

    expect(repository.sfxValues, [0.2]);
    expect(repository.hapticValues, isEmpty);

    firstWrite.complete();
    await Future.wait([sfxFuture, hapticFuture, latestSfxFuture]);

    expect(preferences.sfxVolume, 0.9);
    expect(preferences.hapticBuzz, isFalse);
    expect(repository.sfxValues, [0.2, 0.9]);
    expect(repository.hapticValues, [false]);
    expect(soundService.sfxVolumes, [0.2, 0.9]);
  });

  test('overlapping response mode changes preserve latest intent', () async {
    final firstWrite = Completer<void>();
    repository.responseModeWriteBarriers.add(firstWrite);
    final controller = createController();

    final first = controller.setResponseMode(ResponseMode.write);
    await Future<void>.delayed(Duration.zero);
    final second = controller.setResponseMode(ResponseMode.choice);
    await Future<void>.delayed(Duration.zero);

    expect(repository.responseModeValues, [ResponseMode.write]);

    firstWrite.complete();
    await Future.wait([first, second]);

    expect(repository.responseModeValues, [
      ResponseMode.write,
      ResponseMode.choice,
    ]);
    expect(preferences.responseMode, ResponseMode.choice);
  });

  test('failed older audio write cannot roll back newer intent', () async {
    final firstWrite = Completer<void>();
    repository.sfxWriteBarriers.add(firstWrite);
    final controller = createController();

    final older = controller.setSfxVolume(0.2);
    await Future<void>.delayed(Duration.zero);
    final newer = controller.setSfxVolume(0.9);

    firstWrite.completeError(StateError('older write failed'));
    await expectLater(older, throwsStateError);
    await newer;

    expect(preferences.sfxVolume, 0.9);
    expect(soundService.sfxVolumes, [0.2, 0.8, 0.9]);
  });

  test('overlapping theme changes are applied in request order', () async {
    final firstWrite = Completer<void>();
    var calls = 0;
    final controller = createController(
      setThemeAction: (next) async {
        themeChanges.add(next);
        if (calls++ == 0) await firstWrite.future;
        theme = next;
      },
    );

    final first = controller.setTheme(VisualThemeType.dinoMath);
    await Future<void>.delayed(Duration.zero);
    final second = controller.setTheme(VisualThemeType.underwater);
    await Future<void>.delayed(Duration.zero);

    expect(themeChanges, [VisualThemeType.dinoMath]);

    firstWrite.complete();
    await Future.wait([first, second]);

    expect(themeChanges, [
      VisualThemeType.dinoMath,
      VisualThemeType.underwater,
    ]);
    expect(theme, VisualThemeType.underwater);
  });

  test('overlapping profile switches preserve latest intent', () async {
    final firstLoad = Completer<void>();
    final controller = createController(
      switchProfileAction: (id) async {
        profileSwitches.add(id);
        if (id == 'mia') await firstLoad.future;
        activeProfileId = id;
      },
    );

    final first = controller.switchProfile('mia');
    await Future<void>.delayed(Duration.zero);
    final second = controller.switchProfile('leo');
    await Future<void>.delayed(Duration.zero);

    expect(profileSwitches, ['mia']);

    firstLoad.complete();
    await Future.wait([first, second]);

    expect(profileSwitches, ['mia', 'leo']);
    expect(activeProfileId, 'leo');
  });

  test('failed profile switch attempts to restore previous profile', () async {
    final controller = createController(
      switchProfileAction: (id) async {
        profileSwitches.add(id);
        activeProfileId = id;
        if (id == 'mia') throw StateError('profile load failed');
      },
    );

    await expectLater(controller.switchProfile('mia'), throwsStateError);

    expect(profileSwitches, ['mia', 'leo']);
    expect(activeProfileId, 'leo');
  });
}

class _FakeSettingsRepository implements ISettingsRepository {
  final List<double> sfxValues = [];
  final List<double> musicValues = [];
  final List<bool> voiceValues = [];
  final List<bool> hapticValues = [];
  final List<int> screenLimitValues = [];
  final List<(String, String)> targetStandardValues = [];
  final List<ResponseMode> responseModeValues = [];

  bool throwOnSfx = false;
  bool throwOnMusic = false;
  bool throwOnVoice = false;
  bool throwOnHaptic = false;
  bool throwOnScreenLimit = false;
  bool throwOnTargetStandard = false;
  bool throwOnResponseMode = false;
  final List<Completer<void>> sfxWriteBarriers = [];
  final List<Completer<void>> responseModeWriteBarriers = [];

  int get totalSaveCalls =>
      sfxValues.length +
      musicValues.length +
      voiceValues.length +
      hapticValues.length +
      screenLimitValues.length +
      responseModeValues.length +
      targetStandardValues.length;

  @override
  SettingsPreferences loadPreferences() => SettingsPreferences();

  @override
  Future<void> saveSfxVolume(double value) async {
    sfxValues.add(value);
    if (throwOnSfx) throw StateError('sfx write failed');
    if (sfxWriteBarriers.isNotEmpty) {
      await sfxWriteBarriers.removeAt(0).future;
    }
  }

  @override
  Future<void> saveMusicVolume(double value) async {
    musicValues.add(value);
    if (throwOnMusic) throw StateError('music write failed');
  }

  @override
  Future<void> saveVoiceReadAloud(bool enabled) async {
    voiceValues.add(enabled);
    if (throwOnVoice) throw StateError('voice write failed');
  }

  @override
  Future<void> saveHapticBuzz(bool enabled) async {
    hapticValues.add(enabled);
    if (throwOnHaptic) throw StateError('haptic write failed');
  }

  @override
  Future<void> saveScreenLimitMinutes(int minutes) async {
    screenLimitValues.add(minutes);
    if (throwOnScreenLimit) throw StateError('screen limit write failed');
  }

  @override
  Future<void> saveResponseMode(ResponseMode mode) async {
    responseModeValues.add(mode);
    if (throwOnResponseMode) throw StateError('response mode write failed');
    if (responseModeWriteBarriers.isNotEmpty) {
      await responseModeWriteBarriers.removeAt(0).future;
    }
  }

  @override
  Future<void> saveTargetMathStandard(String profileId, String standard) async {
    targetStandardValues.add((profileId, standard));
    if (throwOnTargetStandard) {
      throw StateError('target standard write failed');
    }
  }
}

class _FakeSoundService implements ISoundService {
  final List<double> sfxVolumes = [];
  final List<double> musicVolumes = [];

  @override
  void setSfxVolume(double volume) => sfxVolumes.add(volume);

  @override
  void setMusicVolume(double volume) => musicVolumes.add(volume);

  @override
  Future<void> playCorrect() async {}

  @override
  Future<void> playStar(int starIndex) async {}

  @override
  Future<void> playTap() async {}

  @override
  Future<void> playVictory() async {}

  @override
  Future<void> playWrong() async {}
}

class _FakeHapticService implements IHapticService {
  final List<bool> enabledValues = [];

  @override
  void setEnabled(bool enabled) => enabledValues.add(enabled);

  @override
  Future<void> selection() async {}

  @override
  Future<void> answerSubmitted() async {}

  @override
  Future<void> correctAnswer() async {}

  @override
  Future<void> incorrectAnswer() async {}
}
