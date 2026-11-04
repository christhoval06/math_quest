import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/core/haptics/haptic_provider.dart';
import 'package:math_quest/core/haptics/i_haptic_service.dart';
import 'package:math_quest/features/gameplay/presentation/controllers/buddy_challenge_controller.dart';
import 'package:math_quest/features/gameplay/presentation/models/buddy_challenge_state.dart';
import 'package:math_quest/features/gameplay/presentation/providers/buddy_challenge_provider.dart';
import 'package:math_quest/features/gameplay/presentation/screens/buddy_challenge_screen.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/providers/settings_provider.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('setup configures and starts a named match', (tester) async {
    final controller = _controller();
    await tester.pumpWidget(_app(controller));

    expect(find.text('Match Setup'), findsOneWidget);
    expect(find.text('Apple counters'), findsOneWidget);
    expect(find.text('Boosters'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('buddy-player-1-name')), 'Ana');
    await tester.enterText(find.byKey(const Key('buddy-player-2-name')), 'Ben');
    await tester.tap(find.text('Multiplication'));
    await tester.ensureVisible(find.text('Medium'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Medium'));
    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.min, 5);
    expect(slider.max, 10);
    expect(slider.divisions, 5);
    slider.onChanged!(7);
    await tester.pump();
    final startButton = find.widgetWithText(
      ElevatedButton,
      'Start Buddy Challenge! (First to 7 Points)',
    );
    await tester.ensureVisible(startButton);
    await tester.pumpAndSettle();
    await tester.tap(startButton);
    await tester.pump();

    expect(controller.state.phase, BuddyChallengePhase.playing);
    expect(controller.state.settings.player1Name, 'Ana');
    expect(controller.state.settings.player2Name, 'Ben');
    expect(controller.state.settings.operations, [
      MathOperation.addition,
      MathOperation.multiplication,
    ]);
    expect(controller.state.settings.difficulty, DifficultyLevel.medium);
    expect(controller.state.settings.pointsToWin, 7);
    expect(find.byKey(const Key('buddy-player-1-arena')), findsOneWidget);
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Ben'), findsOneWidget);
  });

  testWidgets('playing arena delegates answer with rendered revision', (
    tester,
  ) async {
    final controller = _playingController();
    await tester.pumpWidget(_app(controller));

    final playerOneAnswer = find.descendant(
      of: find.byKey(const Key('buddy-player-1-arena')),
      matching: find.text('5'),
    );
    await tester.tap(playerOneAnswer);
    await tester.pump();

    expect(controller.state.player1Score, 1);
    expect(controller.state.problem?.revision, 2);
    expect(find.text('First to 5 points'), findsOneWidget);
  });

  testWidgets('first response locks only that player until next question', (
    tester,
  ) async {
    final controller = _playingController();
    await tester.pumpWidget(_app(controller));

    final playerOneArena = find.byKey(const Key('buddy-player-1-arena'));
    final playerTwoArena = find.byKey(const Key('buddy-player-2-arena'));
    await tester.tap(
      find.descendant(of: playerOneArena, matching: find.text('3')),
    );
    await tester.pump();

    expect(controller.state.hasAnswered(1), isTrue);
    expect(_allAnswerButtonsDisabled(tester, playerOneArena), isTrue);
    expect(_allAnswerButtonsEnabled(tester, playerTwoArena), isTrue);

    await tester.tap(
      find.descendant(of: playerOneArena, matching: find.text('5')),
    );
    await tester.pump();
    expect(controller.state.player1Score, 0);
    expect(controller.state.problem?.revision, 1);

    await tester.tap(
      find.descendant(of: playerTwoArena, matching: find.text('5')),
    );
    await tester.pump();

    expect(controller.state.player2Score, 1);
    expect(controller.state.problem?.revision, 2);
    expect(_allAnswerButtonsEnabled(tester, playerOneArena), isTrue);
    expect(_allAnswerButtonsEnabled(tester, playerTwoArena), isTrue);
  });

  testWidgets('winner uses a full screen and never a dialog', (tester) async {
    final controller = _wonController();
    await tester.pumpWidget(_app(controller));

    expect(find.byKey(const Key('buddy-winner-screen')), findsOneWidget);
    expect(find.text('Ana Wins!'), findsOneWidget);
    expect(find.text('5 – 0'), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('global write mode scores through each player keypad', (
    tester,
  ) async {
    final controller = _playingController();
    final haptics = _FakeHapticService();
    await tester.pumpWidget(
      _app(
        controller,
        responseMode: ResponseMode.write,
        hapticService: haptics,
      ),
    );

    final playerOneArena = find.byKey(const Key('buddy-player-1-arena'));
    await tester.tap(
      find.descendant(
        of: playerOneArena,
        matching: find.byKey(const Key('written-digit-5')),
      ),
    );
    await tester.pump(const Duration(milliseconds: 450));

    expect(controller.state.player1Score, 1);
    expect(controller.state.problem?.revision, 2);
    expect(haptics.selectionCount, 1);
    expect(find.text('Check Answer'), findsNothing);
    expect(find.byKey(const Key('written-delete')), findsNothing);
    expect(find.byKey(const Key('written-confirm')), findsNothing);
    expect(tester.takeException(), isNull);

    final playerTwoArena = find.byKey(const Key('buddy-player-2-arena'));
    await tester.tap(
      find.descendant(
        of: playerTwoArena,
        matching: find.byKey(const Key('written-digit-5')),
      ),
    );
    await tester.pump();
    expect(haptics.selectionCount, 2);
  });

  testWidgets('incorrect written answer locks that compact keypad', (
    tester,
  ) async {
    final controller = _playingController();
    await tester.pumpWidget(_app(controller, responseMode: ResponseMode.write));
    final playerOneArena = find.byKey(const Key('buddy-player-1-arena'));

    await tester.tap(
      find.descendant(
        of: playerOneArena,
        matching: find.byKey(const Key('written-digit-3')),
      ),
    );
    await tester.pump(const Duration(milliseconds: 450));

    expect(controller.state.hasAnswered(1), isTrue);
    final digit = tester.widget<FilledButton>(
      find.descendant(
        of: playerOneArena,
        matching: find.byKey(const Key('written-digit-5')),
      ),
    );
    expect(digit.onPressed, isNull);
    expect(find.text('Check Answer'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('winner actions replay, edit settings, and exit', (tester) async {
    final replayController = _wonController();
    await tester.pumpWidget(_app(replayController));
    await tester.tap(find.text('Play Again'));
    await tester.pump();
    expect(replayController.state.phase, BuddyChallengePhase.playing);
    expect(find.byKey(const Key('buddy-player-1-arena')), findsOneWidget);

    final settingsController = _wonController();
    await tester.pumpWidget(_app(settingsController));
    await tester.tap(find.text('Change Settings'));
    await tester.pump();
    expect(settingsController.state.phase, BuddyChallengePhase.setup);
    expect(find.text('Match Setup'), findsOneWidget);

    final exitController = _wonController();
    await tester.pumpWidget(_app(exitController, withHostRoute: true));
    await tester.tap(find.text('Exit'));
    await tester.pumpAndSettle();
    expect(find.text('Host screen'), findsOneWidget);
  });

  testWidgets('setup close action pops the challenge', (tester) async {
    await tester.pumpWidget(_app(_controller(), withHostRoute: true));

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Host screen'), findsOneWidget);
  });

  testWidgets('closing and reopening starts with fresh setup', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          responseModeProvider.overrideWithValue(ResponseMode.choice),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: _BuddyHost(),
        ),
      ),
    );

    await tester.tap(find.text('Open Buddy'));
    await tester.pumpAndSettle();
    final startButton = find.widgetWithText(
      ElevatedButton,
      'Start Buddy Challenge! (First to 5 Points)',
    );
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();
    await tester.tap(startButton);
    await tester.pump();
    expect(find.byKey(const Key('buddy-player-1-arena')), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open Buddy'));
    await tester.pumpAndSettle();

    expect(find.text('Match Setup'), findsOneWidget);
    expect(find.byKey(const Key('buddy-player-1-arena')), findsNothing);
  });

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets(
      'all phases render without overflow at 390x844 in ${locale.languageCode}',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        for (final controller in [
          _controller(),
          _playingController(pointsToWin: 10),
          _wonController(),
        ]) {
          await tester.pumpWidget(_app(controller, locale: locale));
          await tester.pump();
          expect(tester.takeException(), isNull);
        }

        await tester.pumpWidget(
          _app(
            _playingController(pointsToWin: 10),
            responseMode: ResponseMode.write,
            locale: locale,
          ),
        );
        await tester.pump();
        expect(find.text('Check Answer'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

bool _allAnswerButtonsDisabled(WidgetTester tester, Finder arena) => tester
    .widgetList<ElevatedButton>(
      find.descendant(of: arena, matching: find.byType(ElevatedButton)),
    )
    .every((button) => button.onPressed == null);

bool _allAnswerButtonsEnabled(WidgetTester tester, Finder arena) => tester
    .widgetList<ElevatedButton>(
      find.descendant(of: arena, matching: find.byType(ElevatedButton)),
    )
    .every((button) => button.onPressed != null);

Widget _app(
  BuddyChallengeController controller, {
  bool withHostRoute = false,
  ResponseMode responseMode = ResponseMode.choice,
  IHapticService? hapticService,
  Locale locale = const Locale('en'),
}) {
  Widget scope(Widget child) => ProviderScope(
    key: ValueKey(controller),
    overrides: [
      buddyChallengeStateProvider.overrideWith((ref) => controller),
      responseModeProvider.overrideWithValue(responseMode),
      if (hapticService != null)
        hapticServiceProvider.overrideWithValue(hapticService),
    ],
    child: child,
  );

  if (!withHostRoute) {
    return scope(
      MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BuddyChallengeScreen(),
      ),
    );
  }
  return scope(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      key: const ValueKey('buddy-host-app'),
      initialRoute: '/buddy',
      routes: {
        '/': (_) => const Scaffold(body: Text('Host screen')),
        '/buddy': (_) => const BuddyChallengeScreen(),
      },
    ),
  );
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

BuddyChallengeController _controller() {
  return BuddyChallengeController(
    problemFactory: ({required operation, required difficulty}) =>
        _problem(operation),
    operationPicker: (operations) => operations.last,
    hapticSubmittedAction: () {},
    hapticCorrectAction: () {},
    hapticIncorrectAction: () {},
  );
}

BuddyChallengeController _playingController({int pointsToWin = 5}) {
  final controller = _controller();
  controller.setPointsToWin(pointsToWin);
  controller.startGame();
  return controller;
}

BuddyChallengeController _wonController() {
  final controller = _controller();
  controller.setPlayerName(playerNumber: 1, name: 'Ana');
  controller.setPlayerName(playerNumber: 2, name: 'Ben');
  controller.setPointsToWin(5);
  controller.startGame();
  for (var round = 0; round < 5; round++) {
    final problem = controller.state.problem!;
    controller.submitAnswer(
      playerNumber: 1,
      answer: problem.correctAnswer,
      problemRevision: problem.revision,
    );
  }
  return controller;
}

MathProblem _problem(MathOperation operation) {
  return MathProblem(
    num1: 2,
    num2: 3,
    operation: operation,
    correctAnswer: 5,
    options: const [3, 4, 5, 6],
  );
}

class _BuddyHost extends StatelessWidget {
  const _BuddyHost();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const BuddyChallengeScreen(),
            ),
          ),
          child: const Text('Open Buddy'),
        ),
      ),
    );
  }
}
