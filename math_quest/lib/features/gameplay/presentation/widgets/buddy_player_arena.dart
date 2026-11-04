import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/gameplay/presentation/models/buddy_challenge_state.dart';
import 'package:math_quest/features/gameplay/presentation/models/gameplay_localizations.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/written_answer_pad.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/l10n/app_localizations.dart';

typedef BuddyAnswerCallback = void Function(
  int playerNumber,
  int answer,
  int problemRevision,
);

class BuddyPlayerArena extends StatelessWidget {
  final int playerNumber;
  final String playerName;
  final int score;
  final int targetScore;
  final BuddyProblemViewData problem;
  final ResponseMode responseMode;
  final bool isAnswerLocked;
  final Color accentColor;
  final Color backgroundColor;
  final bool rotateForOpponent;
  final VoidCallback onInputFeedback;
  final BuddyAnswerCallback onAnswer;

  const BuddyPlayerArena({
    super.key,
    required this.playerNumber,
    required this.playerName,
    required this.score,
    required this.targetScore,
    required this.problem,
    required this.responseMode,
    required this.isAnswerLocked,
    required this.accentColor,
    required this.backgroundColor,
    required this.rotateForOpponent,
    required this.onInputFeedback,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final arena = Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      localizedPlayerName(
                        AppLocalizations.of(context)!,
                        playerName,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: List.generate(
                          targetScore,
                          (index) => Icon(
                            Icons.star_rounded,
                            size: 20,
                            color: index < score
                                ? accentColor
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                problem.equation,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              if (responseMode == ResponseMode.choice)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.8,
                  ),
                  itemCount: problem.options.length,
                  itemBuilder: (context, index) {
                    final option = problem.options[index];
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textPrimary,
                        elevation: 2,
                        shadowColor: Colors.black.withValues(alpha: 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: accentColor.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                      ),
                      onPressed: isAnswerLocked
                          ? null
                          : () => onAnswer(
                              playerNumber,
                              option,
                              problem.revision,
                            ),
                      child: Text(
                        '$option',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    );
                  },
                )
              else
                WrittenAnswerPad(
                  key: ValueKey(
                    'buddy-write-$playerNumber-${problem.revision}',
                  ),
                  digitCount: problem.correctAnswer.toString().length,
                  enabled: !isAnswerLocked,
                  compact: true,
                  accentColor: accentColor,
                  onInputFeedback: onInputFeedback,
                  onSubmit: (answer) async {
                    onAnswer(playerNumber, answer, problem.revision);
                  },
                ),
            ],
          ),
        ),
      ),
    );

    if (!rotateForOpponent) return arena;
    return Transform.rotate(
      key: Key('buddy-player-$playerNumber-rotated'),
      angle: math.pi,
      child: arena,
    );
  }
}
