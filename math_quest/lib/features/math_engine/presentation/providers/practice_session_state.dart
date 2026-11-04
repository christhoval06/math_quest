import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';

class PracticeSessionState {
  final MathOperation operation;
  final DifficultyLevel difficulty;
  final MathProblem currentProblem;
  final int? selectedAnswer;
  final bool isAnswerEvaluated;
  final bool isCorrect;
  final bool showVisualAids;
  final int currentStreak;
  final int questionsSolvedInSession;

  const PracticeSessionState({
    required this.operation,
    required this.difficulty,
    required this.currentProblem,
    this.selectedAnswer,
    this.isAnswerEvaluated = false,
    this.isCorrect = false,
    this.showVisualAids = true,
    this.currentStreak = 0,
    this.questionsSolvedInSession = 0,
  });

  PracticeSessionState copyWith({
    MathOperation? operation,
    DifficultyLevel? difficulty,
    MathProblem? currentProblem,
    int? selectedAnswer,
    bool? isAnswerEvaluated,
    bool? isCorrect,
    bool? showVisualAids,
    int? currentStreak,
    int? questionsSolvedInSession,
    bool clearSelection = false,
  }) {
    return PracticeSessionState(
      operation: operation ?? this.operation,
      difficulty: difficulty ?? this.difficulty,
      currentProblem: currentProblem ?? this.currentProblem,
      selectedAnswer: clearSelection
          ? null
          : (selectedAnswer ?? this.selectedAnswer),
      isAnswerEvaluated: isAnswerEvaluated ?? this.isAnswerEvaluated,
      isCorrect: isCorrect ?? this.isCorrect,
      showVisualAids: showVisualAids ?? this.showVisualAids,
      currentStreak: currentStreak ?? this.currentStreak,
      questionsSolvedInSession:
          questionsSolvedInSession ?? this.questionsSolvedInSession,
    );
  }
}
