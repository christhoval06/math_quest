import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';
import 'package:math_quest/features/gameplay/presentation/providers/adventure_provider.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';

enum AdventurePathPosition { center, right, left }

class AdventureWorldOptionViewData {
  final int worldIndex;
  final String title;
  final String emoji;
  final bool isSelected;

  const AdventureWorldOptionViewData({
    required this.worldIndex,
    required this.title,
    required this.emoji,
    required this.isSelected,
  });
}

class AdventureLevelViewData {
  final int levelNumber;
  final String title;
  final LevelStatus status;
  final int stars;
  final MathOperation operation;
  final DifficultyLevel difficulty;
  final bool isBoss;
  final AdventurePathPosition pathPosition;

  const AdventureLevelViewData({
    required this.levelNumber,
    required this.title,
    required this.status,
    required this.stars,
    required this.operation,
    required this.difficulty,
    required this.isBoss,
    required this.pathPosition,
  });
}

class AdventureCelebrationViewData {
  final String worldName;
  final String emoji;

  const AdventureCelebrationViewData({
    required this.worldName,
    required this.emoji,
  });
}

class AdventureIslandState {
  final int activeWorldIndex;
  final String currentWorldTitle;
  final String currentWorldEmoji;
  final Color primaryColor;
  final Color backgroundColor;
  final String bossName;
  final String bossEmoji;
  final List<AdventureWorldOptionViewData> worlds;
  final List<AdventureLevelViewData> levels;
  final AdventureCelebrationViewData? celebration;

  AdventureIslandState({
    required this.activeWorldIndex,
    required this.currentWorldTitle,
    required this.currentWorldEmoji,
    required this.primaryColor,
    required this.backgroundColor,
    required this.bossName,
    required this.bossEmoji,
    required List<AdventureWorldOptionViewData> worlds,
    required List<AdventureLevelViewData> levels,
    required this.celebration,
  }) : worlds = UnmodifiableListView(List.of(worlds)),
       levels = UnmodifiableListView(List.of(levels));

  factory AdventureIslandState.fromAdventure(AdventureState source) {
    final currentWorld = source.currentWorld;
    const positions = [
      AdventurePathPosition.center,
      AdventurePathPosition.right,
      AdventurePathPosition.center,
      AdventurePathPosition.left,
    ];

    return AdventureIslandState(
      activeWorldIndex: source.activeWorldIndex,
      currentWorldTitle: currentWorld.theme.name,
      currentWorldEmoji: currentWorld.theme.emoji,
      primaryColor: currentWorld.theme.primaryColor,
      backgroundColor: currentWorld.theme.bgTint,
      bossName: currentWorld.theme.bossName,
      bossEmoji: currentWorld.theme.bossEmoji,
      worlds: source.worlds
          .map(
            (world) => AdventureWorldOptionViewData(
              worldIndex: world.worldIndex,
              title: world.theme.name,
              emoji: world.theme.emoji,
              isSelected: world.worldIndex == source.activeWorldIndex,
            ),
          )
          .toList(growable: false),
      levels: [
        for (var index = 0; index < currentWorld.levels.length; index++)
          AdventureLevelViewData(
            levelNumber: currentWorld.levels[index].levelNumber,
            title: currentWorld.levels[index].title,
            status: currentWorld.levels[index].status,
            stars: currentWorld.levels[index].stars,
            operation: currentWorld.levels[index].operation,
            difficulty: currentWorld.levels[index].difficulty,
            isBoss: currentWorld.levels[index].isBoss,
            pathPosition: positions[index % positions.length],
          ),
      ],
      celebration: source.justUnlockedNewWorld
          ? AdventureCelebrationViewData(
              worldName: currentWorld.theme.name,
              emoji: currentWorld.theme.emoji,
            )
          : null,
    );
  }
}
