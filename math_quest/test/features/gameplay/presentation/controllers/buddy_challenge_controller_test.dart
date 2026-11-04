import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/gameplay/presentation/controllers/buddy_challenge_controller.dart';
import 'package:math_quest/features/gameplay/presentation/models/buddy_challenge_state.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';

void main() {
  test('opens in setup without generating a problem', () {
    final factory = _RecordingProblemFactory();
    final controller = _controller(factory);

    expect(controller.state.phase, BuddyChallengePhase.setup);
    expect(controller.state.problem, isNull);
    expect(controller.state.settings.player1Name, 'Player 1');
    expect(controller.state.settings.player2Name, 'Player 2');
    expect(controller.state.settings.operations, [MathOperation.addition]);
    expect(controller.state.settings.difficulty, DifficultyLevel.easy);
    expect(controller.state.settings.pointsToWin, 5);
    expect(factory.callCount, 0);
    expect(
      () => controller.state.settings.operations.add(MathOperation.division),
      throwsUnsupportedError,
    );
  });

  test('setup changes names, operations, difficulty, and points to win', () {
    final controller = _controller(_RecordingProblemFactory());

    controller.setPlayerName(playerNumber: 1, name: '  Ana  ');
    controller.setPlayerName(playerNumber: 2, name: 'Ben');
    controller.toggleOperation(MathOperation.multiplication);
    controller.setDifficulty(DifficultyLevel.hard);
    controller.setPointsToWin(10);

    expect(controller.state.settings.player1Name, '  Ana  ');
    expect(controller.state.settings.player2Name, 'Ben');
    expect(controller.state.settings.operations, [
      MathOperation.addition,
      MathOperation.multiplication,
    ]);
    expect(controller.state.settings.difficulty, DifficultyLevel.hard);
    expect(controller.state.settings.pointsToWin, 10);
  });

  test('points to win accepts every value from five through ten', () {
    final controller = _controller(_RecordingProblemFactory());

    for (final points in [5, 6, 7, 8, 9, 10]) {
      controller.setPointsToWin(points);
      expect(controller.state.settings.pointsToWin, points);
    }
    for (final points in [0, 1, 4, 11, 15]) {
      expect(() => controller.setPointsToWin(points), throwsArgumentError);
    }
  });

  test('start validates names and at least one operation', () {
    final factory = _RecordingProblemFactory();
    final controller = _controller(factory);

    controller.setPlayerName(playerNumber: 1, name: '   ');
    expect(controller.startGame, throwsStateError);
    controller.setPlayerName(playerNumber: 1, name: 'Ana');
    controller.toggleOperation(MathOperation.addition);
    expect(controller.startGame, throwsStateError);

    expect(controller.state.phase, BuddyChallengePhase.setup);
    expect(factory.callCount, 0);
  });

  test('start trims names and generates from selected configuration', () {
    final factory = _RecordingProblemFactory();
    final controller = _controller(factory);
    controller.setPlayerName(playerNumber: 1, name: '  Ana  ');
    controller.setPlayerName(playerNumber: 2, name: '  Ben ');
    controller.toggleOperation(MathOperation.addition);
    controller.toggleOperation(MathOperation.division);
    controller.setDifficulty(DifficultyLevel.medium);
    controller.setPointsToWin(10);

    controller.startGame();

    expect(controller.state.phase, BuddyChallengePhase.playing);
    expect(controller.state.settings.player1Name, 'Ana');
    expect(controller.state.settings.player2Name, 'Ben');
    expect(controller.state.problem?.revision, 1);
    expect(factory.operations, [MathOperation.division]);
    expect(factory.difficulties, [DifficultyLevel.medium]);
  });

  test('wrong answer locks that player while the opponent can score', () {
    final factory = _RecordingProblemFactory();
    final controller = _controller(factory)..startGame();
    final problem = controller.state.problem!;

    controller.submitAnswer(
      playerNumber: 1,
      answer: problem.correctAnswer + 100,
      problemRevision: problem.revision,
    );
    final afterWrongAnswer = controller.state;

    expect(controller.state.hasAnswered(1), isTrue);
    expect(controller.state.hasAnswered(2), isFalse);
    expect(controller.state.problem?.revision, problem.revision);
    expect(controller.state.player1Score, 0);

    controller.submitAnswer(
      playerNumber: 1,
      answer: problem.correctAnswer,
      problemRevision: problem.revision,
    );

    expect(identical(controller.state, afterWrongAnswer), isTrue);
    expect(controller.state.player1Score, 0);

    controller.submitAnswer(
      playerNumber: 2,
      answer: problem.correctAnswer,
      problemRevision: problem.revision,
    );

    expect(controller.state.player1Score, 0);
    expect(controller.state.player2Score, 1);
    expect(controller.state.problem?.revision, 2);
    expect(controller.state.answeredPlayers, isEmpty);
    expect(factory.callCount, 2);
  });

  test('accepted answers emit submit feedback before their result', () {
    final events = <String>[];
    final controller = _controller(
      _RecordingProblemFactory(),
      hapticEvents: events,
    )..startGame();
    var problem = controller.state.problem!;

    controller.submitAnswer(
      playerNumber: 1,
      answer: problem.correctAnswer + 1,
      problemRevision: problem.revision,
    );
    expect(events, ['submitted', 'incorrect']);

    problem = controller.state.problem!;
    controller.submitAnswer(
      playerNumber: 2,
      answer: problem.correctAnswer,
      problemRevision: problem.revision,
    );
    expect(events, ['submitted', 'incorrect', 'submitted', 'correct']);
  });

  test('ignored duplicate, stale, and finished answers emit no feedback', () {
    final events = <String>[];
    final controller = _controller(
      _RecordingProblemFactory(),
      hapticEvents: events,
    )..startGame();
    final firstProblem = controller.state.problem!;

    controller.submitAnswer(
      playerNumber: 1,
      answer: firstProblem.correctAnswer + 1,
      problemRevision: firstProblem.revision,
    );
    events.clear();
    controller.submitAnswer(
      playerNumber: 1,
      answer: firstProblem.correctAnswer,
      problemRevision: firstProblem.revision,
    );
    controller.submitAnswer(
      playerNumber: 2,
      answer: firstProblem.correctAnswer,
      problemRevision: firstProblem.revision - 1,
    );
    expect(events, isEmpty);

    controller.submitAnswer(
      playerNumber: 2,
      answer: firstProblem.correctAnswer,
      problemRevision: firstProblem.revision,
    );
    while (controller.state.phase == BuddyChallengePhase.playing) {
      _score(controller, 1);
    }
    events.clear();
    final finished = controller.state;
    controller.submitAnswer(
      playerNumber: 2,
      answer: finished.problem!.correctAnswer,
      problemRevision: finished.problem!.revision,
    );
    expect(events, isEmpty);
  });

  test('two wrong answers advance without scoring and reset attempts', () {
    final factory = _RecordingProblemFactory();
    final controller = _controller(factory)..startGame();
    final problem = controller.state.problem!;

    controller.submitAnswer(
      playerNumber: 1,
      answer: problem.correctAnswer + 1,
      problemRevision: problem.revision,
    );
    controller.submitAnswer(
      playerNumber: 2,
      answer: problem.correctAnswer + 2,
      problemRevision: problem.revision,
    );

    expect(controller.state.player1Score, 0);
    expect(controller.state.player2Score, 0);
    expect(controller.state.problem?.revision, 2);
    expect(controller.state.answeredPlayers, isEmpty);
    expect(factory.callCount, 2);
  });

  test(
    'correct answer scores one round and creates one replacement problem',
    () {
      final factory = _RecordingProblemFactory();
      final controller = _controller(factory)..startGame();
      final problem = controller.state.problem!;

      controller.submitAnswer(
        playerNumber: 2,
        answer: problem.correctAnswer,
        problemRevision: problem.revision,
      );

      expect(controller.state.player2Score, 1);
      expect(controller.state.problem?.revision, 2);
      expect(factory.callCount, 2);
    },
  );

  test('first player to reach the configured points wins immediately', () {
    final factory = _RecordingProblemFactory();
    final controller = _controller(factory);
    controller.setPointsToWin(7);
    controller.startGame();

    for (var round = 0; round < 6; round++) {
      _score(controller, 1);
      _score(controller, 2);
    }

    expect(controller.state.phase, BuddyChallengePhase.playing);
    expect(controller.state.player1Score, 6);
    expect(controller.state.player2Score, 6);

    _score(controller, 2);

    expect(controller.state.phase, BuddyChallengePhase.finished);
    expect(controller.state.player1Score, 6);
    expect(controller.state.player2Score, 7);
    expect(controller.state.winner, 2);
    expect(factory.callCount, 13);
  });

  test('answers after finish are ignored', () {
    final controller = _controller(_RecordingProblemFactory());
    controller.setPointsToWin(5);
    controller.startGame();
    for (var round = 0; round < 5; round++) {
      _score(controller, 1);
    }
    final finished = controller.state;

    controller.submitAnswer(
      playerNumber: 2,
      answer: finished.problem!.correctAnswer,
      problemRevision: finished.problem!.revision,
    );

    expect(identical(controller.state, finished), isTrue);
  });

  test('play again keeps settings while change settings returns to setup', () {
    final factory = _RecordingProblemFactory();
    final controller = _controller(factory);
    controller.setPlayerName(playerNumber: 1, name: 'Ana');
    controller.setPointsToWin(5);
    controller.startGame();
    for (var round = 0; round < 5; round++) {
      _score(controller, 1);
    }

    controller.playAgain();

    expect(controller.state.phase, BuddyChallengePhase.playing);
    expect(controller.state.settings.player1Name, 'Ana');
    expect(controller.state.player1Score, 0);
    expect(controller.state.winner, isNull);

    for (var round = 0; round < 5; round++) {
      _score(controller, 2);
    }
    controller.changeSettings();

    expect(controller.state.phase, BuddyChallengePhase.setup);
    expect(controller.state.problem, isNull);
    expect(controller.state.settings.player1Name, 'Ana');
  });

  test('malformed generated problem preserves setup state', () {
    final controller = BuddyChallengeController(
      problemFactory: ({required operation, required difficulty}) =>
          _problem(operation: operation, options: [2, 3, 5]),
      operationPicker: (operations) => operations.first,
      hapticSubmittedAction: () {},
      hapticCorrectAction: () {},
      hapticIncorrectAction: () {},
    );
    final previous = controller.state;

    expect(controller.startGame, throwsArgumentError);

    expect(identical(controller.state, previous), isTrue);
  });
}

BuddyChallengeController _controller(
  _RecordingProblemFactory factory, {
  List<String>? hapticEvents,
}) {
  return BuddyChallengeController(
    problemFactory: factory.call,
    operationPicker: (operations) => operations.last,
    hapticSubmittedAction: () => hapticEvents?.add('submitted'),
    hapticCorrectAction: () => hapticEvents?.add('correct'),
    hapticIncorrectAction: () => hapticEvents?.add('incorrect'),
  );
}

void _score(BuddyChallengeController controller, int playerNumber) {
  final problem = controller.state.problem!;
  controller.submitAnswer(
    playerNumber: playerNumber,
    answer: problem.correctAnswer,
    problemRevision: problem.revision,
  );
}

MathProblem _problem({
  required MathOperation operation,
  List<int> options = const [3, 4, 5, 6],
}) {
  return MathProblem(
    num1: 2,
    num2: 3,
    operation: operation,
    correctAnswer: 5,
    options: options,
  );
}

class _RecordingProblemFactory {
  int callCount = 0;
  final List<MathOperation> operations = [];
  final List<DifficultyLevel> difficulties = [];

  MathProblem call({
    required MathOperation operation,
    required DifficultyLevel difficulty,
  }) {
    callCount++;
    operations.add(operation);
    difficulties.add(difficulty);
    return _problem(operation: operation);
  }
}
