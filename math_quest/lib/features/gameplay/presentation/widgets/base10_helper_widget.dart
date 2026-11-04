import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/math_engine/domain/entities/base10_decomposition.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class Base10HelperWidget extends StatelessWidget {
  final int num1;
  final int num2;
  final String operationSymbol;

  const Base10HelperWidget({
    super.key,
    required this.num1,
    required this.num2,
    required this.operationSymbol,
  });

  @override
  Widget build(BuildContext context) {
    // Only show visual blocks for numbers up to 99 to keep cards readable
    if (num1 > 99 || num2 > 99) return const SizedBox.shrink();

    final b1 = Base10Decomposition.fromNumber(num1);
    final b2 = Base10Decomposition.fromNumber(num2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                AppLocalizations.of(context)!.countingHelpers,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.tensAndOnes,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDarkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildNumberDecomposition(
                  context,
                  b1,
                  AppColors.primaryBlue,
                ),
              ),
              Text(
                operationSymbol,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textMuted,
                ),
              ),
              Expanded(
                child: _buildNumberDecomposition(
                  context,
                  b2,
                  AppColors.secondaryOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberDecomposition(
    BuildContext context,
    Base10Decomposition b,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!
              .numberDecomposition(b.value, b.tens, b.ones),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 4,
          children: [
            // Tens rods
            for (int i = 0; i < b.tens; i++)
              Container(
                width: 6,
                height: 24,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            if (b.tens > 0 && b.ones > 0) const SizedBox(width: 6),
            // Ones dots
            Wrap(
              spacing: 2,
              runSpacing: 2,
              children: [
                for (int i = 0; i < b.ones; i++)
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
