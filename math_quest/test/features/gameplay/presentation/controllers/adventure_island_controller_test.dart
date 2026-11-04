import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';
import 'package:math_quest/features/gameplay/presentation/controllers/adventure_island_controller.dart';
import 'package:math_quest/features/gameplay/presentation/models/adventure_island_state.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';

void main() {
  late AdventureIslandState currentState;
  late List<int> switchedWorlds;
  late List<(MathOperation, DifficultyLevel)> resets;
  late int clearCount;
  late AdventureIslandController controller;

  setUp(() {
    currentState = _state();
    switchedWorlds = [];
    resets = [];
    clearCount = 0;
    controller = AdventureIslandController(
      readState: () => currentState,
      switchWorldAction: switchedWorlds.add,
      clearNotificationAction: () => clearCount++,
      resetPracticeSessionAction: ({required operation, required difficulty}) {
        resets.add((operation, difficulty));
      },
    );
  });

  test('valid world switching delegates once', () {
    controller.switchWorld(2);

    expect(switchedWorlds, [2]);
  });

  test('unavailable world is rejected before delegation', () {
    expect(() => controller.switchWorld(3), throwsArgumentError);
    expect(switchedWorlds, isEmpty);
  });

  test('locked level is rejected without resetting the session', () {
    expect(
      () => controller.prepareLevel(currentState.levels[1]),
      throwsStateError,
    );
    expect(resets, isEmpty);
  });

  test('practice session resets before a prepared session is returned', () {
    final events = <String>[];
    controller = AdventureIslandController(
      readState: () => currentState,
      switchWorldAction: (_) {},
      clearNotificationAction: () {},
      resetPracticeSessionAction: ({required operation, required difficulty}) {
        events.add('reset');
      },
    );

    final session = controller.prepareLevel(currentState.levels.first);
    events.add('returned');

    expect(events, ['reset', 'returned']);
    expect(session.levelNumber, 6);
    expect(session.title, 'Coral Gate');
    expect(session.operation, MathOperation.multiplication);
    expect(session.difficulty, DifficultyLevel.medium);
  });

  test('celebration acknowledgement is coalesced', () {
    controller.acknowledgeCelebration();
    controller.acknowledgeCelebration();

    expect(clearCount, 1);

    currentState = _state(
      activeWorldIndex: 3,
      celebration: const AdventureCelebrationViewData(
        worldName: 'A Different World',
        emoji: '🌌',
      ),
    );
    controller.acknowledgeCelebration();

    expect(clearCount, 2);
  });
}

AdventureIslandState _state({
  int activeWorldIndex = 2,
  AdventureCelebrationViewData? celebration =
      const AdventureCelebrationViewData(
        worldName: 'Factor Forest',
        emoji: '🌴',
      ),
}) {
  return AdventureIslandState(
    activeWorldIndex: activeWorldIndex,
    currentWorldTitle: 'Factor Forest',
    currentWorldEmoji: '🌴',
    primaryColor: Colors.green,
    backgroundColor: Colors.greenAccent,
    bossName: 'Number Beast',
    bossEmoji: '🐲',
    worlds: const [
      AdventureWorldOptionViewData(
        worldIndex: 1,
        title: 'Starter Shores',
        emoji: '🌱',
        isSelected: false,
      ),
      AdventureWorldOptionViewData(
        worldIndex: 2,
        title: 'Factor Forest',
        emoji: '🌴',
        isSelected: true,
      ),
    ],
    levels: const [
      AdventureLevelViewData(
        levelNumber: 6,
        title: 'Coral Gate',
        status: LevelStatus.active,
        stars: 0,
        operation: MathOperation.multiplication,
        difficulty: DifficultyLevel.medium,
        isBoss: false,
        pathPosition: AdventurePathPosition.center,
      ),
      AdventureLevelViewData(
        levelNumber: 7,
        title: 'Locked Lagoon',
        status: LevelStatus.locked,
        stars: 0,
        operation: MathOperation.multiplication,
        difficulty: DifficultyLevel.medium,
        isBoss: false,
        pathPosition: AdventurePathPosition.right,
      ),
    ],
    celebration: celebration,
  );
}
