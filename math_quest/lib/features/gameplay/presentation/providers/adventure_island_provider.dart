import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/features/gameplay/presentation/controllers/adventure_island_controller.dart';
import 'package:math_quest/features/gameplay/presentation/models/adventure_island_state.dart';
import 'package:math_quest/features/gameplay/presentation/providers/adventure_provider.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_notifier.dart';

final adventureIslandProvider = Provider<AdventureIslandState>((ref) {
  return AdventureIslandState.fromAdventure(ref.watch(adventureProvider));
});

final adventureIslandControllerProvider = Provider<AdventureIslandController>((
  ref,
) {
  return AdventureIslandController(
    readState: () => ref.read(adventureIslandProvider),
    switchWorldAction: (worldIndex) =>
        ref.read(adventureProvider.notifier).switchWorld(worldIndex),
    clearNotificationAction: () =>
        ref.read(adventureProvider.notifier).clearNewWorldNotification(),
    resetPracticeSessionAction: ({required operation, required difficulty}) =>
        ref
            .read(practiceSessionProvider.notifier)
            .resetSession(operation: operation, difficulty: difficulty),
  );
});
