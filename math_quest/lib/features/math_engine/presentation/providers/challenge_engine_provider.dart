import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/math_engine/domain/entities/superpower_challenge.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_notifier.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_state.dart';

class ChallengeEngineState {
  final SuperpowerChallenge todaysChallenge;
  final bool isChallengeActive;

  const ChallengeEngineState({
    required this.todaysChallenge,
    this.isChallengeActive = false,
  });
}

class ChallengeEngineNotifier extends StateNotifier<ChallengeEngineState> {
  final Ref _ref;

  ChallengeEngineNotifier(this._ref)
    : super(ChallengeEngineState(todaysChallenge: _calculateDailyChallenge()));

  /// Automatically rotates through the catalog based on the day of the year
  static SuperpowerChallenge _calculateDailyChallenge() {
    final catalog = SuperpowerChallenge.catalog;
    final now = DateTime.now();
    // Days since epoch mod catalog length = fresh trick every midnight!
    final dayIndex =
        now.difference(DateTime(2025, 1, 1)).inDays % catalog.length;
    return catalog[dayIndex.abs()];
  }

  /// Launches the targeted challenge into the active game session
  void launchChallenge() {
    final challenge = state.todaysChallenge;
    final initialProblem = challenge.problemGenerator();

    _ref.read(practiceSessionProvider.notifier).state = PracticeSessionState(
      operation: challenge.operation,
      difficulty: challenge.difficulty,
      currentProblem: initialProblem,
      questionsSolvedInSession: 0,
      showVisualAids: true,
    );
  }
}

final challengeEngineProvider =
    StateNotifierProvider<ChallengeEngineNotifier, ChallengeEngineState>((ref) {
      return ChallengeEngineNotifier(ref);
    });
