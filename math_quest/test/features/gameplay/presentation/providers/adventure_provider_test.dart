import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_progress.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';
import 'package:math_quest/features/gameplay/domain/repositories/i_adventure_repository.dart';
import 'package:math_quest/features/gameplay/domain/usecases/generate_adventure_world_usecase.dart';
import 'package:math_quest/features/gameplay/presentation/providers/adventure_provider.dart';

void main() {
  group('AdventureNotifier', () {
    test('repository progress reconstructs worlds and active levels', () {
      final repository = _FakeAdventureRepository(
        AdventureProgress(
          highestWorldIndex: 2,
          completedLevelStars: {1: 3, 2: 2, 3: 1, 4: 3, 5: 2},
        ),
      );

      final notifier = AdventureNotifier(
        GenerateAdventureWorldUseCase(),
        repository,
      );

      expect(notifier.state.worlds, hasLength(2));
      expect(notifier.state.activeWorldIndex, 2);
      expect(
        notifier.state.worlds.first.levels.map((level) => level.status),
        everyElement(LevelStatus.completed),
      );
      expect(notifier.state.worlds[1].levels.first.status, LevelStatus.active);
      expect(
        notifier.state.worlds[1].levels.skip(1).map((e) => e.status),
        everyElement(LevelStatus.locked),
      );
    });

    test('completing a normal level persists before publishing the next active level', () async {
      final repository = _FakeAdventureRepository(AdventureProgress.empty())
        ..pauseSaves = true;
      final notifier = AdventureNotifier(
        GenerateAdventureWorldUseCase(),
        repository,
      );

      final completion = notifier.completeLevel(1, 3);
      await repository.waitForSaveCount(1);

      expect(repository.requestedSaves.single.completedLevelStars, {1: 3});
      expect(notifier.state.currentWorld.levels[0].status, LevelStatus.active);
      expect(notifier.state.currentWorld.levels[1].status, LevelStatus.locked);

      repository.releaseNextSave();
      await completion;

      expect(
        notifier.state.currentWorld.levels[0].status,
        LevelStatus.completed,
      );
      expect(notifier.state.currentWorld.levels[1].status, LevelStatus.active);
    });

    test(
      'completing a boss persists the next world before publishing it',
      () async {
        final repository = _FakeAdventureRepository(
          AdventureProgress(
            highestWorldIndex: 1,
            completedLevelStars: {1: 3, 2: 3, 3: 3, 4: 3},
          ),
        )..pauseSaves = true;
        final notifier = AdventureNotifier(
          GenerateAdventureWorldUseCase(),
          repository,
        );

        final completion = notifier.completeLevel(5, 2);
        await repository.waitForSaveCount(1);

        expect(repository.requestedSaves.single.highestWorldIndex, 2);
        expect(repository.requestedSaves.single.completedLevelStars[5], 2);
        expect(notifier.state.worlds, hasLength(1));

        repository.releaseNextSave();
        await completion;

        expect(notifier.state.worlds, hasLength(2));
        expect(notifier.state.activeWorldIndex, 2);
        expect(notifier.state.justUnlockedNewWorld, isTrue);
        expect(
          notifier.state.worlds[1].levels.first.status,
          LevelStatus.active,
        );
      },
    );

    test('replaying a completed boss does not unlock another world', () async {
      final repository = _FakeAdventureRepository(
        AdventureProgress(
          highestWorldIndex: 1,
          completedLevelStars: {1: 3, 2: 3, 3: 3, 4: 3},
        ),
      );
      final notifier = AdventureNotifier(
        GenerateAdventureWorldUseCase(),
        repository,
      );

      await notifier.completeLevel(5, 2);
      notifier.clearNewWorldNotification();
      await notifier.completeLevel(5, 3);

      expect(notifier.state.worlds, hasLength(2));
      expect(notifier.state.justUnlockedNewWorld, isFalse);
      expect(repository.persisted.highestWorldIndex, 2);
      expect(repository.persisted.completedLevelStars[5], 3);
    });

    test('overlapping duplicate boss completions unlock one world', () async {
      final repository = _FakeAdventureRepository(
        AdventureProgress(
          highestWorldIndex: 1,
          completedLevelStars: {1: 3, 2: 3, 3: 3, 4: 3},
        ),
      )..pauseSaves = true;
      final notifier = AdventureNotifier(
        GenerateAdventureWorldUseCase(),
        repository,
      );

      final first = notifier.completeLevel(5, 2);
      final second = notifier.completeLevel(5, 3);
      await repository.waitForSaveCount(1);
      repository.releaseNextSave();
      await repository.waitForSaveCount(2);
      repository.releaseNextSave();
      await Future.wait([first, second]);

      expect(notifier.state.worlds, hasLength(2));
      expect(repository.persisted.highestWorldIndex, 2);
      expect(repository.persisted.completedLevelStars[5], 3);
    });

    test(
      'invalid stars, missing levels, and locked levels never save',
      () async {
        final repository = _FakeAdventureRepository(AdventureProgress.empty());
        final notifier = AdventureNotifier(
          GenerateAdventureWorldUseCase(),
          repository,
        );
        final previous = notifier.state;

        await expectLater(notifier.completeLevel(1, 0), throwsRangeError);
        await expectLater(notifier.completeLevel(999, 3), throwsArgumentError);
        await expectLater(notifier.completeLevel(2, 3), throwsStateError);

        expect(repository.requestedSaves, isEmpty);
        expect(identical(notifier.state, previous), isTrue);
      },
    );

    test('persistence failure preserves prior state', () async {
      final repository = _FakeAdventureRepository(AdventureProgress.empty())
        ..saveError = StateError('save failed');
      final notifier = AdventureNotifier(
        GenerateAdventureWorldUseCase(),
        repository,
      );
      final previous = notifier.state;

      await expectLater(notifier.completeLevel(1, 3), throwsStateError);

      expect(identical(notifier.state, previous), isTrue);
    });

    test('overlapping completions execute in request order', () async {
      final repository = _FakeAdventureRepository(AdventureProgress.empty())
        ..pauseSaves = true;
      final notifier = AdventureNotifier(
        GenerateAdventureWorldUseCase(),
        repository,
      );

      final first = notifier.completeLevel(1, 3);
      final second = notifier.completeLevel(2, 2);
      await repository.waitForSaveCount(1);

      expect(repository.requestedSaves, hasLength(1));
      expect(repository.requestedSaves.first.completedLevelStars, {1: 3});

      repository.releaseNextSave();
      await repository.waitForSaveCount(2);

      expect(repository.requestedSaves[1].completedLevelStars, {1: 3, 2: 2});
      repository.releaseNextSave();
      await Future.wait([first, second]);

      expect(notifier.state.currentWorld.levels[0].stars, 3);
      expect(notifier.state.currentWorld.levels[1].stars, 2);
      expect(notifier.state.currentWorld.levels[2].status, LevelStatus.active);
    });

    test('reset failure preserves prior state', () async {
      final repository = _FakeAdventureRepository(
        AdventureProgress(highestWorldIndex: 1, completedLevelStars: {1: 3}),
      )..resetError = StateError('reset failed');
      final notifier = AdventureNotifier(
        GenerateAdventureWorldUseCase(),
        repository,
      );
      final previous = notifier.state;

      await expectLater(notifier.resetAdventureProgress(), throwsStateError);

      expect(identical(notifier.state, previous), isTrue);
    });

    test('world switching rejects unavailable indices', () {
      final notifier = AdventureNotifier(
        GenerateAdventureWorldUseCase(),
        _FakeAdventureRepository(AdventureProgress.empty()),
      );

      expect(() => notifier.switchWorld(0), throwsArgumentError);
      expect(() => notifier.switchWorld(2), throwsArgumentError);
      expect(notifier.state.activeWorldIndex, 1);
    });

    test('notification clearing is idempotent', () async {
      final repository = _FakeAdventureRepository(
        AdventureProgress(
          highestWorldIndex: 1,
          completedLevelStars: {1: 3, 2: 3, 3: 3, 4: 3},
        ),
      );
      final notifier = AdventureNotifier(
        GenerateAdventureWorldUseCase(),
        repository,
      );
      await notifier.completeLevel(5, 3);

      notifier.clearNewWorldNotification();
      final cleared = notifier.state;
      notifier.clearNewWorldNotification();

      expect(cleared.justUnlockedNewWorld, isFalse);
      expect(identical(notifier.state, cleared), isTrue);
    });
  });
}

class _FakeAdventureRepository implements IAdventureRepository {
  _FakeAdventureRepository(this.persisted);

  AdventureProgress persisted;
  bool pauseSaves = false;
  Object? saveError;
  Object? resetError;
  final List<AdventureProgress> requestedSaves = [];
  final List<Completer<void>> _saveGates = [];
  final StreamController<int> _saveCount = StreamController<int>.broadcast();

  @override
  AdventureProgress loadProgress() => persisted;

  @override
  Future<void> saveProgress(AdventureProgress progress) async {
    requestedSaves.add(progress);
    _saveCount.add(requestedSaves.length);
    if (saveError case final error?) throw error;
    if (pauseSaves) {
      final gate = Completer<void>();
      _saveGates.add(gate);
      await gate.future;
    }
    persisted = progress;
  }

  @override
  Future<void> resetProgress() async {
    if (resetError case final error?) throw error;
    persisted = AdventureProgress.empty();
  }

  Future<void> waitForSaveCount(int count) async {
    if (requestedSaves.length >= count) return;
    await _saveCount.stream.firstWhere((current) => current >= count);
  }

  void releaseNextSave() {
    _saveGates.removeAt(0).complete();
  }
}
