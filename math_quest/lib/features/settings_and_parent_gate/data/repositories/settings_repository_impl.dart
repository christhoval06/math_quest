import 'package:hive/hive.dart';

import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/settings_preferences.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/repositories/i_settings_repository.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  static const _sfxVolumeKey = 'sfx_volume';
  static const _musicVolumeKey = 'music_volume';
  static const _voiceReadAloudKey = 'voice_read_aloud';
  static const _hapticBuzzKey = 'haptic_buzz';
  static const _screenLimitKey = 'daily_screen_limit';
  static const _responseModeKey = 'response_mode';
  static const _targetStandardPrefix = 'target_math_standard_';

  final Box<dynamic> _box;

  SettingsRepositoryImpl(this._box);

  @override
  SettingsPreferences loadPreferences() {
    final targetStandards = <String, String>{};
    for (final key in _box.keys.whereType<String>()) {
      if (!key.startsWith(_targetStandardPrefix)) continue;
      final value = _box.get(key);
      if (value is String &&
          SettingsPreferences.supportedTargetMathStandards.contains(value)) {
        targetStandards[key.substring(_targetStandardPrefix.length)] = value;
      }
    }

    return SettingsPreferences(
      sfxVolume: _readVolume(_sfxVolumeKey, 0.8),
      musicVolume: _readVolume(_musicVolumeKey, 0.6),
      voiceReadAloud: _readBool(_voiceReadAloudKey, true),
      hapticBuzz: _readBool(_hapticBuzzKey, true),
      screenLimitMinutes: _readScreenLimit(),
      responseMode: _readResponseMode(),
      targetMathStandards: targetStandards,
    );
  }

  double _readVolume(String key, double fallback) {
    final value = _box.get(key);
    if (value is! num) return fallback;
    final volume = value.toDouble();
    return volume.isFinite && volume >= 0 && volume <= 1 ? volume : fallback;
  }

  bool _readBool(String key, bool fallback) {
    final value = _box.get(key);
    return value is bool ? value : fallback;
  }

  int _readScreenLimit() {
    final value = _box.get(_screenLimitKey);
    return value is int &&
            SettingsPreferences.supportedScreenLimits.contains(value)
        ? value
        : 30;
  }

  ResponseMode _readResponseMode() {
    return switch (_box.get(_responseModeKey)) {
      'write' => ResponseMode.write,
      'choice' => ResponseMode.choice,
      _ => ResponseMode.choice,
    };
  }

  @override
  Future<void> saveSfxVolume(double value) => _box.put(_sfxVolumeKey, value);

  @override
  Future<void> saveMusicVolume(double value) =>
      _box.put(_musicVolumeKey, value);

  @override
  Future<void> saveVoiceReadAloud(bool enabled) =>
      _box.put(_voiceReadAloudKey, enabled);

  @override
  Future<void> saveHapticBuzz(bool enabled) =>
      _box.put(_hapticBuzzKey, enabled);

  @override
  Future<void> saveScreenLimitMinutes(int minutes) =>
      _box.put(_screenLimitKey, minutes);

  @override
  Future<void> saveResponseMode(ResponseMode mode) {
    final storedValue = switch (mode) {
      ResponseMode.choice => 'choice',
      ResponseMode.write => 'write',
    };
    return _box.put(_responseModeKey, storedValue);
  }

  @override
  Future<void> saveTargetMathStandard(String profileId, String standard) {
    return _box.put('$_targetStandardPrefix$profileId', standard);
  }
}
