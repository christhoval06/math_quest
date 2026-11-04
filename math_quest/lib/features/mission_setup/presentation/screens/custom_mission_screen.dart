import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/theme/theme_provider.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/features/mission_setup/presentation/providers/custom_mission_provider.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/custom_mission_app_bar.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_difficulty_selector.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_helper_toggles.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_lab_header.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_launch_button.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_mode_selector.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_operation_grid.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_question_selector.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_reward_banner.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_timer_selector.dart';

class CustomMissionScreen extends ConsumerWidget {
  const CustomMissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(visualThemeProvider);
    final state = ref.watch(customMissionProvider);
    final controller = ref.read(customMissionControllerProvider);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: CustomMissionAppBar(
        starCoins: state.starCoins,
        streakDays: state.streakDays,
        onBack: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const MissionLabHeader(),
                const SizedBox(height: 20),
                MissionModeSelector(
                  isExamMode: state.isExamMode,
                  onChanged: controller.setExamMode,
                ),
                const SizedBox(height: 24),
                MissionOperationGrid(
                  selectedOperations: state.selectedOperations,
                  onToggle: controller.toggleOperation,
                ),
                const SizedBox(height: 24),
                MissionDifficultySelector(
                  selectedDifficulty: state.selectedDifficulty,
                  onSelected: controller.selectDifficulty,
                ),
                const SizedBox(height: 24),
                MissionTimerSelector(
                  selectedSeconds: state.selectedTimerSeconds,
                  onSelected: controller.selectTimer,
                ),
                const SizedBox(height: 24),
                MissionHelperToggles(
                  visualAidsEnabled: state.visualAidsEnabled,
                  soundEnabled: state.soundEnabled,
                  isExamMode: state.isExamMode,
                  onVisualAidsChanged: controller.setVisualAidsEnabled,
                  onSoundChanged: controller.setSoundEnabled,
                ),
                const SizedBox(height: 20),
                MissionQuestionSelector(
                  selectedCount: state.selectedQuestionCount,
                  isExamMode: state.isExamMode,
                  onChanged: controller.selectQuestionCount,
                ),
                const SizedBox(height: 24),
                const MissionRewardBanner(),
                const SizedBox(height: 24),
                MissionLaunchButton(
                  isExamMode: state.isExamMode,
                  label: state.isExamMode
                      ? AppLocalizations.of(context)!
                            .startExamCount(state.selectedQuestionCount)
                      : AppLocalizations.of(context)!
                            .launchMissionCount(state.selectedQuestionCount),
                  onPressed: () => _launchMission(context, controller),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchMission(
    BuildContext context,
    CustomMissionController controller,
  ) {
    final mission = controller.prepareMission();
    Navigator.pushNamed(
      context,
      AppRoutes.activeGame,
      arguments: ActiveGameArgs(
        timerSeconds: mission.timerSeconds,
        isExamMode: mission.isExamMode,
        allowedOperations: mission.allowedOperations,
        totalQuestions: mission.totalQuestions,
        preservePreparedSession: true,
        visualAidsEnabled: mission.visualAidsEnabled,
        soundEnabled: mission.soundEnabled,
      ),
    );
  }
}
