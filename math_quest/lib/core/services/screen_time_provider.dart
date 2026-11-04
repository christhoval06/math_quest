import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ScreenTimeState {
  final int limitMinutes; // 0 = Unlimited, 15, 30, 45
  final int todayUsedSeconds;
  final bool isLocked;

  const ScreenTimeState({
    required this.limitMinutes,
    required this.todayUsedSeconds,
    this.isLocked = false,
  });

  bool get hasReachedLimit =>
      limitMinutes > 0 && (todayUsedSeconds >= limitMinutes * 60);
}

class ScreenTimeNotifier extends StateNotifier<ScreenTimeState> {
  static const _supportedLimits = {0, 15, 30, 45};

  final Box _box;
  Timer? _activeTimer;

  ScreenTimeNotifier(this._box)
    : super(const ScreenTimeState(limitMinutes: 30, todayUsedSeconds: 0)) {
    _loadState();
    _startSessionTracking();
  }

  void _loadState() {
    final now = DateTime.now();
    final todayKey = 'screen_time_${now.year}_${now.month}_${now.day}';

    final storedLimit = _box.get('daily_screen_limit');
    final limit = storedLimit is int && _supportedLimits.contains(storedLimit)
        ? storedLimit
        : 30;
    final storedUsedSeconds = _box.get(todayKey);
    final usedSeconds = storedUsedSeconds is int && storedUsedSeconds >= 0
        ? storedUsedSeconds
        : 0;

    state = ScreenTimeState(
      limitMinutes: limit,
      todayUsedSeconds: usedSeconds,
      isLocked: limit > 0 && (usedSeconds >= limit * 60),
    );
  }

  void _startSessionTracking() {
    _activeTimer?.cancel();
    // ⏱️ Records 5 seconds of active usage every 5 seconds
    _activeTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (state.limitMinutes == 0) return; // Unlimited

      final newUsed = state.todayUsedSeconds + 5;
      final isNowLocked = newUsed >= (state.limitMinutes * 60);

      state = ScreenTimeState(
        limitMinutes: state.limitMinutes,
        todayUsedSeconds: newUsed,
        isLocked: isNowLocked,
      );

      // Save to Hive
      final now = DateTime.now();
      final todayKey = 'screen_time_${now.year}_${now.month}_${now.day}';
      _box.put(todayKey, newUsed);
    });
  }

  /// 🛡️ Called when a parent unlocks: grants +15 extra minutes!
  void grantExtraMinutes(int extraMinutes) {
    final newLimit = state.limitMinutes + extraMinutes;

    state = ScreenTimeState(
      limitMinutes: newLimit,
      todayUsedSeconds: state.todayUsedSeconds,
      isLocked: false,
    );
  }

  void updateLimitFromSettings(int limitMinutes) {
    state = ScreenTimeState(
      limitMinutes: limitMinutes,
      todayUsedSeconds: state.todayUsedSeconds,
      isLocked: limitMinutes > 0 && state.todayUsedSeconds >= limitMinutes * 60,
    );
  }

  @override
  void dispose() {
    _activeTimer?.cancel();
    super.dispose();
  }
}

final screenTimeProvider =
    StateNotifierProvider<ScreenTimeNotifier, ScreenTimeState>((ref) {
      final box = Hive.box('app_settings_box');
      return ScreenTimeNotifier(box);
    });
