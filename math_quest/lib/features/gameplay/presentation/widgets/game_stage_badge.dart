import 'package:flutter/material.dart';

import 'package:math_quest/core/theme/app_theme.dart';

class GameStageBadge extends StatelessWidget {
  final String label;
  final bool isExamMode;
  final Color primaryColor;

  const GameStageBadge({
    super.key,
    required this.label,
    required this.isExamMode,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isExamMode ? AppColors.secondaryOrange : primaryColor;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: foreground.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: foreground,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
