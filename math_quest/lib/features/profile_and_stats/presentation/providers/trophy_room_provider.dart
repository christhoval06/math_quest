import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/features/profile_and_stats/data/repositories/daily_practice_progress.dart';

import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';

/// 1. Pure Immutable UI State for the Trophy Room
class TrophyRoomState {
  final int totalSolved;
  final int todaySolved;
  final double averageAccuracy;
  final int streakDays;
  final int starCoins;
  final List<String> unlockedBadgeIds;
  final int totalBadgesCount;
  final Map<String, int> weeklyData;
  final List<MasteryTrack> masteryTracks;
  final UserProfile? profile;

  const TrophyRoomState({
    required this.totalSolved,
    this.todaySolved = 0,
    required this.averageAccuracy,
    required this.streakDays,
    required this.starCoins,
    required this.unlockedBadgeIds,
    required this.totalBadgesCount,
    required this.weeklyData,
    required this.masteryTracks,
    required this.profile,
  });

  int get unlockedCount => unlockedBadgeIds.length;
  int get remainingBadgesCount =>
      (totalBadgesCount - unlockedCount).clamp(0, 99);
}

/// 2. The Logic Provider (Computes all stats outside the widget tree!)
final trophyRoomProvider = Provider.autoDispose<TrophyRoomState>((ref) {
  final now = ref.watch(practiceClockProvider)();
  final nextMidnight = DateTime(now.year, now.month, now.day + 1);
  final refreshTimer = Timer(nextMidnight.difference(now), ref.invalidateSelf);
  final lifecycle = AppLifecycleListener(onResume: ref.invalidateSelf);
  ref.onDispose(refreshTimer.cancel);
  ref.onDispose(lifecycle.dispose);

  final profile = ref.watch(profileNotifierProvider);
  final tracks = profile?.masteryTracks.values.toList() ?? [];

  // 📈 Business Logic: Sum totals & compute average accuracy across active operations
  final totalSolved = tracks.fold<int>(0, (sum, t) => sum + t.totalSolved);
  final activeTracks = tracks.where((t) => t.totalSolved > 0).toList();
  final avgAccuracy = activeTracks.isEmpty
      ? 0.0
      : (activeTracks.fold<double>(0.0, (sum, t) => sum + t.accuracy) /
            activeTracks.length);

  // 💾 Data Layer: Read weekly chart data
  final box = Hive.box('app_settings_box');
  final weeklyMap = Map<String, int>.from(
    box.get('weekly_chart_data', defaultValue: {}) as Map,
  );

  return TrophyRoomState(
    totalSolved: totalSolved,
    todaySolved: profile == null
        ? 0
        : DailyPracticeProgress(box).solvedOn(profile.id, now),
    averageAccuracy: avgAccuracy,
    streakDays: profile?.currentStreak ?? 1,
    starCoins: profile?.starCoins ?? 0,
    unlockedBadgeIds: profile?.unlockedBadgeIds ?? [],
    totalBadgesCount: BadgeItem.allBadges.length,
    weeklyData: weeklyMap,
    masteryTracks: tracks,
    profile: profile,
  );
});
