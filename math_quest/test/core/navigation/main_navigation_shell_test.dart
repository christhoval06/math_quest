import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/core/navigation/main_navigation_shell.dart';
import 'package:math_quest/core/services/screen_time_provider.dart';
import 'package:math_quest/core/theme/theme_provider.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  late Directory hiveDirectory;
  late Box<dynamic> box;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'math_quest_navigation_shell_',
    );
    Hive.init(hiveDirectory.path);
    box = await Hive.openBox<dynamic>('app_settings_box');
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  setUp(() async {
    await box.clear();
    final now = DateTime.now();
    await box.put('daily_screen_limit', 30);
    await box.put('screen_time_${now.year}_${now.month}_${now.day}', 15 * 60);
  });

  testWidgets('cancelled parent gate keeps the screen-time lock visible', (
    tester,
  ) async {
    final screenTime = ScreenTimeNotifier(box);
    var requests = 0;
    await _pumpShell(
      tester,
      screenTime: screenTime,
      requestParentAccess: (context, {required challenge, required config}) {
        requests++;
        return Future.value(false);
      },
    );

    _lock(screenTime);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parent Unlock 🛡️'));
    await tester.pumpAndSettle();

    expect(requests, 1);
    expect(screenTime.state.isLocked, isTrue);
    expect(find.text('Time for a Rest!'), findsOneWidget);
  });

  testWidgets('successful parent gate grants once and closes the lock', (
    tester,
  ) async {
    final screenTime = ScreenTimeNotifier(box);
    final authorization = Completer<bool>();
    var requests = 0;
    await _pumpShell(
      tester,
      screenTime: screenTime,
      requestParentAccess: (context, {required challenge, required config}) {
        requests++;
        return authorization.future;
      },
    );

    _lock(screenTime);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parent Unlock 🛡️'));
    await tester.tap(find.text('Parent Unlock 🛡️'));
    expect(requests, 1);

    authorization.complete(true);
    await tester.pumpAndSettle();

    expect(screenTime.state.limitMinutes, 30);
    expect(screenTime.state.isLocked, isFalse);
    expect(find.text('Time for a Rest!'), findsNothing);
  });

  testWidgets('disposing the shell while authorization waits is safe', (
    tester,
  ) async {
    final screenTime = ScreenTimeNotifier(box);
    final authorization = Completer<bool>();
    await _pumpShell(
      tester,
      screenTime: screenTime,
      requestParentAccess: (context, {required challenge, required config}) {
        return authorization.future;
      },
    );

    _lock(screenTime);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parent Unlock 🛡️'));
    await tester.pump();

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SizedBox(),
      ),
    );
    authorization.complete(true);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}

void _lock(ScreenTimeNotifier notifier) => notifier.updateLimitFromSettings(15);

Future<void> _pumpShell(
  WidgetTester tester, {
  required ScreenTimeNotifier screenTime,
  required ParentGateRequest requestParentAccess,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        screenTimeProvider.overrideWith((ref) => screenTime),
        visualThemeProvider.overrideWith(
          (ref) => ThemeNotifier(Hive.box('app_settings_box')),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MainNavigationShell(
          screens: const [
            SizedBox(),
            SizedBox(),
            SizedBox(),
            SizedBox(),
            SizedBox(),
          ],
          parentGateGenerator: ParentGateChallengeGenerator((_) => 0),
          requestParentAccess: requestParentAccess,
        ),
      ),
    ),
  );
  await tester.pump();
}
