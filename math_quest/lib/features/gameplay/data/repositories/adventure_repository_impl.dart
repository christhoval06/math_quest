import 'dart:async';

import 'package:math_quest/features/gameplay/data/sources/adventure_progress_store.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_progress.dart';
import 'package:math_quest/features/gameplay/domain/repositories/i_adventure_repository.dart';

class AdventureProgressPersistenceException implements Exception {
  final Object cause;
  final List<Object> rollbackErrors;

  AdventureProgressPersistenceException({
    required this.cause,
    required List<Object> rollbackErrors,
  }) : rollbackErrors = List<Object>.unmodifiable(rollbackErrors);

  @override
  String toString() =>
      'Adventure progress save failed: $cause; rollback failures: '
      '${rollbackErrors.join(', ')}';
}

class AdventureRepositoryImpl implements IAdventureRepository {
  static const highestWorldIndexKey = 'highest_world_index';
  static const completedLevelStarsKey = 'completed_levels_stars';

  final AdventureProgressStore _store;

  AdventureRepositoryImpl(this._store);

  @override
  AdventureProgress loadProgress() {
    final rawWorldIndex = _store.read(highestWorldIndexKey);
    final rawStars = _store.read(completedLevelStarsKey);

    return AdventureProgress(
      highestWorldIndex: rawWorldIndex is int && rawWorldIndex >= 1
          ? rawWorldIndex
          : 1,
      completedLevelStars: _decodeStars(rawStars),
    );
  }

  Map<int, int> _decodeStars(Object? rawStars) {
    if (rawStars is! Map) return const {};

    final stars = <int, int>{};
    for (final entry in rawStars.entries) {
      final levelNumber = entry.key is int
          ? entry.key as int
          : int.tryParse(entry.key.toString());
      final starCount = entry.value;
      if (levelNumber != null &&
          levelNumber > 0 &&
          starCount is int &&
          starCount >= 1 &&
          starCount <= 3) {
        stars[levelNumber] = starCount;
      }
    }
    return stars;
  }

  @override
  Future<void> saveProgress(AdventureProgress progress) async {
    final previousWorldIndex = _store.read(highestWorldIndexKey);
    final previousStars = _copyStoredValue(_store.read(completedLevelStarsKey));

    try {
      await _store.write(highestWorldIndexKey, progress.highestWorldIndex);
      await _store.write(completedLevelStarsKey, {
        for (final entry in progress.completedLevelStars.entries)
          entry.key.toString(): entry.value,
      });
    } catch (error, stackTrace) {
      final rollbackErrors = <Object>[];
      try {
        await _restore(highestWorldIndexKey, previousWorldIndex);
      } catch (rollbackError) {
        rollbackErrors.add(rollbackError);
      }
      try {
        await _restore(completedLevelStarsKey, previousStars);
      } catch (rollbackError) {
        rollbackErrors.add(rollbackError);
      }
      if (rollbackErrors.isNotEmpty) {
        Error.throwWithStackTrace(
          AdventureProgressPersistenceException(
            cause: error,
            rollbackErrors: rollbackErrors,
          ),
          stackTrace,
        );
      }
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Object? _copyStoredValue(Object? value) {
    return value is Map ? Map<Object?, Object?>.from(value) : value;
  }

  Future<void> _restore(String key, Object? value) {
    return value == null ? _store.delete(key) : _store.write(key, value);
  }

  @override
  Future<void> resetProgress() => saveProgress(AdventureProgress.empty());
}
