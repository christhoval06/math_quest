import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';

extension MathOperationUiExtension on MathOperationType {
  String get symbol {
    switch (this) {
      case MathOperationType.addition:
        return '+';
      case MathOperationType.subtraction:
        return '−';
      case MathOperationType.multiplication:
        return '×';
      case MathOperationType.division:
        return '÷';
    }
  }

  String get displayName => name.toUpperCase();

  Color get color {
    switch (this) {
      case MathOperationType.addition:
        return AppColors.opAddition;
      case MathOperationType.subtraction:
        return AppColors.opSubtraction;
      case MathOperationType.multiplication:
        return AppColors.opMultiplication;
      case MathOperationType.division:
        return AppColors.opDivision;
    }
  }
}
