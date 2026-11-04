import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';
import 'package:math_quest/features/math_engine/domain/usecases/generate_problem_usecase.dart';

class SuperpowerChallenge {
  final String id;
  final String title;
  final String description;
  final String icon;
  final MathOperation operation;
  final DifficultyLevel difficulty;
  final MathProblem Function() problemGenerator;

  const SuperpowerChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.operation,
    required this.difficulty,
    required this.problemGenerator,
  });

  /// 7 Pedagogical Mental Math Strategies
  static List<SuperpowerChallenge> get catalog {
    final defaultGenerator = GenerateProblemUseCase();

    return [
      // 1. Doubles + 1 (Addition)
      SuperpowerChallenge(
        id: 'doubles_plus_one',
        title: 'The "Doubles + 1" Trick!',
        description: 'If you know 6 + 6 = 12, then 6 + 7 is super easy: just add 1 more to reach 13!',
        icon: '💡',
        operation: MathOperation.addition,
        difficulty: DifficultyLevel.easy,
        problemGenerator: () {
          // Generates n + (n+1) e.g. 4+5, 6+7, 7+8
          final n = (DateTime.now().microsecond % 5) + 3; // 3 to 7
          final n2 = n + 1;
          final ans = n + n2;
          return MathProblem(
            num1: n,
            num2: n2,
            operation: MathOperation.addition,
            correctAnswer: ans,
            options: [ans, ans - 1, ans + 2, ans + 1]..shuffle(),
          );
        },
      ),

      // 2. Make a 10 (Addition)
      SuperpowerChallenge(
        id: 'make_a_ten',
        title: 'The "Make a 10" Secret!',
        description: '8 + 5 looks hard? Take 2 from the 5 to turn 8 into 10! Then 10 + 3 = 13!',
        icon: '🎯',
        operation: MathOperation.addition,
        difficulty: DifficultyLevel.medium,
        problemGenerator: () {
          // Generates 8 + x or 9 + x
          final n1 = (DateTime.now().microsecond % 2 == 0) ? 8 : 9;
          final n2 = (DateTime.now().microsecond % 5) + 4; // 4 to 8
          final ans = n1 + n2;
          return MathProblem(
            num1: n1,
            num2: n2,
            operation: MathOperation.addition,
            correctAnswer: ans,
            options: [ans, ans + 1, ans - 2, ans - 1]..shuffle(),
          );
        },
      ),

      // 3. Subtract to 10 (Subtraction)
      SuperpowerChallenge(
        id: 'subtract_to_ten',
        title: 'The "Drop to 10" Trick!',
        description: 'Solving 15 - 7? First drop 5 to hit 10, then drop the remaining 2 to get 8!',
        icon: '⚡',
        operation: MathOperation.subtraction,
        difficulty: DifficultyLevel.medium,
        problemGenerator: () {
          final n1 = (DateTime.now().microsecond % 6) + 13; // 13 to 18
          final n2 = (DateTime.now().microsecond % 4) + 6; // 6 to 9
          final ans = n1 - n2;
          return MathProblem(
            num1: n1,
            num2: n2,
            operation: MathOperation.subtraction,
            correctAnswer: ans,
            options: [ans, ans + 1, ans - 1, ans + 2]..shuffle(),
          );
        },
      ),

      // 4. Multiplying by 5 is Half of 10!
      SuperpowerChallenge(
        id: 'times_five_half_ten',
        title: 'The "Multiply by 5" Hack!',
        description: '6 × 5? Just add a zero to get 60, then take half of that: 30! Works every time!',
        icon: '🖐️',
        operation: MathOperation.multiplication,
        difficulty: DifficultyLevel.medium,
        problemGenerator: () {
          final evens = [2, 4, 6, 8, 12, 14];
          final n = evens[DateTime.now().microsecond % evens.length];
          final ans = n * 5;
          return MathProblem(
            num1: n,
            num2: 5,
            operation: MathOperation.multiplication,
            correctAnswer: ans,
            options: [ans, ans - 5, ans + 5, ans + 10]..shuffle(),
          );
        },
      ),

      // 5. The 9s Multiplication Finger Magic
      SuperpowerChallenge(
        id: 'nine_times_magic',
        title: 'The Magic of 9s!',
        description: 'The digits of 9 times table always add up to 9! 9 × 3 = 27 (2+7=9). 9 × 4 = 36 (3+6=9)!',
        icon: '✨',
        operation: MathOperation.multiplication,
        difficulty: DifficultyLevel.medium,
        problemGenerator: () {
          final n = (DateTime.now().microsecond % 8) + 2; // 2 to 9
          final ans = 9 * n;
          return MathProblem(
            num1: 9,
            num2: n,
            operation: MathOperation.multiplication,
            correctAnswer: ans,
            options: [ans, ans - 9, ans + 9, ans + 1]..shuffle(),
          );
        },
      ),

      // 6. Halving for Division
      SuperpowerChallenge(
        id: 'halving_division',
        title: 'Divide by 4 by Halving Twice!',
        description: 'To divide by 4, just cut the number in half, and then in half again! 28 → 14 → 7!',
        icon: '✂️',
        operation: MathOperation.division,
        difficulty: DifficultyLevel.medium,
        problemGenerator: () {
          final answers = [3, 4, 5, 6, 7, 8, 9];
          final ans = answers[DateTime.now().microsecond % answers.length];
          final n1 = ans * 4;
          return MathProblem(
            num1: n1,
            num2: 4,
            operation: MathOperation.division,
            correctAnswer: ans,
            options: [ans, ans + 1, ans - 1, ans + 2]..shuffle(),
          );
        },
      ),

      // 7. The Zero Hero
      SuperpowerChallenge(
        id: 'zero_hero',
        title: 'The "Zero Hero" Rule!',
        description: 'Any number plus zero stays itself, but any number times zero always vanishes to 0!',
        icon: '🦸',
        operation: MathOperation.multiplication,
        difficulty: DifficultyLevel.easy,
        problemGenerator: () {
          final n = (DateTime.now().microsecond % 20) + 1;
          return MathProblem(
            num1: n,
            num2: 0,
            operation: MathOperation.multiplication,
            correctAnswer: 0,
            options: [0, n, n + 1, 1]..shuffle(),
          );
        },
      ),
    ];
  }
}
