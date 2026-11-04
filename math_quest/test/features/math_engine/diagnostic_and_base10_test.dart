import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/math_engine/domain/entities/base10_decomposition.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';
import 'package:math_quest/features/math_engine/domain/entities/answer_submission.dart';
import 'package:math_quest/features/math_engine/domain/usecases/calculate_exam_report_usecase.dart';

void main() {
  group('Base-10 Decomposition Tests', () {
    test('Correctly separates hundreds, tens, and ones', () {
      final b1 = Base10Decomposition.fromNumber(24);
      expect(b1.hundreds, equals(0));
      expect(b1.tens, equals(2));
      expect(b1.ones, equals(4));

      final b2 = Base10Decomposition.fromNumber(385);
      expect(b2.hundreds, equals(3));
      expect(b2.tens, equals(8));
      expect(b2.ones, equals(5));
    });
  });

  group('Exam Scoring & Star Calculation Tests', () {
    late CalculateExamReportUseCase reportUseCase;

    setUp(() {
      reportUseCase = CalculateExamReportUseCase();
    });

    MathProblem dummyProblem(int answer) => MathProblem(
      num1: 1,
      num2: 1,
      operation: MathOperation.addition,
      correctAnswer: answer,
      options: [answer, answer + 1, answer + 2, answer + 3],
    );

    test('9/10 correct (90%) awards 3 Gold Stars', () {
      final submissions = List.generate(
        10,
        (index) => AnswerSubmission(
          problem: dummyProblem(10),
          selectedAnswer: index == 0 ? 99 : 10, // 1 mistake, 9 correct
          timeTaken: const Duration(seconds: 4),
        ),
      );

      final report = reportUseCase.execute(submissions: submissions);

      expect(report.correctCount, equals(9));
      expect(report.accuracyPercentage, equals(90));
      expect(report.starsEarned, equals(3));
      expect(report.mistakes.length, equals(1));
    });

    test('7/10 correct (70%) awards 2 Silver Stars', () {
      final submissions = List.generate(
        10,
        (index) => AnswerSubmission(
          problem: dummyProblem(10),
          selectedAnswer: index < 3 ? 99 : 10, // 3 mistakes, 7 correct
          timeTaken: const Duration(seconds: 5),
        ),
      );

      final report = reportUseCase.execute(submissions: submissions);

      expect(report.accuracyPercentage, equals(70));
      expect(report.starsEarned, equals(2));
    });

    test('Under 50% correct awards 0 Stars', () {
      final submissions = List.generate(
        10,
        (index) => AnswerSubmission(
          problem: dummyProblem(10),
          selectedAnswer: index < 6 ? 99 : 10, // 6 mistakes, 4 correct (40%)
          timeTaken: const Duration(seconds: 5),
        ),
      );

      final report = reportUseCase.execute(submissions: submissions);

      expect(report.accuracyPercentage, equals(40));
      expect(report.starsEarned, equals(0));
    });
  });
}
