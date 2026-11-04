import 'package:flutter/material.dart';

import 'package:math_quest/core/theme/app_theme.dart';

class ActiveGameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final double progressFraction;
  final int answeredCount;
  final int totalQuestions;
  final bool isTimerVisible;
  final String formattedTime;
  final bool isTimerDanger;
  final int currentStreak;
  final Color primaryColor;
  final VoidCallback onBack;

  const ActiveGameAppBar({
    super.key,
    required this.backgroundColor,
    required this.progressFraction,
    required this.answeredCount,
    required this.totalQuestions,
    required this.isTimerVisible,
    required this.formattedTime,
    required this.isTimerDanger,
    required this.currentStreak,
    required this.primaryColor,
    required this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textPrimary,
          size: 20,
        ),
        onPressed: onBack,
      ),
      title: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progressFraction,
                minHeight: 12,
                backgroundColor: AppColors.borderLight,
                valueColor: AlwaysStoppedAnimation(primaryColor),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$answeredCount/$totalQuestions',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 8),
          if (isTimerVisible) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isTimerDanger
                    ? const Color(0xFFFEE2E2)
                    : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isTimerDanger
                      ? AppColors.errorRed
                      : const Color(0xFFBFDBFE),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 14,
                    color: isTimerDanger
                        ? AppColors.errorRed
                        : AppColors.primaryDarkBlue,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      color: isTimerDanger
                          ? AppColors.errorRed
                          : AppColors.primaryDarkBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.secondaryOrange,
                  size: 15,
                ),
                const SizedBox(width: 2),
                Text(
                  '$currentStreak',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
