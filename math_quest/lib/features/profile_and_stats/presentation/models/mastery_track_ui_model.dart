import 'package:flutter/material.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';
import 'package:math_quest/features/profile_and_stats/domain/services/mastery_progression_engine.dart';

import 'math_operation_ui_ext.dart';

class MasteryTrackUiModel {
  final MasteryTrack track;
  final MasteryTier tier;
  final double progressToNextLevel;
  final int questionsRemaining;

  MasteryTrackUiModel._({
    required this.track,
    required this.tier,
    required this.progressToNextLevel,
    required this.questionsRemaining,
  });

  factory MasteryTrackUiModel.fromDomain(MasteryTrack track) {
    final tier = MasteryProgressionEngine.getTierForSolvedCount(
      track.totalSolved,
    );
    final progress = MasteryProgressionEngine.getProgressToNextLevel(
      track.totalSolved,
    );
    final remaining =
        MasteryProgressionEngine.getQuestionsRemainingForNextLevel(
          track.totalSolved,
        );

    return MasteryTrackUiModel._(
      track: track,
      tier: tier,
      progressToNextLevel: progress,
      questionsRemaining: remaining,
    );
  }

  String get symbol => track.operation.symbol;
  String get operationTitle => track.operation.displayName;
  Color get accentColor => track.operation.color;

  String get accuracyLabel =>
      track.totalSolved == 0 ? '--%' : '${(track.accuracy * 100).toInt()}% Acc';

  String get rankLabel =>
      '${tier.badgeIcon} ${tier.title} (Level ${tier.level})';

  String get progressDetailLabel {
    if (track.totalSolved == 0) {
      return '0 solved • $questionsRemaining to Level 2';
    }
    if (questionsRemaining == 0) {
      return '${track.totalSolved} solved • Max Level! 👑';
    }
    return '${track.totalSolved} solved • $questionsRemaining to Level ${tier.level + 1}';
  }

  bool get hasActivity => track.totalSolved > 0;
}
