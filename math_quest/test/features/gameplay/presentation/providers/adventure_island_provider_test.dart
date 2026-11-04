import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_progress.dart';
import 'package:math_quest/features/gameplay/domain/repositories/i_adventure_repository.dart';
import 'package:math_quest/features/gameplay/domain/usecases/generate_adventure_world_usecase.dart';
import 'package:math_quest/features/gameplay/presentation/models/adventure_island_state.dart';
import 'package:math_quest/features/gameplay/presentation/providers/adventure_island_provider.dart';
import 'package:math_quest/features/gameplay/presentation/providers/adventure_provider.dart';

void main() {
  test('maps world metadata, switcher rows, levels, and celebration', () async {
    final notifier = _notifierWithTwoWorlds();
    await notifier.completeLevel(6, 3);
    final source = notifier.state.copyWith(justUnlockedNewWorld: true);

    final state = AdventureIslandState.fromAdventure(source);
    final current = source.currentWorld;

    expect(state.activeWorldIndex, 2);
    expect(state.currentWorldTitle, current.theme.name);
    expect(state.currentWorldEmoji, current.theme.emoji);
    expect(state.primaryColor, current.theme.primaryColor);
    expect(state.backgroundColor, current.theme.bgTint);
    expect(state.bossName, current.theme.bossName);
    expect(state.bossEmoji, current.theme.bossEmoji);
    expect(state.worlds, hasLength(2));
    expect(state.worlds[1].isSelected, isTrue);
    expect(state.levels.first.levelNumber, 6);
    expect(state.levels.first.status, LevelStatus.completed);
    expect(state.levels.first.stars, 3);
    expect(state.celebration?.worldName, current.theme.name);
    expect(state.celebration?.emoji, current.theme.emoji);
  });

  test('maps center right center left path cycle', () {
    final state = AdventureIslandState.fromAdventure(
      _notifierWithTwoWorlds().state,
    );

    expect(state.levels.map((level) => level.pathPosition), [
      AdventurePathPosition.center,
      AdventurePathPosition.right,
      AdventurePathPosition.center,
      AdventurePathPosition.left,
      AdventurePathPosition.center,
    ]);
  });

  test('mapped lists are immutable snapshots', () {
    final notifier = _notifierWithTwoWorlds();
    final source = notifier.state;
    final state = AdventureIslandState.fromAdventure(source);

    source.worlds.clear();

    expect(state.worlds, hasLength(2));
    expect(state.levels, hasLength(5));
    expect(() => state.worlds.add(state.worlds.first), throwsUnsupportedError);
    expect(() => state.levels.clear(), throwsUnsupportedError);
  });

  test('provider composes the adventure provider into view state', () {
    final notifier = _notifierWithTwoWorlds();
    final container = ProviderContainer(
      overrides: [adventureProvider.overrideWith((ref) => notifier)],
    );
    addTearDown(container.dispose);

    final state = container.read(adventureIslandProvider);

    expect(state.activeWorldIndex, notifier.state.activeWorldIndex);
    expect(state.currentWorldTitle, notifier.state.currentWorld.theme.name);
    expect(state.backgroundColor, isA<Color>());
  });
}

AdventureNotifier _notifierWithTwoWorlds() {
  return AdventureNotifier(
    GenerateAdventureWorldUseCase(),
    _MemoryRepository(
      AdventureProgress(
        highestWorldIndex: 2,
        completedLevelStars: {1: 3, 2: 3, 3: 3, 4: 3, 5: 3},
      ),
    ),
  );
}

class _MemoryRepository implements IAdventureRepository {
  _MemoryRepository(this.progress);

  AdventureProgress progress;

  @override
  AdventureProgress loadProgress() => progress;

  @override
  Future<void> resetProgress() async {
    progress = AdventureProgress.empty();
  }

  @override
  Future<void> saveProgress(AdventureProgress progress) async {
    this.progress = progress;
  }
}
