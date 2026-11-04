import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/features/gameplay/presentation/models/buddy_challenge_state.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';

typedef BuddyProblemFactory = MathProblem Function({
  required MathOperation operation,
  required DifficultyLevel difficulty,
});
typedef BuddyOperationPicker = MathOperation Function(
  List<MathOperation> operations,
);
typedef BuddyHapticAction = void Function();

class BuddyChallengeController extends StateNotifier<BuddyChallengeState> {
  final BuddyProblemFactory problemFactory;
  final BuddyOperationPicker operationPicker;
  final BuddyHapticAction hapticSubmittedAction;
  final BuddyHapticAction hapticCorrectAction;
  final BuddyHapticAction hapticIncorrectAction;
  int _revision = 0;

  BuddyChallengeController({
    required this.problemFactory,
    required this.operationPicker,
    required this.hapticSubmittedAction,
    required this.hapticCorrectAction,
    required this.hapticIncorrectAction,
    BuddyChallengeSettings? initialSettings,
  }) : super(
         BuddyChallengeState(
           phase: BuddyChallengePhase.setup,
           settings: initialSettings ?? BuddyChallengeSettings(),
         ),
       );

  static BuddyProblemViewData _validatedView(
    MathProblem problem,
    int revision,
  ) {
    final distinctOptions = problem.options.toSet();
    if (problem.options.length != 4 ||
        distinctOptions.length != 4 ||
        !distinctOptions.contains(problem.correctAnswer)) {
      throw ArgumentError.value(
        problem.options,
        'problem.options',
        'Must contain four distinct values including the correct answer',
      );
    }
    return BuddyProblemViewData(
      equation:
          '${problem.num1} ${problem.operation.symbol} ${problem.num2} = ?',
      correctAnswer: problem.correctAnswer,
      options: problem.options,
      revision: revision,
    );
  }

  void setPlayerName({required int playerNumber, required String name}) {
    _requireSetup();
    if (playerNumber != 1 && playerNumber != 2) {
      throw ArgumentError.value(playerNumber, 'playerNumber', 'Must be 1 or 2');
    }
    final settings = playerNumber == 1
        ? state.settings.copyWith(player1Name: name)
        : state.settings.copyWith(player2Name: name);
    _publishSetup(settings);
  }

  void toggleOperation(MathOperation operation) {
    _requireSetup();
    final operations = List<MathOperation>.from(state.settings.operations);
    if (operations.contains(operation)) {
      operations.remove(operation);
    } else {
      operations.add(operation);
    }
    _publishSetup(state.settings.copyWith(operations: operations));
  }

  void setDifficulty(DifficultyLevel difficulty) {
    _requireSetup();
    _publishSetup(state.settings.copyWith(difficulty: difficulty));
  }

  void setPointsToWin(int pointsToWin) {
    _requireSetup();
    if (!BuddyChallengeSettings.allowedPointsToWin.contains(pointsToWin)) {
      throw ArgumentError.value(
        pointsToWin,
        'pointsToWin',
        'Must be from 5 through 10',
      );
    }
    _publishSetup(state.settings.copyWith(pointsToWin: pointsToWin));
  }

  void startGame() {
    _requireSetup();
    if (!state.settings.canStart) {
      throw StateError('Both names and at least one operation are required');
    }
    _startWithSettings(
      state.settings.copyWith(
        player1Name: state.settings.player1Name.trim(),
        player2Name: state.settings.player2Name.trim(),
      ),
    );
  }

  void submitAnswer({
    required int playerNumber,
    required int answer,
    required int problemRevision,
  }) {
    if (playerNumber != 1 && playerNumber != 2) {
      throw ArgumentError.value(playerNumber, 'playerNumber', 'Must be 1 or 2');
    }
    final currentProblem = state.problem;
    if (state.phase != BuddyChallengePhase.playing ||
        currentProblem == null ||
        problemRevision != currentProblem.revision ||
        state.hasAnswered(playerNumber)) {
      return;
    }

    hapticSubmittedAction();

    if (answer != currentProblem.correctAnswer) {
      hapticIncorrectAction();
      final answeredPlayers = {...state.answeredPlayers, playerNumber};
      if (answeredPlayers.length == 2) {
        state = BuddyChallengeState(
          phase: BuddyChallengePhase.playing,
          settings: state.settings,
          problem: _createProblem(state.settings),
          player1Score: state.player1Score,
          player2Score: state.player2Score,
        );
      } else {
        state = BuddyChallengeState(
          phase: BuddyChallengePhase.playing,
          settings: state.settings,
          problem: currentProblem,
          player1Score: state.player1Score,
          player2Score: state.player2Score,
          answeredPlayers: answeredPlayers,
        );
      }
      return;
    }

    hapticCorrectAction();

    final player1Score = state.player1Score + (playerNumber == 1 ? 1 : 0);
    final player2Score = state.player2Score + (playerNumber == 2 ? 1 : 0);
    final reachedTarget =
        player1Score >= state.settings.pointsToWin ||
        player2Score >= state.settings.pointsToWin;
    if (reachedTarget) {
      state = BuddyChallengeState(
        phase: BuddyChallengePhase.finished,
        settings: state.settings,
        problem: currentProblem,
        player1Score: player1Score,
        player2Score: player2Score,
        winner: playerNumber,
      );
      return;
    }

    final nextProblem = _createProblem(state.settings);
    state = BuddyChallengeState(
      phase: BuddyChallengePhase.playing,
      settings: state.settings,
      problem: nextProblem,
      player1Score: player1Score,
      player2Score: player2Score,
    );
  }

  void playAgain() {
    if (state.phase != BuddyChallengePhase.finished) {
      throw StateError('A finished challenge is required');
    }
    _startWithSettings(state.settings);
  }

  void resetGame() => playAgain();

  void changeSettings() {
    if (state.phase != BuddyChallengePhase.finished) {
      throw StateError('A finished challenge is required');
    }
    state = BuddyChallengeState(
      phase: BuddyChallengePhase.setup,
      settings: state.settings,
    );
  }

  void _startWithSettings(BuddyChallengeSettings settings) {
    final problem = _createProblem(settings);
    state = BuddyChallengeState(
      phase: BuddyChallengePhase.playing,
      settings: settings,
      problem: problem,
    );
  }

  BuddyProblemViewData _createProblem(BuddyChallengeSettings settings) {
    final operation = operationPicker(settings.operations);
    final nextRevision = _revision + 1;
    final problem = _validatedView(
      problemFactory(operation: operation, difficulty: settings.difficulty),
      nextRevision,
    );
    _revision = nextRevision;
    return problem;
  }

  void _publishSetup(BuddyChallengeSettings settings) {
    state = BuddyChallengeState(
      phase: BuddyChallengePhase.setup,
      settings: settings,
    );
  }

  void _requireSetup() {
    if (state.phase != BuddyChallengePhase.setup) {
      throw StateError('Challenge settings can only change before the game');
    }
  }
}
