import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';

import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';
import 'package:math_quest/features/math_engine/domain/entities/exam_report.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/domain/services/badge_evaluation_engine.dart';

import 'package:math_quest/core/audio/sound_provider.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_notifier.dart';
import 'package:math_quest/features/mission_setup/presentation/providers/daily_mission_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';
import 'package:math_quest/features/gameplay/presentation/providers/adventure_provider.dart';

class QuestCompleteState {
  final List<BadgeItem> newlyUnlockedBadges;
  final String profileName;
  const QuestCompleteState({
    this.newlyUnlockedBadges = const [],
    this.profileName = '',
  });
}

class QuestCompleteViewModel extends StateNotifier<QuestCompleteState> {
  final Ref _ref;
  late final ConfettiController confettiController;

  QuestCompleteViewModel(this._ref) : super(const QuestCompleteState()) {
    confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  void initializeSession({required ExamReport report, int? levelNumber}) {
    // 1. Play Victory Sound
    _ref.read(soundServiceProvider).playVictory();

    // 2. Evaluate Badges
    final profile = _ref.read(profileNotifierProvider);
    if (profile != null) {
      state = QuestCompleteState(profileName: profile.name);
      final newBadges = BadgeEvaluationEngine.evaluateSession(
        BadgeContext(
          profile: profile,
          report: report,
          isBossDefeated:
              levelNumber != null &&
              (levelNumber % 5 == 0) &&
              report.starsEarned > 0,
        ),
      );

      if (newBadges.isNotEmpty) {
        state = QuestCompleteState(
          newlyUnlockedBadges: newBadges,
          profileName: profile.name,
        );
        _ref
            .read(profileNotifierProvider.notifier)
            .unlockBadges(newBadges.map((b) => b.id).toList());
        confettiController.play();
      }
    }

    // 3. Update Daily Mission
    final activeOperation = _ref.read(practiceSessionProvider).operation;
    _ref
        .read(dailyMissionProvider.notifier)
        .recordSolvedQuestions(
          operation: activeOperation,
          count: report.correctCount,
        );

    final opType = MathOperationType.values.byName(activeOperation.name);
    _ref
        .read(profileNotifierProvider.notifier)
        .recordSessionProgress(
          operation: opType,
          solvedCount: report.totalQuestions,
          correctCount: report.correctCount,
        );

    // 4. Complete Adventure stage if applicable
    if (levelNumber != null && report.starsEarned > 0) {
      _ref
          .read(adventureProvider.notifier)
          .completeLevel(levelNumber, report.starsEarned);
    }

    if (report.starsEarned >= 2) {
      confettiController.play();
    }
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }
}

final questCompleteProvider =
    StateNotifierProvider.autoDispose<
      QuestCompleteViewModel,
      QuestCompleteState
    >((ref) => QuestCompleteViewModel(ref));
