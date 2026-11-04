import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/core/audio/i_sound_service.dart';
import 'package:math_quest/core/audio/sound_provider.dart';
import 'package:math_quest/core/haptics/haptic_provider.dart';
import 'package:math_quest/core/haptics/i_haptic_service.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/features/gameplay/presentation/providers/active_game_provider.dart';
import 'package:math_quest/features/gameplay/presentation/screens/active_game_screen.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/active_game_app_bar.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/active_game_problem_card.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/answer_options_grid.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/written_answer_pad.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/exam_report.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';
import 'package:math_quest/features/math_engine/domain/usecases/generate_problem_usecase.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_notifier.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_state.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/providers/settings_provider.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class _NoopTicker implements ActiveGameTicker {
  @override
  void cancel() {}

  @override
  void start(void Function() onTick) {}
}

class _FakeSoundService implements ISoundService {
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

  @override
  void setMusicVolume(double volume) {}

  @override
  void setSfxVolume(double volume) {}
}

class _SpyActiveGameController extends ActiveGameController {
  int startCount = 0;
  int clearCount = 0;
  final List<int> submittedAnswers = [];

  _SpyActiveGameController(ActiveGameConfig config)
    : super(
        config: config,
        ticker: _NoopTicker(),
        readFlow: () => ActiveGameFlowState(
          questionStartedAt: DateTime(2026, 10, 19),
          secondsRemaining: config.timerSeconds,
        ),
        writeFlow: (_) {},
        readSession: () => const PracticeSessionState(
          operation: MathOperation.multiplication,
          difficulty: DifficultyLevel.medium,
          currentProblem: _preparedProblem,
          showVisualAids: false,
        ),
        resetSessionAction: ({operation}) {},
        now: () => DateTime(2026, 10, 19),
        selectAnswerAction: (_) {},
        evaluateAnswerAction: () {},
        nextProblemAction: ({operation}) {},
        playTapAction: () async {},
        playCorrectAction: () async {},
        playWrongAction: () async {},
        hapticSubmittedAction: () async {},
        hapticCorrectAction: () async {},
        hapticIncorrectAction: () async {},
        delay: (_) async {},
        chooseOperation: (operations) => operations.first,
      );

  @override
  void start() => startCount++;

  @override
  Future<void> submitAnswer(int selectedAnswer) async {
    submittedAnswers.add(selectedAnswer);
  }

  @override
  void clearCompletedReport() => clearCount++;

  @override
  void dispose() {}
}

const _preparedProblem = MathProblem(
  num1: 6,
  num2: 7,
  operation: MathOperation.multiplication,
  correctAnswer: 42,
  options: [42, 36, 48, 49],
);

ActiveGameState _viewState({ExamReport? report}) {
  return ActiveGameState.fromSources(
    config: ActiveGameConfig(
      allowedOperations: [MathOperation.multiplication],
      totalQuestions: 1,
      preservePreparedSession: true,
    ),
    session: const PracticeSessionState(
      operation: MathOperation.multiplication,
      difficulty: DifficultyLevel.medium,
      currentProblem: _preparedProblem,
      showVisualAids: false,
      currentStreak: 2,
    ),
    flow: ActiveGameFlowState(
      questionStartedAt: DateTime(2026, 10, 19),
      secondsRemaining: 0,
      completedReport: report,
    ),
  );
}

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('active_game_test_');
    Hive.init(hiveDirectory.path);
    await Hive.openBox('app_settings_box');
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('active game arguments preserve existing setting defaults', () {
    const args = ActiveGameArgs();

    expect(args.visualAidsEnabled, isTrue);
    expect(args.soundEnabled, isTrue);
  });

  testWidgets('router maps explicit visual aid and sound settings', (
    tester,
  ) async {
    final route = AppRouter.onGenerateRoute(
      const RouteSettings(
        name: AppRoutes.activeGame,
        arguments: ActiveGameArgs(
          visualAidsEnabled: false,
          soundEnabled: false,
        ),
      ),
    );
    late Widget routePage;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            routePage = (route as MaterialPageRoute<dynamic>).builder(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final screen = routePage as ActiveGameScreen;
    expect(screen.visualAidsEnabled, isFalse);
    expect(screen.soundEnabled, isFalse);
  });

  testWidgets('preserves a prepared non-addition session on launch', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final notifier =
        PracticeSessionNotifier(
            generateProblemUseCase: GenerateProblemUseCase(),
          )
          ..state = const PracticeSessionState(
            operation: MathOperation.multiplication,
            difficulty: DifficultyLevel.medium,
            currentProblem: _preparedProblem,
            showVisualAids: false,
          );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          practiceSessionProvider.overrideWith((ref) => notifier),
          soundServiceProvider.overrideWithValue(_FakeSoundService()),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ActiveGameScreen(
            timerSeconds: 0,
            allowedOperations: [MathOperation.multiplication],
            preservePreparedSession: true,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(notifier.state.operation, MathOperation.multiplication);
    expect(notifier.state.currentProblem, same(_preparedProblem));
    expect(notifier.state.showVisualAids, isFalse);
  });

  testWidgets('resets an ordinary session to the configured operation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final notifier =
        PracticeSessionNotifier(
            generateProblemUseCase: GenerateProblemUseCase(),
          )
          ..state = const PracticeSessionState(
            operation: MathOperation.multiplication,
            difficulty: DifficultyLevel.medium,
            currentProblem: _preparedProblem,
            showVisualAids: false,
          );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          practiceSessionProvider.overrideWith((ref) => notifier),
          soundServiceProvider.overrideWithValue(_FakeSoundService()),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ActiveGameScreen(
            allowedOperations: [MathOperation.subtraction],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(notifier.state.operation, MathOperation.subtraction);
    expect(notifier.state.currentProblem, isNot(same(_preparedProblem)));
  });

  testWidgets('renders provider state and delegates start and answer', (
    tester,
  ) async {
    final config = ActiveGameConfig(
      allowedOperations: [MathOperation.multiplication],
      totalQuestions: 1,
      preservePreparedSession: true,
    );
    final controller = _SpyActiveGameController(config);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeGameProvider.overrideWith((ref, config) => _viewState()),
          activeGameControllerProvider.overrideWith(
            (ref, config) => controller,
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ActiveGameScreen(
            allowedOperations: [MathOperation.multiplication],
            totalQuestions: 1,
            preservePreparedSession: true,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(controller.startCount, 1);
    expect(find.byType(ActiveGameAppBar), findsOneWidget);
    expect(find.byType(ActiveGameProblemCard), findsOneWidget);
    expect(find.byType(AnswerOptionsGrid), findsOneWidget);

    await tester.tap(find.text('42'));
    expect(controller.submittedAnswers, [42]);
  });

  testWidgets('write mode replaces choices and submits keypad answer', (
    tester,
  ) async {
    final config = ActiveGameConfig(
      allowedOperations: [MathOperation.multiplication],
      totalQuestions: 1,
      preservePreparedSession: true,
    );
    final controller = _SpyActiveGameController(config);
    final haptics = _FakeHapticService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hapticServiceProvider.overrideWithValue(haptics),
          responseModeProvider.overrideWithValue(ResponseMode.write),
          activeGameProvider.overrideWith((ref, config) => _viewState()),
          activeGameControllerProvider.overrideWith(
            (ref, config) => controller,
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ActiveGameScreen(
            allowedOperations: [MathOperation.multiplication],
            totalQuestions: 1,
            preservePreparedSession: true,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AnswerOptionsGrid), findsNothing);
    expect(find.byType(WrittenAnswerPad), findsOneWidget);
    expect(find.text('Write the correct answer:'), findsOneWidget);
    expect(find.text('Check Answer'), findsNothing);
    expect(find.byKey(const Key('written-delete')), findsNothing);
    expect(find.byKey(const Key('written-confirm')), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('written-digit-4')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('written-digit-2')));
    await tester.pump(const Duration(milliseconds: 450));

    expect(controller.submittedAnswers, [42]);
    expect(haptics.selectionCount, 2);
  });

  testWidgets('navigates once with the completed report', (tester) async {
    final stateProvider = StateProvider<ActiveGameState>((ref) => _viewState());
    final config = ActiveGameConfig(
      allowedOperations: [MathOperation.multiplication],
      totalQuestions: 1,
      preservePreparedSession: true,
    );
    final controller = _SpyActiveGameController(config);
    RouteSettings? capturedSettings;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeGameProvider.overrideWith(
            (ref, config) => ref.watch(stateProvider),
          ),
          activeGameControllerProvider.overrideWith(
            (ref, config) => controller,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ActiveGameScreen(
            levelNumber: 3,
            allowedOperations: [MathOperation.multiplication],
            totalQuestions: 1,
            preservePreparedSession: true,
          ),
          onGenerateRoute: (settings) {
            capturedSettings = settings;
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('results')),
            );
          },
        ),
      ),
    );
    await tester.pump();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ActiveGameScreen)),
    );
    final report = ExamReport(
      correctCount: 1,
      totalQuestions: 1,
      totalDuration: const Duration(seconds: 3),
      answers: const [],
    );

    container.read(stateProvider.notifier).state = _viewState(report: report);
    await tester.pumpAndSettle();

    expect(capturedSettings?.name, AppRoutes.questComplete);
    final args = capturedSettings!.arguments! as QuestCompleteArgs;
    expect(args.report, same(report));
    expect(args.levelNumber, 3);
    expect(find.text('results'), findsOneWidget);
    expect(controller.clearCount, 1);
  });

  testWidgets('back action pops the active game route', (tester) async {
    final config = ActiveGameConfig(preservePreparedSession: true);
    final controller = _SpyActiveGameController(config);
    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          activeGameProvider.overrideWith((ref, config) => _viewState()),
          activeGameControllerProvider.overrideWith(
            (ref, config) => controller,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorKey: navigatorKey,
          home: const Scaffold(body: Text('previous')),
        ),
      ),
    );
    navigatorKey.currentState!.push(
      MaterialPageRoute<void>(builder: (_) => const ActiveGameScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('previous'), findsOneWidget);
  });

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets(
      'renders without overflow at 390x844 in ${locale.languageCode}',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final config = ActiveGameConfig(
          allowedOperations: [MathOperation.multiplication],
          totalQuestions: 1,
          preservePreparedSession: true,
        );
        final controller = _SpyActiveGameController(config);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              responseModeProvider.overrideWithValue(ResponseMode.write),
              activeGameProvider.overrideWith((ref, config) => _viewState()),
              activeGameControllerProvider.overrideWith(
                (ref, config) => controller,
              ),
            ],
            child: MaterialApp(
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: ActiveGameScreen(
                allowedOperations: [MathOperation.multiplication],
                totalQuestions: 1,
                preservePreparedSession: true,
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Check Answer'), findsNothing);
        expect(find.byKey(const Key('written-delete')), findsNothing);
        expect(find.byKey(const Key('written-confirm')), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

class _FakeHapticService implements IHapticService {
  int selectionCount = 0;

  @override
  Future<void> selection() async => selectionCount++;

  @override
  Future<void> answerSubmitted() async {}

  @override
  Future<void> correctAnswer() async {}

  @override
  Future<void> incorrectAnswer() async {}

  @override
  void setEnabled(bool enabled) {}
}
