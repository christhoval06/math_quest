import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/gameplay/presentation/models/buddy_challenge_state.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/buddy_player_arena.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/buddy_score_divider.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';

typedef BuddySubmitAnswer = void Function({
  required int playerNumber,
  required int answer,
  required int problemRevision,
});

class BuddyPlayingView extends StatelessWidget {
  final BuddyChallengeState state;
  final VoidCallback onClose;
  final BuddySubmitAnswer onAnswer;
  final ResponseMode responseMode;
  final VoidCallback onInputFeedback;

  const BuddyPlayingView({
    super.key,
    required this.state,
    required this.onClose,
    required this.onAnswer,
    required this.responseMode,
    required this.onInputFeedback,
  });

  @override
  Widget build(BuildContext context) {
    final problem = state.problem!;

    void submit(int playerNumber, int answer, int problemRevision) {
      onAnswer(
        playerNumber: playerNumber,
        answer: answer,
        problemRevision: problemRevision,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BuddyPlayerArena(
                key: const Key('buddy-player-1-arena'),
                playerNumber: 1,
                playerName: state.settings.player1Name,
                score: state.player1Score,
                targetScore: state.settings.pointsToWin,
                problem: problem,
                responseMode: responseMode,
                isAnswerLocked: state.hasAnswered(1),
                accentColor: AppColors.opAddition,
                backgroundColor: const Color(0xFFEFF6FF),
                rotateForOpponent: true,
                onInputFeedback: onInputFeedback,
                onAnswer: submit,
              ),
            ),
            BuddyScoreDivider(
              player1Score: state.player1Score,
              player2Score: state.player2Score,
              pointsToWin: state.settings.pointsToWin,
              onClose: onClose,
            ),
            Expanded(
              child: BuddyPlayerArena(
                key: const Key('buddy-player-2-arena'),
                playerNumber: 2,
                playerName: state.settings.player2Name,
                score: state.player2Score,
                targetScore: state.settings.pointsToWin,
                problem: problem,
                responseMode: responseMode,
                isAnswerLocked: state.hasAnswered(2),
                accentColor: AppColors.opSubtraction,
                backgroundColor: const Color(0xFFFFF1F2),
                rotateForOpponent: false,
                onInputFeedback: onInputFeedback,
                onAnswer: submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
