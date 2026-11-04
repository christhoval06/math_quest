import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/gameplay/presentation/models/buddy_challenge_state.dart';
import 'package:math_quest/features/gameplay/presentation/screens/buddy_challenge_winner_screen.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/buddy_challenge_setup_panel.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/buddy_player_arena.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/buddy_score_divider.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/written_answer_pad.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('setup panel reports every configurable field', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final events = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: BuddyChallengeSetupPanel(
              settings: BuddyChallengeSettings(),
              onPlayerNameChanged: (player, name) =>
                  events.add('name:$player:$name'),
              onOperationToggled: (operation) =>
                  events.add('operation:${operation.name}'),
              onDifficultyChanged: (difficulty) =>
                  events.add('difficulty:${difficulty.name}'),
              onPointsToWinChanged: (points) => events.add('points:$points'),
              onStart: () => events.add('start'),
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('buddy-player-1-name')), 'Ana');
    await tester.tap(find.text('Multiplication'));
    await tester.tap(find.text('Hard'));
    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsOneWidget);
    final slider = tester.widget<Slider>(sliderFinder);
    expect(slider.min, 5);
    expect(slider.max, 10);
    expect(slider.divisions, 5);
    slider.onChanged!(10);
    await tester.pump();
    final startButton = find.widgetWithText(
      ElevatedButton,
      'Start Buddy Challenge! (First to 5 Points)',
    );
    await tester.tap(startButton);

    expect(
      events,
      containsAll([
        'name:1:Ana',
        'operation:multiplication',
        'difficulty:hard',
        'points:10',
        'start',
      ]),
    );
    expect(find.text('Apple counters'), findsOneWidget);
    expect(find.text('Boosters'), findsOneWidget);
    expect(find.byType(FilterChip), findsNothing);
    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets('player arena renders progress problem and revision callback', (
    tester,
  ) async {
    (int, int, int)? submission;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BuddyPlayerArena(
            playerNumber: 1,
            playerName: 'Ana',
            score: 2,
            targetScore: 10,
            problem: _problem,
            responseMode: ResponseMode.choice,
            isAnswerLocked: false,
            accentColor: Colors.blue,
            backgroundColor: Colors.blueAccent,
            rotateForOpponent: true,
            onInputFeedback: () {},
            onAnswer: (player, answer, revision) {
              submission = (player, answer, revision);
            },
          ),
        ),
      ),
    );

    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('2 + 3 = ?'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(10));
    expect(find.byKey(const Key('buddy-player-1-rotated')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('5'));
    expect(submission, (1, 5, 12));
  });

  testWidgets('locked player arena disables every answer option', (
    tester,
  ) async {
    var submissions = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BuddyPlayerArena(
            key: const Key('locked-arena'),
            playerNumber: 1,
            playerName: 'Ana',
            score: 0,
            targetScore: 5,
            problem: _problem,
            responseMode: ResponseMode.choice,
            isAnswerLocked: true,
            accentColor: Colors.blue,
            backgroundColor: Colors.blueAccent,
            rotateForOpponent: false,
            onInputFeedback: () {},
            onAnswer: (_, _, _) => submissions++,
          ),
        ),
      ),
    );

    final buttons = find.descendant(
      of: find.byKey(const Key('locked-arena')),
      matching: find.byType(ElevatedButton),
    );
    expect(buttons, findsNWidgets(4));
    expect(
      tester
          .widgetList<ElevatedButton>(buttons)
          .every((button) => button.onPressed == null),
      isTrue,
    );

    await tester.tap(find.text('5'));
    expect(submissions, 0);
  });

  testWidgets('long player name does not overflow at phone width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BuddyPlayerArena(
            playerNumber: 1,
            playerName: 'A very long player name that must never overflow',
            score: 7,
            targetScore: 10,
            problem: _problem,
            responseMode: ResponseMode.choice,
            isAnswerLocked: false,
            accentColor: Colors.blue,
            backgroundColor: Colors.blueAccent,
            rotateForOpponent: false,
            onInputFeedback: () {},
            onAnswer: (_, _, _) {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('write mode arena uses keypad and preserves revision callback', (
    tester,
  ) async {
    (int, int, int)? submission;
    var inputFeedbackCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BuddyPlayerArena(
            playerNumber: 2,
            playerName: 'Ben',
            score: 0,
            targetScore: 5,
            problem: _problem,
            responseMode: ResponseMode.write,
            isAnswerLocked: false,
            accentColor: Colors.red,
            backgroundColor: Colors.white,
            rotateForOpponent: false,
            onInputFeedback: () => inputFeedbackCount++,
            onAnswer: (player, answer, revision) {
              submission = (player, answer, revision);
            },
          ),
        ),
      ),
    );

    expect(find.byType(WrittenAnswerPad), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
    expect(find.byKey(const Key('written-answer-panel')), findsOneWidget);
    expect(find.byKey(const Key('written-keypad-panel')), findsOneWidget);
    expect(find.text('Check Answer'), findsNothing);
    expect(find.byKey(const Key('written-delete')), findsNothing);
    expect(find.byKey(const Key('written-confirm')), findsNothing);
    expect(
      tester.getSize(find.byKey(const Key('written-digit-5'))).height,
      greaterThanOrEqualTo(44),
    );
    await tester.tap(find.byKey(const Key('written-digit-5')));
    await tester.pump(const Duration(milliseconds: 450));

    expect(submission, (2, 5, 12));
    expect(inputFeedbackCount, 1);
  });

  testWidgets('locked write mode arena ignores keypad feedback', (
    tester,
  ) async {
    var inputFeedbackCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BuddyPlayerArena(
            playerNumber: 1,
            playerName: 'Ana',
            score: 0,
            targetScore: 5,
            problem: _problem,
            responseMode: ResponseMode.write,
            isAnswerLocked: true,
            accentColor: Colors.blue,
            backgroundColor: Colors.white,
            rotateForOpponent: false,
            onInputFeedback: () => inputFeedbackCount++,
            onAnswer: (_, _, _) {},
          ),
        ),
      ),
    );

    final digit = tester.widget<FilledButton>(
      find.byKey(const Key('written-digit-5')),
    );
    expect(digit.onPressed, isNull);
    expect(inputFeedbackCount, 0);
  });

  testWidgets('score divider renders win target and invokes close', (
    tester,
  ) async {
    var closeCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BuddyScoreDivider(
            player1Score: 2,
            player2Score: 1,
            pointsToWin: 10,
            onClose: () => closeCount++,
          ),
        ),
      ),
    );

    expect(find.text('P1: 2  vs  P2: 1'), findsOneWidget);
    expect(find.text('First to 10 points'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_rounded));
    expect(closeCount, 1);
  });

  testWidgets('winner screen celebrates named champion without a dialog', (
    tester,
  ) async {
    final actions = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BuddyChallengeWinnerScreen(
          winnerName: 'Ana',
          winnerNumber: 1,
          player1Score: 8,
          player2Score: 7,
          onExit: () => actions.add('exit'),
          onPlayAgain: () => actions.add('again'),
          onChangeSettings: () => actions.add('settings'),
        ),
      ),
    );

    expect(find.text('Ana Wins!'), findsOneWidget);
    expect(find.text('8 – 7'), findsOneWidget);
    expect(find.text('CHAMPION'), findsOneWidget);
    expect(find.text('FINAL SCORE'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Final score: Player 1, 8; Player 2, 7'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);
    expect(find.byType(ConfettiWidget), findsNWidgets(2));
    expect(find.byType(Dialog), findsNothing);

    await tester.tap(find.text('Play Again'));
    await tester.tap(find.text('Change Settings'));
    await tester.tap(find.text('Exit'));
    expect(actions, ['again', 'settings', 'exit']);
  });

  for (final reducedMotion in <MediaQueryData>[
    const MediaQueryData(accessibleNavigation: true),
    const MediaQueryData(disableAnimations: true),
  ]) {
    testWidgets('winner screen respects each reduced-motion preference', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MediaQuery(
            data: reducedMotion,
            child: BuddyChallengeWinnerScreen(
              winnerName: 'Ben',
              winnerNumber: 2,
              player1Score: 6,
              player2Score: 7,
              onExit: () {},
              onPlayAgain: () {},
              onChangeSettings: () {},
            ),
          ),
        ),
      );

      final fade = tester.widget<FadeTransition>(
        find.byKey(const Key('buddy-winner-entrance')),
      );
      expect(find.text('Ben Wins!'), findsOneWidget);
      expect(find.text('CHAMPION'), findsOneWidget);
      expect(find.byType(ConfettiWidget), findsNothing);
      expect(fade.opacity.value, 1);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('winner screen stops motion when preference changes at runtime', (
    tester,
  ) async {
    final disableAnimations = ValueNotifier(false);
    addTearDown(disableAnimations.dispose);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ValueListenableBuilder<bool>(
          valueListenable: disableAnimations,
          builder: (context, disabled, child) => MediaQuery(
            data: MediaQueryData(disableAnimations: disabled),
            child: BuddyChallengeWinnerScreen(
              winnerName: 'Ana',
              winnerNumber: 1,
              player1Score: 7,
              player2Score: 5,
              onExit: () {},
              onPlayAgain: () {},
              onChangeSettings: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ConfettiWidget), findsNWidgets(2));
    disableAnimations.value = true;
    await tester.pump();

    final fade = tester.widget<FadeTransition>(
      find.byKey(const Key('buddy-winner-entrance')),
    );
    expect(find.byType(ConfettiWidget), findsNothing);
    expect(fade.opacity.value, 1);
  });

  testWidgets('winner text and primary action meet contrast requirements', (
    tester,
  ) async {
    for (final winnerNumber in [1, 2]) {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BuddyChallengeWinnerScreen(
            winnerName: 'Champion',
            winnerNumber: winnerNumber,
            player1Score: 7,
            player2Score: 5,
            onExit: () {},
            onPlayAgain: () {},
            onChangeSettings: () {},
          ),
        ),
      );

      final champion = tester.widget<Text>(find.text('CHAMPION'));
      final title = tester.widget<Text>(find.text('Champion Wins!'));
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Play Again'),
      );
      final buttonBackground = button.style!.backgroundColor!.resolve({})!;
      final buttonForeground = button.style!.foregroundColor!.resolve({})!;

      expect(
        _contrastRatio(champion.style!.color!, Colors.white),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrastRatio(title.style!.color!, Colors.white),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrastRatio(buttonForeground, buttonBackground),
        greaterThanOrEqualTo(4.5),
      );
    }
  });
}

double _contrastRatio(Color first, Color second) {
  final lighter = first.computeLuminance() > second.computeLuminance()
      ? first
      : second;
  final darker = identical(lighter, first) ? second : first;
  return (lighter.computeLuminance() + 0.05) /
      (darker.computeLuminance() + 0.05);
}

final _problem = BuddyProblemViewData(
  equation: '2 + 3 = ?',
  correctAnswer: 5,
  options: const [3, 4, 5, 6],
  revision: 12,
);
