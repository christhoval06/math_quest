import 'dart:async';

import 'package:math_quest/core/audio/i_sound_service.dart';
import 'package:math_quest/core/haptics/i_haptic_service.dart';
import 'package:math_quest/core/theme/visual_theme_model.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/settings_preferences.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/repositories/i_settings_repository.dart';

class SettingsController {
  static const supportedScreenLimits =
      SettingsPreferences.supportedScreenLimits;
  static const supportedLocaleCodes = {'en', 'es', 'pt'};
  static const supportedTargetStandards =
      SettingsPreferences.supportedTargetMathStandards;

  final _preferenceMutations = _AsyncSerialQueue();
  final _profileMutations = _AsyncSerialQueue();
  final _themeMutations = _AsyncSerialQueue();
  final _localeMutations = _AsyncSerialQueue();

  final SettingsPreferences Function() readPreferences;
  final void Function(SettingsPreferences) writePreferences;
  final String? Function() readActiveProfileId;
  final VisualThemeType Function() readTheme;
  final String Function() readLocaleCode;
  final ISettingsRepository repository;
  final ISoundService soundService;
  final IHapticService hapticService;
  final Future<void> Function(String profileId) switchProfileAction;
  final Future<void> Function(VisualThemeType type) setThemeAction;
  final Future<void> Function(String languageCode) setLocaleAction;
  final void Function(int minutes) updateScreenLimitAction;
  final Future<void> Function() resetAdventureAction;
  final ParentGateChallengeGenerator parentGateGenerator;

  SettingsController({
    required this.readPreferences,
    required this.writePreferences,
    required this.readActiveProfileId,
    required this.readTheme,
    required this.readLocaleCode,
    required this.repository,
    required this.soundService,
    required this.hapticService,
    required this.switchProfileAction,
    required this.setThemeAction,
    required this.setLocaleAction,
    required this.updateScreenLimitAction,
    required this.resetAdventureAction,
    required this.parentGateGenerator,
  });

  Future<void> switchProfile(String profileId) async {
    await _profileMutations.run(() async {
      final previousProfileId = readActiveProfileId();
      try {
        await switchProfileAction(profileId);
      } catch (error, stackTrace) {
        if (previousProfileId != null && previousProfileId != profileId) {
          await _attemptRollback(() => switchProfileAction(previousProfileId));
        }
        Error.throwWithStackTrace(error, stackTrace);
      }
    });
  }

  Future<void> setSfxVolume(double value) async {
    _validateVolume(value);
    await _preferenceMutations.run(() async {
      final previous = readPreferences();
      soundService.setSfxVolume(value);
      try {
        await repository.saveSfxVolume(value);
      } catch (error, stackTrace) {
        soundService.setSfxVolume(previous.sfxVolume);
        Error.throwWithStackTrace(error, stackTrace);
      }
      writePreferences(readPreferences().copyWith(sfxVolume: value));
    });
  }

  Future<void> setMusicVolume(double value) async {
    _validateVolume(value);
    await _preferenceMutations.run(() async {
      final previous = readPreferences();
      soundService.setMusicVolume(value);
      try {
        await repository.saveMusicVolume(value);
      } catch (error, stackTrace) {
        soundService.setMusicVolume(previous.musicVolume);
        Error.throwWithStackTrace(error, stackTrace);
      }
      writePreferences(readPreferences().copyWith(musicVolume: value));
    });
  }

  Future<void> setVoiceReadAloud(bool enabled) async {
    await _preferenceMutations.run(() async {
      await repository.saveVoiceReadAloud(enabled);
      writePreferences(readPreferences().copyWith(voiceReadAloud: enabled));
    });
  }

  Future<void> setHapticBuzz(bool enabled) async {
    await _preferenceMutations.run(() async {
      await repository.saveHapticBuzz(enabled);
      hapticService.setEnabled(enabled);
      writePreferences(readPreferences().copyWith(hapticBuzz: enabled));
    });
  }

  Future<void> setResponseMode(ResponseMode mode) async {
    await _preferenceMutations.run(() async {
      await repository.saveResponseMode(mode);
      writePreferences(readPreferences().copyWith(responseMode: mode));
    });
  }

  Future<void> setTheme(VisualThemeType type) async {
    await _themeMutations.run(() async {
      final previous = readTheme();
      try {
        await setThemeAction(type);
      } catch (error, stackTrace) {
        await _attemptRollback(() => setThemeAction(previous));
        Error.throwWithStackTrace(error, stackTrace);
      }
    });
  }

  Future<void> setLocale(String languageCode) async {
    if (!supportedLocaleCodes.contains(languageCode)) {
      throw ArgumentError.value(
        languageCode,
        'languageCode',
        'Unsupported locale',
      );
    }
    await _localeMutations.run(() async {
      final previous = readLocaleCode();
      try {
        await setLocaleAction(languageCode);
      } catch (error, stackTrace) {
        await _attemptRollback(() => setLocaleAction(previous));
        Error.throwWithStackTrace(error, stackTrace);
      }
    });
  }

  Future<void> setScreenLimitMinutes(int minutes) async {
    if (!supportedScreenLimits.contains(minutes)) {
      throw ArgumentError.value(minutes, 'minutes', 'Unsupported screen limit');
    }
    await _preferenceMutations.run(() async {
      await repository.saveScreenLimitMinutes(minutes);
      updateScreenLimitAction(minutes);
      writePreferences(readPreferences().copyWith(screenLimitMinutes: minutes));
    });
  }

  Future<void> setTargetMathStandard(String standard) async {
    if (!supportedTargetStandards.contains(standard)) {
      throw ArgumentError.value(
        standard,
        'standard',
        'Unsupported target standard',
      );
    }
    final profileId = readActiveProfileId();
    if (profileId == null) {
      throw StateError('A target standard requires an active profile');
    }

    await _preferenceMutations.run(() async {
      await repository.saveTargetMathStandard(profileId, standard);
      final current = readPreferences();
      writePreferences(
        current.copyWith(
          targetMathStandards: {
            ...current.targetMathStandards,
            profileId: standard,
          },
        ),
      );
    });
  }

  Future<void> resetAdventureProgress() => resetAdventureAction();

  ParentGateChallenge createParentGateChallenge() {
    return parentGateGenerator.generate();
  }

  void synchronizeAudio() {
    final preferences = readPreferences();
    soundService.setSfxVolume(preferences.sfxVolume);
    soundService.setMusicVolume(preferences.musicVolume);
  }

  void synchronizeHaptics() {
    hapticService.setEnabled(readPreferences().hapticBuzz);
  }

  void _validateVolume(double value) {
    if (!value.isFinite || value < 0 || value > 1) {
      throw ArgumentError.value(value, 'value', 'Volume must be 0.0 to 1.0');
    }
  }

  Future<void> _attemptRollback(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // The original persistence failure remains the actionable error.
    }
  }
}

class _AsyncSerialQueue {
  Future<void> _tail = Future<void>.value();

  Future<T> run<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _tail = _tail.then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }
}
