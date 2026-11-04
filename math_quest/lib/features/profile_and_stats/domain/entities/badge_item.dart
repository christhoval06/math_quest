import 'package:flutter/material.dart';

import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/math_engine/domain/entities/exam_report.dart';

enum BadgeTier { bronze, silver, gold, diamond }

class BadgeContext {
  final UserProfile profile;
  final ExamReport report;
  final bool isBossDefeated;
  final bool isDailyMissionCompleted;

  const BadgeContext({
    required this.profile,
    required this.report,
    this.isBossDefeated = false,
    this.isDailyMissionCompleted = false,
  });
}

typedef BadgeCondition = bool Function(BadgeContext ctx);

class BadgeItem {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;
  final BadgeTier tier;
  final BadgeCondition isUnlockConditionMet;

  const BadgeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.tier,
    required this.isUnlockConditionMet,
  });

  /// 🌟 20 UNIQUE PEDAGOGICAL BADGES
  static List<BadgeItem> get allBadges => [
    // =====================================================================
    // SPEED & REFLEXES
    // =====================================================================
    BadgeItem(
      id: 'speed_counter',
      title: 'Speed Counter',
      description: 'Answer 5 questions under 5 seconds each in one round.',
      icon: '⏱️',
      category: 'SPEED',
      tier: BadgeTier.gold,
      isUnlockConditionMet: (ctx) =>
          ctx.report.answers
              .where((a) => a.isCorrect && a.timeTaken.inSeconds <= 5)
              .length >=
          5,
    ),
    BadgeItem(
      id: 'lightning_math',
      title: 'Lightning Math',
      description: 'Answer 10 correct questions in under 30 seconds total.',
      icon: '⚡',
      category: 'SPEED',
      tier: BadgeTier.silver,
      isUnlockConditionMet: (ctx) =>
          ctx.report.correctCount >= 10 &&
          ctx.report.totalDuration.inSeconds <= 30,
    ),
    BadgeItem(
      id: 'quick_thinker',
      title: 'Quick Thinker',
      description: 'Solve your first problem in under 3 seconds.',
      icon: '💡',
      category: 'SPEED',
      tier: BadgeTier.bronze,
      isUnlockConditionMet: (ctx) => ctx.report.answers.any(
        (a) => a.isCorrect && a.timeTaken.inSeconds <= 3,
      ),
    ),

    // =====================================================================
    // ACCURACY & PERFECTION
    // =====================================================================
    BadgeItem(
      id: 'clean_slate',
      title: 'Zero Mistake Hero',
      description: 'Score 100% accuracy on a round with at least 10 questions.',
      icon: '🎯',
      category: 'ACCURACY',
      tier: BadgeTier.diamond,
      isUnlockConditionMet: (ctx) =>
          ctx.report.totalQuestions >= 10 &&
          ctx.report.accuracyPercentage == 100,
    ),
    BadgeItem(
      id: 'sharp_shooter',
      title: 'Sharp Shooter',
      description: 'Score 5 correct answers in a row with zero mistakes.',
      icon: '🏹',
      category: 'ACCURACY',
      tier: BadgeTier.bronze,
      isUnlockConditionMet: (ctx) => ctx.report.correctCount >= 5,
    ),
    BadgeItem(
      id: 'flawless_focus',
      title: 'Flawless Focus',
      description: 'Complete a 15+ question round with 90%+ accuracy.',
      icon: '💎',
      category: 'ACCURACY',
      tier: BadgeTier.gold,
      isUnlockConditionMet: (ctx) =>
          ctx.report.totalQuestions >= 15 &&
          ctx.report.accuracyPercentage >= 90,
    ),

    // =====================================================================
    // HABITS & STREAKS
    // =====================================================================
    BadgeItem(
      id: 'early_starter',
      title: 'Habit Starter',
      description: 'Maintain a 3-day active learning streak.',
      icon: '🌱',
      category: 'STREAK',
      tier: BadgeTier.bronze,
      isUnlockConditionMet: (ctx) => ctx.profile.currentStreak >= 3,
    ),
    BadgeItem(
      id: 'week_warrior',
      title: 'Week Warrior',
      description: 'Maintain an unstoppable 7-day learning streak.',
      icon: '🛡️',
      category: 'STREAK',
      tier: BadgeTier.gold,
      isUnlockConditionMet: (ctx) => ctx.profile.currentStreak >= 7,
    ),
    BadgeItem(
      id: 'fortnight_legend',
      title: 'Fortnight Titan',
      description: 'Reach a legendary 14-day practice streak.',
      icon: '🔥',
      category: 'STREAK',
      tier: BadgeTier.diamond,
      isUnlockConditionMet: (ctx) => ctx.profile.currentStreak >= 14,
    ),

    // =====================================================================
    // VOLUME & MILESTONES
    // =====================================================================
    BadgeItem(
      id: 'half_century',
      title: 'First Fifty',
      description: 'Solve 50 math problems total across all operations.',
      icon: '🥉',
      category: 'MILESTONE',
      tier: BadgeTier.bronze,
      isUnlockConditionMet: (ctx) {
        final total = ctx.profile.masteryTracks.values.fold<int>(
          0,
          (s, t) => s + t.totalSolved,
        );
        return (total + ctx.report.correctCount) >= 50;
      },
    ),
    BadgeItem(
      id: 'century_club',
      title: 'Century Club',
      description: 'Solve 100 math problems total across all operations.',
      icon: '💯',
      category: 'MILESTONE',
      tier: BadgeTier.silver,
      isUnlockConditionMet: (ctx) {
        final total = ctx.profile.masteryTracks.values.fold<int>(
          0,
          (s, t) => s + t.totalSolved,
        );
        return (total + ctx.report.correctCount) >= 100;
      },
    ),
    BadgeItem(
      id: 'grand_master_500',
      title: 'Math Marathoner',
      description: 'Reach 500 lifetime questions answered.',
      icon: '🏅',
      category: 'MILESTONE',
      tier: BadgeTier.gold,
      isUnlockConditionMet: (ctx) {
        final total = ctx.profile.masteryTracks.values.fold<int>(
          0,
          (s, t) => s + t.totalSolved,
        );
        return (total + ctx.report.correctCount) >= 500;
      },
    ),
    BadgeItem(
      id: 'millennium_scholar',
      title: 'Millennium Scholar',
      description: 'Solve an astonishing 1,000 total questions!',
      icon: '🌌',
      category: 'MILESTONE',
      tier: BadgeTier.diamond,
      isUnlockConditionMet: (ctx) {
        final total = ctx.profile.masteryTracks.values.fold<int>(
          0,
          (s, t) => s + t.totalSolved,
        );
        return (total + ctx.report.correctCount) >= 1000;
      },
    ),

    // =====================================================================
    // OPERATION MASTERY
    // =====================================================================
    BadgeItem(
      id: 'addition_superhero',
      title: 'Sum Hero',
      description: 'Solve 100 addition problems with 90%+ accuracy.',
      icon: '➕',
      category: 'MASTERY',
      tier: BadgeTier.gold,
      isUnlockConditionMet: (ctx) {
        final track = ctx.profile.masteryTracks['addition'];
        return (track?.totalSolved ?? 0) >= 100 &&
            (track?.accuracy ?? 0) >= 0.90;
      },
    ),
    BadgeItem(
      id: 'minus_ninja',
      title: 'Minus Ninja',
      description: 'Solve 100 subtraction problems with 85%+ accuracy.',
      icon: '➖',
      category: 'MASTERY',
      tier: BadgeTier.silver,
      isUnlockConditionMet: (ctx) {
        final track = ctx.profile.masteryTracks['subtraction'];
        return (track?.totalSolved ?? 0) >= 100 &&
            (track?.accuracy ?? 0) >= 0.85;
      },
    ),
    BadgeItem(
      id: 'times_master',
      title: 'Times Master',
      description: 'Reach Level 4 in Multiplication Mastery Track.',
      icon: '✖️',
      category: 'MASTERY',
      tier: BadgeTier.diamond,
      isUnlockConditionMet: (ctx) {
        final track = ctx.profile.masteryTracks['multiplication'];
        return (track?.level ?? 1) >= 4;
      },
    ),
    BadgeItem(
      id: 'division_champ',
      title: 'Fair Share Champ',
      description: 'Solve 75 division challenges without remainders.',
      icon: '➗',
      category: 'MASTERY',
      tier: BadgeTier.gold,
      isUnlockConditionMet: (ctx) {
        final track = ctx.profile.masteryTracks['division'];
        return (track?.totalSolved ?? 0) >= 75 &&
            (track?.accuracy ?? 0) >= 0.85;
      },
    ),

    // =====================================================================
    // ADVENTURE & SPECIAL QUESTS
    // =====================================================================
    BadgeItem(
      id: 'boss_slayer',
      title: 'Island Conqueror',
      description: 'Defeat a World Boss in Adventure Island.',
      icon: '👑',
      category: 'ADVENTURE',
      tier: BadgeTier.diamond,
      isUnlockConditionMet: (ctx) => ctx.isBossDefeated,
    ),
    BadgeItem(
      id: 'space_detective',
      title: 'Space Detective',
      description: 'Complete Today’s Daily Mission.',
      icon: '🔍',
      category: 'DAILY',
      tier: BadgeTier.silver,
      isUnlockConditionMet: (ctx) => ctx.isDailyMissionCompleted,
    ),
    BadgeItem(
      id: 'quad_master',
      title: 'Grand Polymath',
      description: 'Reach at least Level 3 across all 4 math operations.',
      icon: '🌟',
      category: 'LEGENDARY',
      tier: BadgeTier.diamond,
      isUnlockConditionMet: (ctx) {
        final tracks = ctx.profile.masteryTracks.values;
        if (tracks.length < 4) return false;
        return tracks.every((t) => t.level >= 3);
      },
    ),
  ];
}
