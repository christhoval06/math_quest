import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/mission_setup/presentation/providers/custom_mission_provider.dart';
import 'package:math_quest/features/mission_setup/presentation/screens/custom_mission_screen.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/custom_mission_app_bar.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_launch_button.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'custom_mission_test_',
    );
    Hive.init(hiveDirectory.path);
    await Hive.openBox('app_settings_box');
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  testWidgets('renders provider state and delegates form actions', (
    tester,
  ) async {
    var form = CustomMissionState(
      selectedOperations: const {MathOperation.addition},
      starCoins: 875,
      streakDays: 12,
    );
    final controller = _controller(
      read: () => form,
      write: (next) => form = next,
    );

    await _pump(tester, state: form, controller: controller);

    expect(find.byType(CustomMissionAppBar), findsOneWidget);
    expect(find.text('875'), findsOneWidget);
    expect(find.text('12d'), findsOneWidget);

    await tester.tap(find.text('📝 Exam Challenge'));
    expect(form.isExamMode, isTrue);

    await tester.tap(find.text('Division'));
    expect(form.selectedOperations, contains(MathOperation.division));

    await tester.scrollUntilVisible(find.text('Hard'), 250);
    await tester.tap(find.text('Hard'));
    expect(form.selectedDifficulty, DifficultyLevel.hard);

    await tester.scrollUntilVisible(find.text('2 Minutes'), 250);
    await tester.tap(find.text('2 Minutes'));
    expect(form.selectedTimerSeconds, 120);

    await tester.scrollUntilVisible(find.text('Sound Effects & Cheering'), 300);
    await tester.tap(find.text('Sound Effects & Cheering'));
    expect(form.soundEnabled, isFalse);

    await tester.scrollUntilVisible(find.text('25'), 300);
    await tester.tap(find.text('25'));
    expect(form.selectedQuestionCount, 25);
  });

  testWidgets('launch prepares once and forwards complete route arguments', (
    tester,
  ) async {
    var prepareCount = 0;
    final form = CustomMissionState(
      selectedOperations: const {
        MathOperation.multiplication,
        MathOperation.division,
      },
      isExamMode: true,
      selectedDifficulty: DifficultyLevel.hard,
      selectedTimerSeconds: 120,
      selectedQuestionCount: 25,
      visualAidsEnabled: false,
      soundEnabled: false,
    );
    final controller = _controller(
      read: () => form,
      write: (_) {},
      onPrepare: () => prepareCount++,
    );
    ActiveGameArgs? capturedArgs;

    await _pump(
      tester,
      state: form,
      controller: controller,
      onRoute: (settings) {
        capturedArgs = settings.arguments! as ActiveGameArgs;
      },
    );
    await tester.scrollUntilVisible(find.byType(MissionLaunchButton), 400);
    await tester.tap(find.byType(MissionLaunchButton));
    await tester.pumpAndSettle();

    expect(prepareCount, 1);
    expect(capturedArgs, isNotNull);
    expect(capturedArgs!.allowedOperations, [
      MathOperation.multiplication,
      MathOperation.division,
    ]);
    expect(capturedArgs!.timerSeconds, 120);
    expect(capturedArgs!.isExamMode, isTrue);
    expect(capturedArgs!.totalQuestions, 25);
    expect(capturedArgs!.preservePreparedSession, isTrue);
    expect(capturedArgs!.visualAidsEnabled, isFalse);
    expect(capturedArgs!.soundEnabled, isFalse);
  });

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('mission setup fits 390x844 in ${locale.languageCode}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final state = CustomMissionState();
      await _pump(
        tester,
        state: state,
        locale: locale,
        controller: _controller(read: () => state, write: (_) {}),
      );
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -700),
      );
      await tester.pumpAndSettle();
      final button = tester.widget<MissionLaunchButton>(
        find.byType(MissionLaunchButton),
      );
      expect(button.label, contains('10'));
    });
  }
}

CustomMissionController _controller({
  required CustomMissionState Function() read,
  required void Function(CustomMissionState) write,
  VoidCallback? onPrepare,
}) {
  return CustomMissionController(
    readState: read,
    writeState: write,
    prepareSessionAction:
        ({
          required operation,
          required difficulty,
          required visualAidsEnabled,
        }) {
          onPrepare?.call();
        },
  );
}

Future<void> _pump(
  WidgetTester tester, {
  required CustomMissionState state,
  required CustomMissionController controller,
  ValueChanged<RouteSettings>? onRoute,
  Locale locale = const Locale('en'),
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        customMissionProvider.overrideWith((ref) => state),
        customMissionControllerProvider.overrideWith((ref) => controller),
      ],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CustomMissionScreen(),
        onGenerateRoute: (settings) {
          onRoute?.call(settings);
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Active Game')),
            settings: settings,
          );
        },
      ),
    ),
  );
}
