import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/core/haptics/haptic_provider.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/features/gameplay/presentation/models/buddy_challenge_state.dart';
import 'package:math_quest/features/gameplay/presentation/providers/buddy_challenge_provider.dart';
import 'package:math_quest/features/gameplay/presentation/screens/buddy_challenge_winner_screen.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/buddy_challenge_setup_panel.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/buddy_playing_view.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/providers/settings_provider.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class BuddyChallengeScreen extends ConsumerWidget {
  const BuddyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(buddyChallengeProvider);
    final controller = ref.read(buddyChallengeControllerProvider);
    final responseMode = ref.watch(responseModeProvider);
    final haptics = ref.read(hapticServiceProvider);

    return switch (state.phase) {
      BuddyChallengePhase.setup => Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppLocalizations.of(context)!.matchSetup),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: ResponsiveContainer(
              child: BuddyChallengeSetupPanel(
                settings: state.settings,
                onPlayerNameChanged: (playerNumber, name) => controller
                    .setPlayerName(playerNumber: playerNumber, name: name),
                onOperationToggled: controller.toggleOperation,
                onDifficultyChanged: controller.setDifficulty,
                onPointsToWinChanged: controller.setPointsToWin,
                onStart: controller.startGame,
              ),
            ),
          ),
        ),
      ),
      BuddyChallengePhase.playing => BuddyPlayingView(
        state: state,
        responseMode: responseMode,
        onInputFeedback: () => unawaited(haptics.selection()),
        onClose: () => Navigator.pop(context),
        onAnswer: controller.submitAnswer,
      ),
      BuddyChallengePhase.finished => BuddyChallengeWinnerScreen(
        winnerName: state.winnerName,
        winnerNumber: state.winner!,
        player1Score: state.player1Score,
        player2Score: state.player2Score,
        onExit: () => Navigator.pop(context),
        onPlayAgain: controller.playAgain,
        onChangeSettings: controller.changeSettings,
      ),
    };
  }
}
