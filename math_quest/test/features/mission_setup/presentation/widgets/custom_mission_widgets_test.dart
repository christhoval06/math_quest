import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/custom_mission_app_bar.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_difficulty_selector.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_helper_toggles.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_lab_header.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_launch_button.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_mode_selector.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_operation_grid.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_question_selector.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_reward_banner.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_timer_selector.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('app bar renders counters and invokes back', (tester) async {
    var backCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: CustomMissionAppBar(
            starCoins: 875,
            streakDays: 12,
            onBack: () => backCount++,
          ),
        ),
      ),
    );

    expect(find.text('875'), findsOneWidget);
    expect(find.text('12d'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    expect(backCount, 1);
  });

  testWidgets('mode selector reports the selected mode', (tester) async {
    final changes = <bool>[];
    await tester.pumpWidget(
      _app(MissionModeSelector(isExamMode: false, onChanged: changes.add)),
    );

    await tester.tap(find.text('📝 Exam Challenge'));
    expect(changes, [true]);
  });

  testWidgets('operation grid renders and reports all operations', (
    tester,
  ) async {
    final changes = <MathOperation>[];
    await tester.pumpWidget(
      _app(
        MissionOperationGrid(
          selectedOperations: const {MathOperation.addition},
          onToggle: changes.add,
        ),
      ),
    );

    expect(find.text('Addition'), findsOneWidget);
    expect(find.text('Subtraction'), findsOneWidget);
    expect(find.text('Multiplication'), findsOneWidget);
    expect(find.text('Division'), findsOneWidget);
    await tester.tap(find.text('Division'));
    expect(changes, [MathOperation.division]);
  });

  testWidgets('difficulty selector reports a difficulty', (tester) async {
    final changes = <DifficultyLevel>[];
    await tester.pumpWidget(
      _app(
        MissionDifficultySelector(
          selectedDifficulty: DifficultyLevel.medium,
          onSelected: changes.add,
        ),
      ),
    );

    await tester.tap(find.text('Hard'));
    expect(changes, [DifficultyLevel.hard]);
  });

  testWidgets('timer selector reports a supported duration', (tester) async {
    final changes = <int>[];
    await tester.pumpWidget(
      _app(MissionTimerSelector(selectedSeconds: 60, onSelected: changes.add)),
    );

    await tester.tap(find.text('2 Minutes'));
    expect(changes, [120]);
  });

  testWidgets('helper toggles report changes and lock exam visual aids', (
    tester,
  ) async {
    final visualChanges = <bool>[];
    final soundChanges = <bool>[];
    await tester.pumpWidget(
      _app(
        MissionHelperToggles(
          visualAidsEnabled: false,
          soundEnabled: true,
          isExamMode: true,
          onVisualAidsChanged: visualChanges.add,
          onSoundChanged: soundChanges.add,
        ),
      ),
    );

    final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
    expect(switches.first.onChanged, isNull);
    await tester.tap(find.text('Sound Effects & Cheering'));
    expect(soundChanges, [false]);
    expect(visualChanges, isEmpty);
  });

  testWidgets('question selector reports shortcut and slider values', (
    tester,
  ) async {
    final changes = <int>[];
    await tester.pumpWidget(
      _app(
        MissionQuestionSelector(
          selectedCount: 10,
          isExamMode: false,
          onChanged: changes.add,
        ),
      ),
    );

    await tester.tap(find.text('25'));
    expect(changes, [25]);
    final slider = tester.widget<Slider>(find.byType(Slider));
    slider.onChanged!(35);
    expect(changes, [25, 35]);
  });

  testWidgets('launch button renders label and invokes launch', (tester) async {
    var launches = 0;
    await tester.pumpWidget(
      _app(
        MissionLaunchButton(
          isExamMode: true,
          label: 'Start Exam (25 Questions)',
          onPressed: () => launches++,
        ),
      ),
    );

    await tester.tap(find.text('Start Exam (25 Questions)'));
    expect(launches, 1);
  });

  testWidgets('static sections preserve the existing copy', (tester) async {
    await tester.pumpWidget(
      _app(
        const SingleChildScrollView(
          child: Column(children: [MissionLabHeader(), MissionRewardBanner()]),
        ),
      ),
    );

    expect(find.text('Custom Math Mission'), findsOneWidget);
    expect(
      find.text('Reward Upon Completion: +50 Stars & 1 Quest Key'),
      findsOneWidget,
    );
    expect(find.text('100 XP'), findsOneWidget);
  });
}

Widget _app(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}
