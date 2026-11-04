import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';

class AnswerSubmission {
  final MathProblem problem;
  final int? selectedAnswer;
  final Duration timeTaken;

  const AnswerSubmission({
    required this.problem,
    required this.selectedAnswer,
    required this.timeTaken,
  });

  bool get isCorrect => selectedAnswer == problem.correctAnswer;
}
