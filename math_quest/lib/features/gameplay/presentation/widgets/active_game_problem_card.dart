import 'package:flutter/material.dart';

import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/base10_helper_widget.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';

class ActiveGameProblemCard extends StatelessWidget {
  final MathProblem problem;
  final bool showVisualAids;
  final bool isExamMode;

  const ActiveGameProblemCard({
    super.key,
    required this.problem,
    required this.showVisualAids,
    required this.isExamMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${problem.num1} ${problem.operation.symbol} ${problem.num2} = ?',
            style: AppTypography.displayProblem,
          ),
          if (showVisualAids && !isExamMode) ...[
            const SizedBox(height: 14),
            Base10HelperWidget(
              num1: problem.num1,
              num2: problem.num2,
              operationSymbol: problem.operation.symbol,
            ),
          ],
        ],
      ),
    );
  }
}
