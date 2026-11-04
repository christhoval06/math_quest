import 'package:math_quest/features/math_engine/domain/entities/answer_submission.dart';
import 'package:math_quest/features/math_engine/domain/entities/exam_report.dart';

class CalculateExamReportUseCase {
  ExamReport execute({required List<AnswerSubmission> submissions}) {
    final correctCount = submissions.where((s) => s.isCorrect).length;
    final totalDuration = submissions.fold<Duration>(
      Duration.zero,
      (prev, s) => prev + s.timeTaken,
    );

    return ExamReport(
      correctCount: correctCount,
      totalQuestions: submissions.length,
      totalDuration: totalDuration,
      answers: submissions,
    );
  }
}
