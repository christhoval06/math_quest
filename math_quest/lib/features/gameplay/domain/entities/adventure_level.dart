import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';

enum LevelStatus { locked, active, completed }

class AdventureLevel {
  final int levelNumber;
  final String title;
  final String worldName;
  final LevelStatus status;
  final int stars; // 0 to 3
  final MathOperation operation;
  final DifficultyLevel difficulty;
  final bool isBoss;

  const AdventureLevel({
    required this.levelNumber,
    required this.title,
    required this.worldName,
    required this.status,
    this.stars = 0,
    required this.operation,
    required this.difficulty,
    this.isBoss = false,
  });
}
