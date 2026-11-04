import 'dart:math';

import 'package:flutter/material.dart';

import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';

import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_world.dart';

class GenerateAdventureWorldUseCase {
  final Random _rand = Random();

  // Biome Themes with unique procedural stage landmarks
  static const List<_BiomeTemplate> _biomes = [
    // 1. Sprout Island (Addition - Easy)
    _BiomeTemplate(
      prefixes: ['Emerald', 'Sunny', 'Whispering', 'Verdant', 'Golden'],
      suffixes: ['Atoll', 'Island', 'Shores', 'Meadow', 'Haven'],
      emoji: '🌱',
      primaryColor: Color(0xFF16A34A),
      bgTint: Color(0xFFF0FDF4),
      bossName: 'Stone Golem',
      bossEmoji: '🗿',
      stageLandmarks: [
        'Pebble Beach',
        'Bamboo Grove',
        'Clover Valley',
        'Waterfall Ridge',
        'Golem’s Fortress', // Boss
      ],
      operation: MathOperation.addition,
      difficulty: DifficultyLevel.easy,
    ),

    // 2. Candy Land (Subtraction - Easy/Med)
    _BiomeTemplate(
      prefixes: ['Sugarplum', 'Cotton Candy', 'Lollipop', 'Caramel', 'Sweet'],
      suffixes: ['Canyon', 'Isle', 'Reef', 'Lagoon', 'Kingdom'],
      emoji: '🍭',
      primaryColor: Color(0xFFE11D48),
      bgTint: Color(0xFFFFF1F2),
      bossName: 'Sugar Dragon',
      bossEmoji: '🐲',
      stageLandmarks: [
        'Gummy Shore',
        'Marshmallow Trail',
        'Chocolate River',
        'Lollipop Peak',
        'Dragon’s Candy Keep', // Boss
      ],
      operation: MathOperation.subtraction,
      difficulty: DifficultyLevel.easy,
    ),

    // 3. Dino Jungle (Multiplication - Medium)
    _BiomeTemplate(
      prefixes: ['Prehistoric', 'Thunder', 'Jurassic', 'Amber', 'Ancient'],
      suffixes: ['Jungle', 'Crag', 'Wilds', 'Canyon', 'Sanctuary'],
      emoji: '🦖',
      primaryColor: Color(0xFFD97706),
      bgTint: Color(0xFFFFFBEB),
      bossName: 'T-Rex Math King',
      bossEmoji: '👑',
      stageLandmarks: [
        'Fossil Beach',
        'Fern Canopy',
        'Raptor Ravine',
        'Volcano Foothills',
        'T-Rex Throne Room', // Boss
      ],
      operation: MathOperation.multiplication,
      difficulty: DifficultyLevel.medium,
    ),

    // 4. Cosmic Summit (Mixed - Medium)
    _BiomeTemplate(
      prefixes: ['Astral', 'Starfall', 'Starlight', 'Galactic', 'Cosmic'],
      suffixes: ['Summit', 'Archipelago', 'Peaks', 'Nebula', 'Spire'],
      emoji: '🌌',
      primaryColor: Color(0xFF7C3AED),
      bgTint: Color(0xFFF5F3FF),
      bossName: 'Star Titan',
      bossEmoji: '⭐',
      stageLandmarks: [
        'Stardust Basin',
        'Meteor Bridge',
        'Aurora Ridge',
        'Gravity Well',
        'Titan’s Observatory', // Boss
      ],
      operation: MathOperation.multiplication,
      difficulty: DifficultyLevel.medium,
    ),

    // 5. Coral Reef (Division - Medium/Hard)
    _BiomeTemplate(
      prefixes: ['Sunken', 'Azure', 'Tidal', 'Sapphire', 'Aquamarine'],
      suffixes: ['Reef', 'Cove', 'Cay', 'Abyss', 'Deep'],
      emoji: '🐠',
      primaryColor: Color(0xFF0284C7),
      bgTint: Color(0xFFF0F9FF),
      bossName: 'Kraken Lord',
      bossEmoji: '🐙',
      stageLandmarks: [
        'Clownfish Cove',
        'Shell Cavern',
        'Sunken Galleon',
        'Pearl Trench',
        'Kraken’s Sunken Lair', // Boss
      ],
      operation: MathOperation.division,
      difficulty: DifficultyLevel.medium,
    ),
  ];

  AdventureWorld execute({required int worldIndex}) {
    final biomeIndex = (worldIndex - 1) % _biomes.length;
    final template = _biomes[biomeIndex];

    // 🎲 Procedurally generate a unique island name
    final prefix = template.prefixes[_rand.nextInt(template.prefixes.length)];
    final suffix = template.suffixes[_rand.nextInt(template.suffixes.length)];
    final islandName = '$prefix $suffix';

    const levelsPerWorld = 5;
    final startLevelNum = (worldIndex - 1) * levelsPerWorld + 1;

    final theme = WorldTheme(
      name: islandName, // e.g. "Emerald Atoll", "Sugarplum Canyon"
      emoji: template.emoji,
      primaryColor: template.primaryColor,
      bgTint: template.bgTint,
      bossName: template.bossName,
      bossEmoji: template.bossEmoji,
      primaryOperation: template.operation,
      difficulty: template.difficulty,
    );

    final List<AdventureLevel> levels = [];

    for (int i = 0; i < levelsPerWorld; i++) {
      final levelNum = startLevelNum + i;
      final isBoss = (i == levelsPerWorld - 1);
      final landmarkName = template.stageLandmarks[i]; // 👈 Real landmark name!

      levels.add(
        AdventureLevel(
          levelNumber: levelNum,
          title: landmarkName, // 👈 "Pebble Beach", "Bamboo Grove", etc.
          worldName: islandName,
          status: (worldIndex == 1 && i == 0)
              ? LevelStatus.active
              : LevelStatus.locked,
          stars: 0,
          operation: template.operation,
          difficulty: isBoss && template.difficulty == DifficultyLevel.easy
              ? DifficultyLevel.medium
              : template.difficulty,
          isBoss: isBoss,
        ),
      );
    }

    return AdventureWorld(worldIndex: worldIndex, theme: theme, levels: levels);
  }
}

class _BiomeTemplate {
  final List<String> prefixes;
  final List<String> suffixes;
  final String emoji;
  final Color primaryColor;
  final Color bgTint;
  final String bossName;
  final String bossEmoji;
  final List<String> stageLandmarks;
  final MathOperation operation;
  final DifficultyLevel difficulty;

  const _BiomeTemplate({
    required this.prefixes,
    required this.suffixes,
    required this.emoji,
    required this.primaryColor,
    required this.bgTint,
    required this.bossName,
    required this.bossEmoji,
    required this.stageLandmarks,
    required this.operation,
    required this.difficulty,
  });
}
