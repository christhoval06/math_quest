import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/base10_helper_widget.dart';
import 'package:math_quest/features/math_engine/domain/entities/answer_submission.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class QuestionReviewItem extends StatefulWidget {
  final AnswerSubmission submission;

  const QuestionReviewItem({super.key, required this.submission});

  @override
  State<QuestionReviewItem> createState() => _QuestionReviewItemState();
}

class _QuestionReviewItemState extends State<QuestionReviewItem> {
  late bool _isCorrect;
  int? _correctedAnswer;

  @override
  void initState() {
    super.initState();
    _isCorrect = widget.submission.isCorrect;
  }

  // 🎯 Pops up a quick retry dialog with Base-10 counting aids!
  void _openRetryDialog(BuildContext context) {
    final problem = widget.submission.problem;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Row(
              children: [
                Text('🔄', style: TextStyle(fontSize: 22)),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.tryAgainTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${problem.num1} ${problem.operation.symbol} ${problem.num2} = ?',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                // Counting Helper
                Base10HelperWidget(
                  num1: problem.num1,
                  num2: problem.num2,
                  operationSymbol: problem.operation.symbol,
                ),
                const SizedBox(height: 16),
                // 4 Choices
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: problem.options.map((option) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(
                          color: AppColors.borderLight,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        if (option == problem.correctAnswer) {
                          // Corrected!
                          setState(() {
                            _isCorrect = true;
                            _correctedAnswer = option;
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.mistakeCorrected,
                              ),
                              backgroundColor: AppColors.successGreen,
                            ),
                          );
                        } else {
                          // Wrong guess in retry
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.useCountingBlocks,
                              ),
                              backgroundColor: AppColors.errorRed,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      child: Text(
                        '$option',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  AppLocalizations.of(context)!.close,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.submission.problem;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isCorrect ? const Color(0xFFBBF7D0) : const Color(0xFFFECDD3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: _isCorrect ? AppColors.successGreen : AppColors.errorRed,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                '${problem.num1} ${problem.operation.symbol} ${problem.num2} = ${problem.correctAnswer}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                AppLocalizations.of(context)!.elapsedSeconds(
                  widget.submission.timeTaken.inMilliseconds / 1000,
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          if (!_isCorrect) ...[
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  AppLocalizations.of(context)!.chosenAnswer(
                    widget.submission.selectedAnswer?.toString() ??
                        AppLocalizations.of(context)!.noAnswer,
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.errorRed,
                  ),
                ),
                // 👈 INTERACTIVE RETRY PILL!
                InkWell(
                  onTap: () => _openRetryDialog(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.retry,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context)!.countingHint,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
          ] else if (_correctedAnswer != null) ...[
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context)!.correctedSuccessfully,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.successGreen,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
