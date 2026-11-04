import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/gameplay/presentation/models/buddy_challenge_state.dart';
import 'package:math_quest/features/gameplay/presentation/models/gameplay_localizations.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/buddy_points_slider.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_difficulty_selector.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_launch_button.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_operation_grid.dart';
import 'package:math_quest/l10n/app_localizations.dart';

typedef BuddyNameChanged = void Function(int playerNumber, String name);

class BuddyChallengeSetupPanel extends StatelessWidget {
  final BuddyChallengeSettings settings;
  final BuddyNameChanged onPlayerNameChanged;
  final ValueChanged<MathOperation> onOperationToggled;
  final ValueChanged<DifficultyLevel> onDifficultyChanged;
  final ValueChanged<int> onPointsToWinChanged;
  final VoidCallback onStart;

  const BuddyChallengeSetupPanel({
    super.key,
    required this.settings,
    required this.onPlayerNameChanged,
    required this.onOperationToggled,
    required this.onDifficultyChanged,
    required this.onPointsToWinChanged,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        const _BuddyChallengeHeader(),
        const SizedBox(height: 20),
        _PlayerNamesCard(
          player1Name: settings.player1Name,
          player2Name: settings.player2Name,
          onPlayerNameChanged: onPlayerNameChanged,
        ),
        const SizedBox(height: 24),
        MissionOperationGrid(
          selectedOperations: settings.operations.toSet(),
          onToggle: onOperationToggled,
        ),
        const SizedBox(height: 24),
        MissionDifficultySelector(
          selectedDifficulty: settings.difficulty,
          onSelected: onDifficultyChanged,
        ),
        const SizedBox(height: 24),
        BuddyPointsSlider(
          selectedPoints: settings.pointsToWin,
          allowedPoints: BuddyChallengeSettings.allowedPointsToWin,
          onChanged: onPointsToWinChanged,
        ),
        const SizedBox(height: 24),
        MissionLaunchButton(
          isExamMode: false,
          label: AppLocalizations.of(context)!
              .startBuddyChallenge(settings.pointsToWin),
          onPressed: settings.canStart ? onStart : null,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _BuddyChallengeHeader extends StatelessWidget {
  const _BuddyChallengeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('🎮', style: TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BuddyBadge(),
                SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.buddyChallenge,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)!.buddyRulesDescription,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuddyBadge extends StatelessWidget {
  const _BuddyBadge();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          AppLocalizations.of(context)!.buddyArena,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}

class _PlayerNamesCard extends StatelessWidget {
  final String player1Name;
  final String player2Name;
  final BuddyNameChanged onPlayerNameChanged;

  const _PlayerNamesCard({
    required this.player1Name,
    required this.player2Name,
    required this.onPlayerNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PlayersHeader(),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: const Key('buddy-player-1-name'),
                  initialValue: localizedPlayerName(
                    AppLocalizations.of(context)!,
                    player1Name,
                  ),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.playerOne,
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (name) => onPlayerNameChanged(1, name),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  key: const Key('buddy-player-2-name'),
                  initialValue: localizedPlayerName(
                    AppLocalizations.of(context)!,
                    player2Name,
                  ),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.playerTwo,
                  ),
                  onChanged: (name) => onPlayerNameChanged(2, name),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayersHeader extends StatelessWidget {
  const _PlayersHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 11,
          backgroundColor: AppColors.primaryBlue,
          child: Icon(Icons.people_alt_rounded, color: Colors.white, size: 13),
        ),
        SizedBox(width: 8),
        Text(
          AppLocalizations.of(context)!.playerNames,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
