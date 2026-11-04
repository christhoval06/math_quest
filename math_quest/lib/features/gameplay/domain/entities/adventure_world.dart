import 'package:flutter/material.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';

import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';

class WorldTheme {
  final String name;
  final String emoji;
  final Color primaryColor;
  final Color bgTint;
  final String bossName;
  final String bossEmoji;
  final MathOperation primaryOperation;
  final DifficultyLevel difficulty;

  const WorldTheme({
    required this.name,
    required this.emoji,
    required this.primaryColor,
    required this.bgTint,
    required this.bossName,
    required this.bossEmoji,
    required this.primaryOperation,
    required this.difficulty,
  });
}

class AdventureWorld {
  final int worldIndex; // 1, 2, 3...
  final WorldTheme theme;
  final List<AdventureLevel> levels;
  final bool isCompleted;

  const AdventureWorld({
    required this.worldIndex,
    required this.theme,
    required this.levels,
    this.isCompleted = false,
  });

  AdventureWorld copyWith({List<AdventureLevel>? levels, bool? isCompleted}) {
    return AdventureWorld(
      worldIndex: worldIndex,
      theme: theme,
      levels: levels ?? this.levels,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
