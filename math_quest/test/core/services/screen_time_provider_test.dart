import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:math_quest/core/services/screen_time_provider.dart';

void main() {
  late Directory hiveDirectory;
  late Box<dynamic> box;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'math_quest_screen_time_',
    );
    Hive.init(hiveDirectory.path);
    box = await Hive.openBox<dynamic>('screen_time_provider_test');
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  setUp(() => box.clear());

  test('settings limit sync preserves usage and does not write Hive', () async {
    final now = DateTime.now();
    final todayKey = 'screen_time_${now.year}_${now.month}_${now.day}';
    await box.put('daily_screen_limit', 30);
    await box.put(todayKey, 1200);

    for (final minutes in [0, 15, 30, 45]) {
      final notifier = ScreenTimeNotifier(box);
      addTearDown(notifier.dispose);

      notifier.updateLimitFromSettings(minutes);

      expect(notifier.state.limitMinutes, minutes);
      expect(notifier.state.todayUsedSeconds, 1200);
      expect(notifier.state.isLocked, minutes == 15);
      expect(box.get('daily_screen_limit'), 30);
    }
  });

  test('parent unlock does not overwrite the persisted base limit', () async {
    await box.put('daily_screen_limit', 45);
    final notifier = ScreenTimeNotifier(box);
    addTearDown(notifier.dispose);

    notifier.grantExtraMinutes(15);

    expect(notifier.state.limitMinutes, 60);
    expect(box.get('daily_screen_limit'), 45);
  });

  test(
    'malformed or unsupported persisted limits use the safe default',
    () async {
      for (final invalidLimit in <Object>['thirty', 60]) {
        await box.put('daily_screen_limit', invalidLimit);
        final notifier = ScreenTimeNotifier(box);

        expect(notifier.state.limitMinutes, 30);

        notifier.dispose();
      }
    },
  );
}
