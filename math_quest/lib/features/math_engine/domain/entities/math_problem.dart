import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';

class MathProblem {
  final int num1;
  final int num2;
  final MathOperation operation;
  final int correctAnswer;
  final List<int> options;

  const MathProblem({
    required this.num1,
    required this.num2,
    required this.operation,
    required this.correctAnswer,
    required this.options,
  });

  // Base-10 decomposition for pedagogical counting aids
  int get num1Tens => num1 ~/ 10;
  int get num1Ones => num1 % 10;
  int get num2Tens => num2 ~/ 10;
  int get num2Ones => num2 % 10;
}
