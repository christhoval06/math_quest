import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';
import 'package:math_quest/features/gameplay/presentation/models/adventure_island_state.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';

class PreparedAdventureSession {
  final int levelNumber;
  final String title;
  final MathOperation operation;
  final DifficultyLevel difficulty;

  const PreparedAdventureSession({
    required this.levelNumber,
    required this.title,
    required this.operation,
    required this.difficulty,
  });
}

class AdventureIslandController {
  final AdventureIslandState Function() readState;
  final void Function(int worldIndex) switchWorldAction;
  final void Function() clearNotificationAction;
  final void Function({
    required MathOperation operation,
    required DifficultyLevel difficulty,
  })
  resetPracticeSessionAction;

  int? _acknowledgedWorldIndex;
  final Set<int> _scheduledCelebrationWorlds = {};
  final Set<int> _presentedCelebrationWorlds = {};

  AdventureIslandController({
    required this.readState,
    required this.switchWorldAction,
    required this.clearNotificationAction,
    required this.resetPracticeSessionAction,
  });

  void switchWorld(int worldIndex) {
    final available = readState().worlds.any(
      (world) => world.worldIndex == worldIndex,
    );
    if (!available) {
      throw ArgumentError.value(worldIndex, 'worldIndex', 'Unavailable world');
    }
    switchWorldAction(worldIndex);
  }

  PreparedAdventureSession prepareLevel(AdventureLevelViewData level) {
    if (level.status == LevelStatus.locked) {
      throw StateError('Locked levels cannot start a session');
    }
    resetPracticeSessionAction(
      operation: level.operation,
      difficulty: level.difficulty,
    );
    return PreparedAdventureSession(
      levelNumber: level.levelNumber,
      title: level.title,
      operation: level.operation,
      difficulty: level.difficulty,
    );
  }

  void acknowledgeCelebration() {
    final state = readState();
    if (state.celebration == null ||
        _acknowledgedWorldIndex == state.activeWorldIndex) {
      return;
    }
    _acknowledgedWorldIndex = state.activeWorldIndex;
    clearNotificationAction();
  }

  bool claimCelebration(AdventureIslandState state) {
    if (state.celebration == null) return false;
    final worldIndex = state.activeWorldIndex;
    if (_presentedCelebrationWorlds.contains(worldIndex)) return false;
    return _scheduledCelebrationWorlds.add(worldIndex);
  }

  void markCelebrationPresented(int worldIndex) {
    _scheduledCelebrationWorlds.remove(worldIndex);
    _presentedCelebrationWorlds.add(worldIndex);
  }

  void releaseCelebration(int worldIndex) {
    _scheduledCelebrationWorlds.remove(worldIndex);
    _presentedCelebrationWorlds.remove(worldIndex);
  }
}
