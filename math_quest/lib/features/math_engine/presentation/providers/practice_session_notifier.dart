import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/usecases/generate_problem_usecase.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_state.dart';

class PracticeSessionNotifier extends StateNotifier<PracticeSessionState> {
  final GenerateProblemUseCase _generateProblemUseCase;

  PracticeSessionNotifier({
    required GenerateProblemUseCase generateProblemUseCase,
    MathOperation initialOperation = MathOperation.addition,
    DifficultyLevel initialDifficulty = DifficultyLevel.easy,
  }) : _generateProblemUseCase = generateProblemUseCase,
       super(
         PracticeSessionState(
           operation: initialOperation,
           difficulty: initialDifficulty,
           currentProblem: generateProblemUseCase.execute(
             operation: initialOperation,
             difficulty: initialDifficulty,
           ),
         ),
       );

  void selectAnswer(int answer) {
    if (state.isAnswerEvaluated) return; // Prevent changing after submission
    state = state.copyWith(selectedAnswer: answer);
  }

  void evaluateAnswer() {
    if (state.selectedAnswer == null || state.isAnswerEvaluated) return;

    final isCorrect =
        state.selectedAnswer == state.currentProblem.correctAnswer;
    final newStreak = isCorrect ? state.currentStreak + 1 : 0;

    state = state.copyWith(
      isAnswerEvaluated: true,
      isCorrect: isCorrect,
      currentStreak: newStreak,
      questionsSolvedInSession:
          state.questionsSolvedInSession + (isCorrect ? 1 : 0),
    );
  }

  void nextProblem({MathOperation? operation}) {
    final op = operation ?? state.operation;
    final nextProblem = _generateProblemUseCase.execute(
      operation: op,
      difficulty: state.difficulty,
    );

    state = state.copyWith(
      operation: op,
      currentProblem: nextProblem,
      clearSelection: true,
      isAnswerEvaluated: false,
      isCorrect: false,
    );
  }

  void toggleVisualAids() {
    state = state.copyWith(showVisualAids: !state.showVisualAids);
  }

  void setVisualAidsEnabled(bool enabled) {
    state = state.copyWith(showVisualAids: enabled);
  }

  void updateConfiguration({
    MathOperation? operation,
    DifficultyLevel? difficulty,
  }) {
    final newOp = operation ?? state.operation;
    final newDiff = difficulty ?? state.difficulty;
    final newProblem = _generateProblemUseCase.execute(
      operation: newOp,
      difficulty: newDiff,
    );

    state = state.copyWith(
      operation: newOp,
      difficulty: newDiff,
      currentProblem: newProblem,
      clearSelection: true,
      isAnswerEvaluated: false,
    );
  }

  void resetSession({MathOperation? operation, DifficultyLevel? difficulty}) {
    final op = operation ?? state.operation;
    final diff = difficulty ?? state.difficulty;

    state = PracticeSessionState(
      operation: op,
      difficulty: diff,
      currentProblem: _generateProblemUseCase.execute(
        operation: op,
        difficulty: diff,
      ),
      selectedAnswer: null,
      isAnswerEvaluated: false,
      isCorrect: false,
      showVisualAids: state.showVisualAids,
      currentStreak:
          state.currentStreak, // Preserves the child's active streak!
      questionsSolvedInSession: 0, // 👈 RESETS TO 0 QUESTIONS!
    );
  }
}

// Global Provider
final practiceSessionProvider =
    StateNotifierProvider<PracticeSessionNotifier, PracticeSessionState>((ref) {
      return PracticeSessionNotifier(
        generateProblemUseCase: GenerateProblemUseCase(),
      );
    });
