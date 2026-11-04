import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/features/gameplay/presentation/controllers/adventure_island_controller.dart';
import 'package:math_quest/features/gameplay/presentation/models/adventure_island_state.dart';
import 'package:math_quest/features/gameplay/presentation/providers/adventure_island_provider.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/adventure_boss_banner.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/adventure_island_app_bar.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/adventure_level_map.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/new_world_celebration_dialog.dart';

ActiveGameArgs buildAdventureGameArgs(PreparedAdventureSession session) {
  return ActiveGameArgs(
    levelNumber: session.levelNumber,
    stageTitle: session.title,
    timerSeconds: 0,
    allowedOperations: [session.operation],
    preservePreparedSession: true,
  );
}

class AdventureIslandScreen extends ConsumerWidget {
  const AdventureIslandScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adventureIslandProvider);
    final controller = ref.read(adventureIslandControllerProvider);

    ref.listen<AdventureIslandState>(adventureIslandProvider, (previous, next) {
      if (controller.claimCelebration(next)) {
        _scheduleCelebration(
          context,
          controller,
          next.activeWorldIndex,
          next.celebration!,
        );
      }
    });
    if (controller.claimCelebration(state)) {
      _scheduleCelebration(
        context,
        controller,
        state.activeWorldIndex,
        state.celebration!,
      );
    }

    return Scaffold(
      backgroundColor: state.backgroundColor,
      appBar: AdventureIslandAppBar(
        activeWorldIndex: state.activeWorldIndex,
        currentWorldTitle: state.currentWorldTitle,
        currentWorldEmoji: state.currentWorldEmoji,
        worlds: state.worlds,
        onWorldSelected: controller.switchWorld,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveContainer(
            child: Column(
              children: [
                const SizedBox(height: 16),
                AdventureBossBanner(
                  bossName: state.bossName,
                  bossEmoji: state.bossEmoji,
                  primaryColor: state.primaryColor,
                ),
                const SizedBox(height: 24),
                AdventureLevelMap(
                  levels: state.levels,
                  onLevelSelected: (level) =>
                      _startLevel(context, controller, level),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _scheduleCelebration(
    BuildContext context,
    AdventureIslandController controller,
    int worldIndex,
    AdventureCelebrationViewData celebration,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) {
        controller.releaseCelebration(worldIndex);
        return;
      }
      controller.markCelebrationPresented(worldIndex);
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => NewWorldCelebrationDialog(
          celebration: celebration,
          onAcknowledge: () {
            controller.acknowledgeCelebration();
            Navigator.pop(dialogContext);
          },
        ),
      );
      controller.releaseCelebration(worldIndex);
    });
  }

  void _startLevel(
    BuildContext context,
    AdventureIslandController controller,
    AdventureLevelViewData level,
  ) {
    final session = controller.prepareLevel(level);
    Navigator.pushNamed(
      context,
      AppRoutes.activeGame,
      arguments: buildAdventureGameArgs(session),
    );
  }
}
