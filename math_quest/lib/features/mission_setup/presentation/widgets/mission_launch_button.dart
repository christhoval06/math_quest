import 'package:flutter/material.dart';

import 'package:math_quest/core/theme/app_theme.dart';

class MissionLaunchButton extends StatelessWidget {
  final bool isExamMode;
  final String label;
  final VoidCallback? onPressed;

  const MissionLaunchButton({
    super.key,
    required this.isExamMode,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isExamMode
            ? AppColors.secondaryOrange
            : AppColors.primaryBlue,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isExamMode ? Icons.assignment_rounded : Icons.rocket_launch_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
