import 'dart:math';

import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';

class GenerateProblemUseCase {
  final Random _rand;

  GenerateProblemUseCase({Random? random}) : _rand = random ?? Random();

  MathProblem execute({
    required MathOperation operation,
    required DifficultyLevel difficulty,
  }) {
    int n1 = 0;
    int n2 = 0;
    int answer = 0;

    switch (operation) {
      // -------------------------------------------------------------
      // 1. ADDITION
      // -------------------------------------------------------------
      case MathOperation.addition:
        if (difficulty == DifficultyLevel.easy) {
          n1 = _rand.nextInt(5) + 1; // 1..5
          n2 = _rand.nextInt(5) + 1; // Sum <= 10
        } else if (difficulty == DifficultyLevel.medium) {
          n1 = _rand.nextInt(40) + 10; // 10..49
          n2 = _rand.nextInt(40) + 10; // Sum <= 99
        } else {
          n1 = _rand.nextInt(450) + 50; // 50..499
          n2 = _rand.nextInt(450) + 50; // Sum <= 999
        }
        answer = n1 + n2;
        break;

      // -------------------------------------------------------------
      // 2. SUBTRACTION (Enforce non-negative results: n1 >= n2)
      // -------------------------------------------------------------
      case MathOperation.subtraction:
        if (difficulty == DifficultyLevel.easy) {
          n1 = _rand.nextInt(8) + 2; // 2..9
          n2 = _rand.nextInt(n1) + 1; // 1..n1
        } else if (difficulty == DifficultyLevel.medium) {
          n1 = _rand.nextInt(70) + 20; // 20..89
          n2 = _rand.nextInt(n1 - 10) + 5;
        } else {
          n1 = _rand.nextInt(700) + 200; // 200..899
          n2 = _rand.nextInt(n1 - 50) + 50;
        }
        answer = n1 - n2;
        break;

      // -------------------------------------------------------------
      // 3. MULTIPLICATION
      // -------------------------------------------------------------
      case MathOperation.multiplication:
        if (difficulty == DifficultyLevel.easy) {
          n1 = _rand.nextInt(5) + 1; // 1..5
          n2 = _rand.nextInt(3) + 1; // 1..3
        } else if (difficulty == DifficultyLevel.medium) {
          n1 = _rand.nextInt(8) + 2; // 2..9
          n2 = _rand.nextInt(8) + 2; // 2..9
        } else {
          if (_rand.nextBool()) {
            n1 = _rand.nextInt(4) + 9; // 9..12
            n2 = _rand.nextInt(4) + 9; // 9..12
          } else {
            n1 = _rand.nextInt(15) + 11; // 11..25
            n2 = _rand.nextInt(6) + 2; // 2..7
          }
        }
        answer = n1 * n2;
        break;

      // -------------------------------------------------------------
      // 4. DIVISION (Inverse multiplication = zero remainders!)
      // -------------------------------------------------------------
      case MathOperation.division:
        if (difficulty == DifficultyLevel.easy) {
          answer = _rand.nextInt(4) + 1; // 1..4
          n2 = _rand.nextInt(2) + 2; // 2 or 3
        } else if (difficulty == DifficultyLevel.medium) {
          answer = _rand.nextInt(8) + 2; // 2..9
          n2 = _rand.nextInt(7) + 2; // 2..8
        } else {
          answer = _rand.nextInt(10) + 3; // 3..12
          n2 = _rand.nextInt(8) + 3; // 3..10
        }
        n1 = answer * n2; // Guarantees n1 % n2 == 0
        break;
    }

    final options = _generateSmartDistractors(answer);

    return MathProblem(
      num1: n1,
      num2: n2,
      operation: operation,
      correctAnswer: answer,
      options: options,
    );
  }

  List<int> _generateSmartDistractors(int answer) {
    final Set<int> optionSet = {answer};

    while (optionSet.length < 4) {
      final offset = _rand.nextInt(5) + 1;
      final distractor = _rand.nextBool() ? answer + offset : answer - offset;

      if (distractor > 0 && !optionSet.contains(distractor)) {
        optionSet.add(distractor);
      } else {
        optionSet.add(answer + optionSet.length + 3);
      }
    }

    final list = optionSet.toList();
    list.shuffle(_rand);
    return list;
  }
}
