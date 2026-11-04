import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/gameplay/data/repositories/adventure_repository_impl.dart';
import 'package:math_quest/features/gameplay/data/sources/adventure_progress_store.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_progress.dart';

void main() {
  group('AdventureRepositoryImpl', () {
    test('empty store returns world one with no stars', () {
      final repository = AdventureRepositoryImpl(_MemoryAdventureStore());

      final progress = repository.loadProgress();

      expect(progress.highestWorldIndex, 1);
      expect(progress.completedLevelStars, isEmpty);
    });

    test('valid progress round trips through legacy keys', () async {
      final store = _MemoryAdventureStore();
      final repository = AdventureRepositoryImpl(store);

      await repository.saveProgress(
        AdventureProgress(
          highestWorldIndex: 3,
          completedLevelStars: {1: 3, 2: 2, 7: 1},
        ),
      );

      expect(store.values['highest_world_index'], 3);
      expect(store.values['completed_levels_stars'], {'1': 3, '2': 2, '7': 1});
      expect(repository.loadProgress().highestWorldIndex, 3);
      expect(repository.loadProgress().completedLevelStars, {1: 3, 2: 2, 7: 1});
    });

    test('progress snapshots cannot be mutated', () {
      final source = <int, int>{1: 3};
      final progress = AdventureProgress(
        highestWorldIndex: 1,
        completedLevelStars: source,
      );

      source[2] = 2;

      expect(progress.completedLevelStars, {1: 3});
      expect(() => progress.completedLevelStars[3] = 1, throwsUnsupportedError);
    });

    test('malformed world and star values use safe defaults', () {
      final malformedStores = [
        _MemoryAdventureStore({
          'highest_world_index': 'three',
          'completed_levels_stars': 'not a map',
        }),
        _MemoryAdventureStore({
          'highest_world_index': 0,
          'completed_levels_stars': {
            '0': 3,
            '-1': 2,
            'abc': 1,
            '1': 0,
            '2': 4,
            '3': 'three',
          },
        }),
      ];

      for (final store in malformedStores) {
        final progress = AdventureRepositoryImpl(store).loadProgress();
        expect(progress.highestWorldIndex, 1);
        expect(progress.completedLevelStars, isEmpty);
      }
    });

    test('failed second write restores both previous keys', () async {
      final previousStars = <String, int>{'1': 2};
      final store = _MemoryAdventureStore({
        'highest_world_index': 2,
        'completed_levels_stars': previousStars,
      })..failOnMutation = 2;
      final repository = AdventureRepositoryImpl(store);

      await expectLater(
        repository.saveProgress(
          AdventureProgress(
            highestWorldIndex: 3,
            completedLevelStars: {1: 3, 2: 2},
          ),
        ),
        throwsStateError,
      );

      expect(store.values['highest_world_index'], 2);
      expect(store.values['completed_levels_stars'], previousStars);
    });

    test('failed reset restores both previous keys', () async {
      final previousStars = <String, int>{'1': 3, '2': 2};
      final store = _MemoryAdventureStore({
        'highest_world_index': 2,
        'completed_levels_stars': previousStars,
      })..failOnMutation = 2;
      final repository = AdventureRepositoryImpl(store);

      await expectLater(repository.resetProgress(), throwsStateError);

      expect(store.values['highest_world_index'], 2);
      expect(store.values['completed_levels_stars'], previousStars);
    });

    test(
      'rollback attempts both keys and reports the original failure',
      () async {
        final original = StateError('forward write failed');
        final rollback = StateError('world rollback failed');
        final store =
            _MemoryAdventureStore({
                'highest_world_index': 2,
                'completed_levels_stars': <String, int>{'1': 2},
              })
              ..errorsByMutation[2] = original
              ..errorsByMutation[3] = rollback;
        final repository = AdventureRepositoryImpl(store);

        await expectLater(
          repository.saveProgress(
            AdventureProgress(
              highestWorldIndex: 3,
              completedLevelStars: {1: 3, 2: 2},
            ),
          ),
          throwsA(
            isA<AdventureProgressPersistenceException>()
                .having((error) => error.cause, 'cause', same(original))
                .having(
                  (error) => error.rollbackErrors,
                  'rollbackErrors',
                  contains(same(rollback)),
                ),
          ),
        );

        expect(store.mutatedKeys, [
          'highest_world_index',
          'completed_levels_stars',
          'highest_world_index',
          'completed_levels_stars',
        ]);
        expect(store.values['completed_levels_stars'], <String, int>{'1': 2});
      },
    );
  });
}

class _MemoryAdventureStore implements AdventureProgressStore {
  _MemoryAdventureStore([Map<String, Object?> initial = const {}])
    : values = Map<String, Object?>.from(initial);

  final Map<String, Object?> values;
  int? failOnMutation;
  final Map<int, Object> errorsByMutation = {};
  final List<String> mutatedKeys = [];
  int _mutationCount = 0;

  @override
  Object? read(String key) => values[key];

  @override
  Future<void> write(String key, Object value) async {
    _throwIfConfigured(key);
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _throwIfConfigured(key);
    values.remove(key);
  }

  void _throwIfConfigured(String key) {
    _mutationCount++;
    mutatedKeys.add(key);
    if (errorsByMutation.remove(_mutationCount) case final error?) {
      throw error;
    }
    if (_mutationCount == failOnMutation) {
      failOnMutation = null;
      throw StateError('controlled store failure');
    }
  }
}
