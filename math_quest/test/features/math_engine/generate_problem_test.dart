import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/usecases/generate_problem_usecase.dart';

void main() {
  late GenerateProblemUseCase useCase;

  setUp(() {
    useCase = GenerateProblemUseCase();
  });

  group('Math Problem Generator - Pedagogical Guard Tests', () {
    test('Division MUST NEVER produce fractions or remainders (100 runs)', () {
      for (final diff in DifficultyLevel.values) {
        for (int i = 0; i < 100; i++) {
          final problem = useCase.execute(
            operation: MathOperation.division,
            difficulty: diff,
          );
          expect(
            problem.num1 % problem.num2,
            equals(0),
            reason: 'Failed on ${problem.num1} ÷ ${problem.num2}',
          );
          expect(problem.num1 / problem.num2, equals(problem.correctAnswer));
        }
      }
    });

    test('Subtraction MUST NEVER produce negative results (100 runs)', () {
      for (final diff in DifficultyLevel.values) {
        for (int i = 0; i < 100; i++) {
          final problem = useCase.execute(
            operation: MathOperation.subtraction,
            difficulty: diff,
          );
          expect(
            problem.num1,
            greaterThanOrEqualTo(problem.num2),
            reason: 'Negative result on ${problem.num1} - ${problem.num2}',
          );
          expect(problem.correctAnswer, greaterThanOrEqualTo(0));
        }
      }
    });

    test('Multiple Choice options MUST contain 4 unique items including the answer', () {
      final problem = useCase.execute(
        operation: MathOperation.multiplication,
        difficulty: DifficultyLevel.medium,
      );
      expect(problem.options.length, equals(4));
      expect(problem.options.toSet().length, equals(4)); // No duplicates
      expect(problem.options.contains(problem.correctAnswer), isTrue);
    });
  });
}
