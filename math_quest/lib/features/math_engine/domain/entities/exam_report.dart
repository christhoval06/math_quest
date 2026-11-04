import 'package:math_quest/features/math_engine/domain/entities/answer_submission.dart';

class ExamReport {
  final int correctCount;
  final int totalQuestions;
  final Duration totalDuration;
  final List<AnswerSubmission> answers;

  const ExamReport({
    required this.correctCount,
    required this.totalQuestions,
    required this.totalDuration,
    required this.answers,
  });

  int get accuracyPercentage =>
      totalQuestions == 0 ? 0 : ((correctCount / totalQuestions) * 100).round();

  double get averageSecondsPerQuestion => totalQuestions == 0
      ? 0.0
      : (totalDuration.inMilliseconds / totalQuestions) / 1000.0;

  int get starsEarned {
    if (accuracyPercentage >= 90) return 3; // 90% - 100%
    if (accuracyPercentage >= 70) return 2; // 70% - 89%
    if (accuracyPercentage >= 50) return 1; // 50% - 69%
    return 0; // Below 50%
  }

  List<AnswerSubmission> get mistakes =>
      answers.where((submission) => !submission.isCorrect).toList();
}
