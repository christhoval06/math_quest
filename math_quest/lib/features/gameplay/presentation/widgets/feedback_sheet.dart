import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class FeedbackSheet extends StatelessWidget {
  final bool isCorrect;
  final int correctAnswer;
  final VoidCallback onContinue;

  const FeedbackSheet({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
    required this.onContinue,
  });

  static void show({
    required BuildContext context,
    required bool isCorrect,
    required int correctAnswer,
    required VoidCallback onContinue,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => FeedbackSheet(
        isCorrect: isCorrect,
        correctAnswer: correctAnswer,
        onContinue: onContinue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isCorrect ? AppColors.successBg : AppColors.errorBg;
    final primaryColor = isCorrect
        ? AppColors.successGreen
        : AppColors.errorRed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                  color: primaryColor,
                  size: 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isCorrect
                        ? AppLocalizations.of(context)!.correctTitle
                        : AppLocalizations.of(context)!.wrongTitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            if (!isCorrect) ...[
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!
                    .correctAnswerExplanation(correctAnswer.toString()),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: onContinue,
              child: Text(
                AppLocalizations.of(context)!.continueBtn,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
