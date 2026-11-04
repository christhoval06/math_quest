import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:math_quest/features/mission_setup/domain/entities/daily_mission.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';

class DailyMissionState {
  final DailyMission mission;
  final int currentProgress;
  final bool isClaimed;

  const DailyMissionState({
    required this.mission,
    required this.currentProgress,
    this.isClaimed = false,
  });

  double get progressFraction =>
      (currentProgress / mission.targetCount).clamp(0.0, 1.0);
  int get progressPercent => (progressFraction * 100).toInt();
  bool get isCompleted => currentProgress >= mission.targetCount;
}

class DailyMissionNotifier extends StateNotifier<DailyMissionState> {
  final Box _box;
  final Ref _ref;

  DailyMissionNotifier(this._box, this._ref)
    : super(
        DailyMissionState(mission: _getMissionForToday(), currentProgress: 0),
      ) {
    _loadState();
  }

  static DailyMission _getMissionForToday() {
    final catalog = DailyMission.catalog;
    final now = DateTime.now();
    final dayIndex =
        now.difference(DateTime(2025, 1, 1)).inDays % catalog.length;
    return catalog[dayIndex.abs()];
  }

  void _loadState() {
    final now = DateTime.now();
    final todayKey = '${now.year}-${now.month}-${now.day}';
    final savedDate = _box.get('daily_mission_date') as String?;

    if (savedDate != todayKey) {
      // 🌅 Midnight reset! Start fresh for the new day
      _box.put('daily_mission_date', todayKey);
      _box.put('daily_mission_progress', 0);
      _box.put('daily_mission_claimed', false);

      state = DailyMissionState(
        mission: _getMissionForToday(),
        currentProgress: 0,
        isClaimed: false,
      );
    } else {
      // 💾 Load today's saved progress
      final progress =
          _box.get('daily_mission_progress', defaultValue: 0) as int;
      final claimed =
          _box.get('daily_mission_claimed', defaultValue: false) as bool;

      state = DailyMissionState(
        mission: _getMissionForToday(),
        currentProgress: progress,
        isClaimed: claimed,
      );
    }
  }

  /// Called whenever questions are answered
  Future<void> recordSolvedQuestions({
    required MathOperation operation,
    required int count,
  }) async {
    // Only increment if the operation matches today's mission
    if (operation != state.mission.targetOperation || state.isCompleted) return;

    final newProgress = (state.currentProgress + count).clamp(
      0,
      state.mission.targetCount,
    );
    state = DailyMissionState(
      mission: state.mission,
      currentProgress: newProgress,
      isClaimed: state.isClaimed,
    );

    await _box.put('daily_mission_progress', newProgress);
  }

  /// Claim the 50 Star Coins & Badge reward!
  Future<void> claimReward() async {
    if (!state.isCompleted || state.isClaimed) return;

    // 1. Award coins to active child profile
    await _ref
        .read(profileNotifierProvider.notifier)
        .addRewards(coins: state.mission.coinReward, xp: 100);

    // 2. Mark as claimed
    state = DailyMissionState(
      mission: state.mission,
      currentProgress: state.currentProgress,
      isClaimed: true,
    );
    await _box.put('daily_mission_claimed', true);
  }
}

final dailyMissionProvider =
    StateNotifierProvider<DailyMissionNotifier, DailyMissionState>((ref) {
      final box = Hive.box('app_settings_box');
      return DailyMissionNotifier(box, ref);
    });
