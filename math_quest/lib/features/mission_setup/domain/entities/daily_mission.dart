import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';

class DailyMission {
  final String id;
  final String title;
  final MathOperation targetOperation;
  final DifficultyLevel difficulty;
  final int targetCount;
  final int coinReward;
  final String badgeRewardTitle;
  final String badgeRewardId;

  const DailyMission({
    required this.id,
    required this.title,
    required this.targetOperation,
    required this.difficulty,
    this.targetCount = 10,
    required this.coinReward,
    required this.badgeRewardTitle,
    required this.badgeRewardId,
  });

  /// Catalog of rotating missions
  static List<DailyMission> get catalog => const [
    DailyMission(
      id: 'mission_addition',
      title: 'Solve 10 Addition Puzzles',
      targetOperation: MathOperation.addition,
      difficulty: DifficultyLevel.easy,
      coinReward: 50,
      badgeRewardTitle: 'Space Detective Badge',
      badgeRewardId: 'space_detective',
    ),
    DailyMission(
      id: 'mission_subtraction',
      title: 'Solve 10 Subtraction Puzzles',
      targetOperation: MathOperation.subtraction,
      difficulty: DifficultyLevel.easy,
      coinReward: 50,
      badgeRewardTitle: 'Balloon Popper Badge',
      badgeRewardId: 'balloon_popper',
    ),
    DailyMission(
      id: 'mission_multiplication',
      title: 'Solve 10 Multiplication Puzzles',
      targetOperation: MathOperation.multiplication,
      difficulty: DifficultyLevel.medium,
      coinReward: 60,
      badgeRewardTitle: 'Lightning Booster Badge',
      badgeRewardId: 'lightning_math',
    ),
    DailyMission(
      id: 'mission_division',
      title: 'Solve 10 Division Puzzles',
      targetOperation: MathOperation.division,
      difficulty: DifficultyLevel.medium,
      coinReward: 75,
      badgeRewardTitle: 'Pizza Master Badge',
      badgeRewardId: 'times_master',
    ),
  ];
}
