import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:math_quest/features/settings_and_parent_gate/data/repositories/settings_repository_impl.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/settings_preferences.dart';

void main() {
  late Directory hiveDirectory;
  late Box<dynamic> box;
  late SettingsRepositoryImpl repository;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'math_quest_settings_repository_',
    );
    Hive.init(hiveDirectory.path);
    box = await Hive.openBox<dynamic>('app_settings_box');
  });

  setUp(() async {
    await box.clear();
    repository = SettingsRepositoryImpl(box);
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('defaults match the current settings screen', () {
    final preferences = SettingsPreferences();

    expect(preferences.sfxVolume, 0.8);
    expect(preferences.musicVolume, 0.6);
    expect(preferences.voiceReadAloud, isTrue);
    expect(preferences.hapticBuzz, isTrue);
    expect(preferences.screenLimitMinutes, 30);
    expect(preferences.responseMode, ResponseMode.choice);
    expect(preferences.targetMathStandards, isEmpty);
  });

  test('target standards are immutable snapshots', () {
    final source = {'leo': 'Grade 1'};
    final preferences = SettingsPreferences(targetMathStandards: source);

    source['leo'] = 'Grade 3+';

    expect(preferences.targetMathStandards, {'leo': 'Grade 1'});
    expect(
      () => preferences.targetMathStandards['mia'] = 'Pre-K',
      throwsUnsupportedError,
    );
  });

  test('repository returns defaults from an empty box', () {
    final preferences = repository.loadPreferences();

    expect(preferences.sfxVolume, 0.8);
    expect(preferences.musicVolume, 0.6);
    expect(preferences.voiceReadAloud, isTrue);
    expect(preferences.hapticBuzz, isTrue);
    expect(preferences.screenLimitMinutes, 30);
    expect(preferences.responseMode, ResponseMode.choice);
    expect(preferences.targetMathStandards, isEmpty);
  });

  test('repository persists and reloads every preference', () async {
    await repository.saveSfxVolume(0.25);
    await repository.saveMusicVolume(0.4);
    await repository.saveVoiceReadAloud(false);
    await repository.saveHapticBuzz(false);
    await repository.saveScreenLimitMinutes(45);
    await repository.saveResponseMode(ResponseMode.write);

    final preferences = repository.loadPreferences();

    expect(preferences.sfxVolume, 0.25);
    expect(preferences.musicVolume, 0.4);
    expect(preferences.voiceReadAloud, isFalse);
    expect(preferences.hapticBuzz, isFalse);
    expect(preferences.screenLimitMinutes, 45);
    expect(preferences.responseMode, ResponseMode.write);
    expect(box.get('response_mode'), 'write');
  });

  test('repository stores target standards per profile', () async {
    await repository.saveTargetMathStandard('leo', 'Grade 3+');
    await repository.saveTargetMathStandard('mia', 'Pre-K');

    final preferences = repository.loadPreferences();

    expect(preferences.targetMathStandards, {
      'leo': 'Grade 3+',
      'mia': 'Pre-K',
    });
  });

  test('repository target-standard lookup uses grade fallback', () {
    final preferences = repository.loadPreferences();

    expect(preferences.targetMathStandardFor('unknown', 'Grade 2'), 'Grade 2');
  });

  test('kindergarten grade fallback maps to the supported Pre-K standard', () {
    final preferences = repository.loadPreferences();

    expect(
      preferences.targetMathStandardFor('unknown', 'Kindergarten'),
      'Pre-K',
    );
  });

  test('repository falls back safely for malformed persisted values', () async {
    await box.put('sfx_volume', 'loud');
    await box.put('music_volume', double.nan);
    await box.put('voice_read_aloud', 1);
    await box.put('haptic_buzz', null);
    await box.put('daily_screen_limit', 60);
    await box.put('response_mode', 'handwriting');
    await box.put('target_math_standard_leo', 'Grade 4');
    await box.put('target_math_standard_mia', 'Grade 1');

    final preferences = repository.loadPreferences();

    expect(preferences.sfxVolume, 0.8);
    expect(preferences.musicVolume, 0.6);
    expect(preferences.voiceReadAloud, isTrue);
    expect(preferences.hapticBuzz, isTrue);
    expect(preferences.screenLimitMinutes, 30);
    expect(preferences.responseMode, ResponseMode.choice);
    expect(preferences.targetMathStandards, {'mia': 'Grade 1'});
  });
}
