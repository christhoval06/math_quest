import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';

class MissionOperationGrid extends StatelessWidget {
  final Set<MathOperation> selectedOperations;
  final ValueChanged<MathOperation> onToggle;

  const MissionOperationGrid({
    super.key,
    required this.selectedOperations,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          number: '1',
          title: AppLocalizations.of(context)!.chooseOperation,
          subtitle: AppLocalizations.of(context)!.selectOperation,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _card(
              MathOperation.addition,
              AppLocalizations.of(context)!.operationAddition,
              AppLocalizations.of(context)!.appleCounters,
              AppColors.opAddition,
            ),
            const SizedBox(width: 12),
            _card(
              MathOperation.subtraction,
              AppLocalizations.of(context)!.operationSubtraction,
              AppLocalizations.of(context)!.balloonPops,
              AppColors.opSubtraction,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _card(
              MathOperation.multiplication,
              AppLocalizations.of(context)!.operationMultiplication,
              AppLocalizations.of(context)!.boosters,
              AppColors.opMultiplication,
            ),
            const SizedBox(width: 12),
            _card(
              MathOperation.division,
              AppLocalizations.of(context)!.operationDivision,
              AppLocalizations.of(context)!.pizzaSlices,
              AppColors.opDivision,
            ),
          ],
        ),
      ],
    );
  }

  Widget _card(
    MathOperation operation,
    String label,
    String sublabel,
    Color color,
  ) {
    final selected = selectedOperations.contains(operation);
    return Expanded(
      child: InkWell(
        onTap: () => onToggle(operation),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : AppColors.borderLight,
              width: selected ? 2.5 : 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      operation.symbol,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: color,
                      ),
                    ),
                  ),
                  if (selected)
                    Icon(Icons.check_circle_rounded, color: color, size: 20),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                sublabel,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String number;
  final String title;
  final String? subtitle;

  const _SectionHeader({
    required this.number,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 11,
          backgroundColor: AppColors.secondaryOrange,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(width: 8),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}
