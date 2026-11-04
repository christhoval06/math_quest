import 'package:flutter/material.dart';

import 'package:math_quest/core/theme/app_theme.dart';

class OptionCard extends StatelessWidget {
  final String label; // A, B, C, D
  final int value;
  final bool isSelected;
  final bool isEvaluated;
  final bool isCorrectAnswer;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.label,
    required this.value,
    required this.isSelected,
    this.isEvaluated = false,
    this.isCorrectAnswer = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 Compute dynamic colors based on validation
    Color bgColor = Colors.white;
    Color borderColor = AppColors.borderLight;
    Color textColor = AppColors.textPrimary;
    Widget? trailingIcon;

    if (isEvaluated) {
      if (isCorrectAnswer) {
        // Correct answer glows green!
        bgColor = const Color(0xFFDCFCE7);
        borderColor = AppColors.successGreen;
        textColor = const Color(0xFF15803D);
        trailingIcon = const Icon(
          Icons.check_circle_rounded,
          color: AppColors.successGreen,
          size: 20,
        );
      } else if (isSelected && !isCorrectAnswer) {
        // Wrong selected choice turns red
        bgColor = const Color(0xFFFEE2E2);
        borderColor = AppColors.errorRed;
        textColor = const Color(0xFFB91C1C);
        trailingIcon = const Icon(
          Icons.cancel_rounded,
          color: AppColors.errorRed,
          size: 20,
        );
      }
    } else if (isSelected) {
      // Selected state before checking
      bgColor = const Color(0xFFE1F5FE);
      borderColor = AppColors.primaryBlue;
      textColor = AppColors.primaryDarkBlue;
    }

    return InkWell(
      onTap: isEvaluated ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: (isSelected || (isEvaluated && isCorrectAnswer)) ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Letter tag (A, B, C, D)
            Positioned(
              top: 10,
              left: 14,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
            ),
            // Trailing Check/Cross icon
            if (trailingIcon != null)
              Positioned(top: 10, right: 14, child: trailingIcon),
            // The Number Value
            Center(
              child: Text(
                '$value',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
