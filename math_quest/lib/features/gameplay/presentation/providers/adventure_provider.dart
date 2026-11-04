import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/features/gameplay/data/providers/adventure_repository_provider.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_progress.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_world.dart';
import 'package:math_quest/features/gameplay/domain/repositories/i_adventure_repository.dart';
import 'package:math_quest/features/gameplay/domain/usecases/generate_adventure_world_usecase.dart';

class AdventureState {
  final List<AdventureWorld> worlds;
  final int activeWorldIndex;
  final bool justUnlockedNewWorld;

  const AdventureState({
    required this.worlds,
    required this.activeWorldIndex,
    this.justUnlockedNewWorld = false,
  });

  AdventureWorld get currentWorld => worlds.firstWhere(
    (world) => world.worldIndex == activeWorldIndex,
    orElse: () => worlds.first,
  );

  AdventureState copyWith({
    List<AdventureWorld>? worlds,
    int? activeWorldIndex,
    bool? justUnlockedNewWorld,
  }) {
    return AdventureState(
      worlds: worlds ?? this.worlds,
      activeWorldIndex: activeWorldIndex ?? this.activeWorldIndex,
      justUnlockedNewWorld: justUnlockedNewWorld ?? this.justUnlockedNewWorld,
    );
  }
}

class AdventureNotifier extends StateNotifier<AdventureState> {
  final GenerateAdventureWorldUseCase _generator;
  final IAdventureRepository _repository;
  Future<void> _mutationTail = Future<void>.value();

  AdventureNotifier(this._generator, this._repository)
    : super(
        _restoreState(
          generator: _generator,
          progress: _repository.loadProgress(),
        ),
      );

  static AdventureState _restoreState({
    required GenerateAdventureWorldUseCase generator,
    required AdventureProgress progress,
  }) {
    final worlds = <AdventureWorld>[];
    for (
      var worldIndex = 1;
      worldIndex <= progress.highestWorldIndex;
      worldIndex++
    ) {
      final generated = generator.execute(worldIndex: worldIndex);
      final levels = generated.levels
          .map((level) {
            final savedStars = progress.completedLevelStars[level.levelNumber];
            final previousCompleted = progress.completedLevelStars.containsKey(
              level.levelNumber - 1,
            );
            final status = savedStars != null
                ? LevelStatus.completed
                : level.levelNumber == 1 || previousCompleted
                ? LevelStatus.active
                : LevelStatus.locked;
            return _copyLevel(level, status: status, stars: savedStars ?? 0);
          })
          .toList(growable: false);
      worlds.add(
        generated.copyWith(
          levels: levels,
          isCompleted:
              levels.isNotEmpty && levels.last.status == LevelStatus.completed,
        ),
      );
    }

    return AdventureState(
      worlds: worlds,
      activeWorldIndex: progress.highestWorldIndex,
    );
  }

  static AdventureLevel _copyLevel(
    AdventureLevel level, {
    required LevelStatus status,
    required int stars,
  }) {
    return AdventureLevel(
      levelNumber: level.levelNumber,
      title: level.title,
      worldName: level.worldName,
      status: status,
      stars: stars,
      operation: level.operation,
      difficulty: level.difficulty,
      isBoss: level.isBoss,
    );
  }

  void switchWorld(int worldIndex) {
    final isAvailable = state.worlds.any(
      (world) => world.worldIndex == worldIndex,
    );
    if (!isAvailable) {
      throw ArgumentError.value(worldIndex, 'worldIndex', 'Unavailable world');
    }
    state = state.copyWith(
      activeWorldIndex: worldIndex,
      justUnlockedNewWorld: false,
    );
  }

  void clearNewWorldNotification() {
    if (!state.justUnlockedNewWorld) return;
    state = state.copyWith(justUnlockedNewWorld: false);
  }

  Future<void> completeLevel(int levelNumber, int stars) {
    return _serialize(() async {
      final candidate = _completedState(levelNumber, stars);
      await _repository.saveProgress(_progressFrom(candidate));
      state = candidate;
    });
  }

  AdventureState _completedState(int levelNumber, int stars) {
    if (stars < 1 || stars > 3) {
      throw RangeError.range(stars, 1, 3, 'stars');
    }

    AdventureLevel? requestedLevel;
    for (final world in state.worlds) {
      for (final level in world.levels) {
        if (level.levelNumber == levelNumber) {
          requestedLevel = level;
          break;
        }
      }
      if (requestedLevel != null) break;
    }
    if (requestedLevel == null) {
      throw ArgumentError.value(levelNumber, 'levelNumber', 'Unknown level');
    }
    if (requestedLevel.status == LevelStatus.locked) {
      throw StateError('Locked levels cannot be completed');
    }

    final isFirstCompletion = requestedLevel.status != LevelStatus.completed;
    var bossDefeated = false;
    var levelFound = false;
    final updatedWorlds = state.worlds
        .map((world) {
          final targetIndex = world.levels.indexWhere(
            (level) => level.levelNumber == levelNumber,
          );
          if (targetIndex < 0) return world;

          levelFound = true;
          final target = world.levels[targetIndex];
          bossDefeated = target.isBoss && isFirstCompletion;
          final levels = List<AdventureLevel>.from(world.levels);
          levels[targetIndex] = _copyLevel(
            target,
            status: LevelStatus.completed,
            stars: stars,
          );
          if (!target.isBoss &&
              isFirstCompletion &&
              targetIndex + 1 < levels.length) {
            final next = levels[targetIndex + 1];
            if (next.status == LevelStatus.locked) {
              levels[targetIndex + 1] = _copyLevel(
                next,
                status: LevelStatus.active,
                stars: next.stars,
              );
            }
          }
          return world.copyWith(
            levels: levels,
            isCompleted: world.isCompleted || target.isBoss,
          );
        })
        .toList(growable: false);

    if (!levelFound || !bossDefeated) {
      return state.copyWith(worlds: updatedWorlds);
    }

    final nextWorldIndex =
        updatedWorlds
            .map((world) => world.worldIndex)
            .reduce((left, right) => left > right ? left : right) +
        1;
    final generated = _generator.execute(worldIndex: nextWorldIndex);
    final levels = List<AdventureLevel>.from(generated.levels);
    if (levels.isNotEmpty) {
      levels[0] = _copyLevel(levels[0], status: LevelStatus.active, stars: 0);
    }
    return AdventureState(
      worlds: [
        ...updatedWorlds,
        generated.copyWith(levels: levels),
      ],
      activeWorldIndex: nextWorldIndex,
      justUnlockedNewWorld: true,
    );
  }

  AdventureProgress _progressFrom(AdventureState candidate) {
    final completedStars = <int, int>{};
    for (final world in candidate.worlds) {
      for (final level in world.levels) {
        if (level.status == LevelStatus.completed) {
          completedStars[level.levelNumber] = level.stars;
        }
      }
    }
    return AdventureProgress(
      highestWorldIndex: candidate.worlds.length,
      completedLevelStars: completedStars,
    );
  }

  Future<void> resetAdventureProgress() {
    return _serialize(() async {
      await _repository.resetProgress();
      state = AdventureState(
        worlds: [_generator.execute(worldIndex: 1)],
        activeWorldIndex: 1,
      );
    });
  }

  Future<void> _serialize(Future<void> Function() mutation) {
    final result = _mutationTail.then((_) => mutation());
    _mutationTail = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return result;
  }
}

final adventureProvider =
    StateNotifierProvider<AdventureNotifier, AdventureState>((ref) {
      return AdventureNotifier(
        GenerateAdventureWorldUseCase(),
        ref.watch(adventureRepositoryProvider),
      );
    });
