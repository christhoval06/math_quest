import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/features/profile_and_stats/data/repositories/daily_practice_progress.dart';

import 'package:math_quest/features/profile_and_stats/data/models/user_profile_model.dart';
import 'package:math_quest/features/profile_and_stats/data/repositories/profile_repository_impl.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/domain/repositories/i_profile_repository.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';
import 'package:math_quest/features/profile_and_stats/domain/services/mastery_progression_engine.dart';

final practiceClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    profileBox: Hive.box<UserProfileModel>('user_profiles_box'),
    settingsBox: Hive.box('app_settings_box'),
  );
});

// Provides all saved child profiles from Hive
final allProfilesProvider = FutureProvider<List<UserProfile>>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getAllProfiles();
});

class ProfileNotifier extends StateNotifier<UserProfile?> {
  final IProfileRepository _repository;
  final Ref _ref;

  ProfileNotifier(this._repository, this._ref) : super(null) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    final profile = await _repository.getActiveProfile();
    state = profile;
    _ref.invalidate(allProfilesProvider); // Refreshes the all-profiles list
  }

  // 🔄 SWITCH ACTIVE PROFILE
  Future<void> switchProfile(String profileId) async {
    await _repository.setActiveProfileId(profileId);
    await loadProfile();
  }

  // ➕ CREATE AND SAVE NEW PROFILE
  Future<void> createProfile(UserProfile newProfile) async {
    await _repository.saveProfile(newProfile);
    await switchProfile(newProfile.id);
  }

  Future<void> addRewards({required int coins, required int xp}) async {
    if (state == null) return;
    final updated = state!.copyWith(
      starCoins: state!.starCoins + coins,
      xp: state!.xp + xp,
    );
    state = updated;
    await _repository.saveProfile(updated);
    _ref.invalidate(allProfilesProvider);
  }

  Future<void> incrementStreak() async {
    if (state == null) return;
    final updated = state!.copyWith(
      currentStreak: state!.currentStreak + 1,
      lastActiveDate: DateTime.now(),
    );
    state = updated;
    await _repository.saveProfile(updated);
    _ref.invalidate(allProfilesProvider);
  }

  /// 🏅 UNLOCK BADGES & AWARD BONUS COINS
  Future<void> unlockBadges(List<String> badgeIds) async {
    if (state == null || badgeIds.isEmpty) return;

    final updatedBadges = Set<String>.from(state!.unlockedBadgeIds)
      ..addAll(badgeIds);

    // Reward +100 Star Coins for each newly earned badge!
    final bonusCoins = badgeIds.length * 100;

    final updatedProfile = state!.copyWith(
      unlockedBadgeIds: updatedBadges.toList(),
      starCoins: state!.starCoins + bonusCoins,
    );

    state = updatedProfile;
    await _repository.saveProfile(updatedProfile); // 💾 Saved to Hive!
    _ref.invalidate(allProfilesProvider);
  }

  // 📈 RECORD REAL SESSION PROGRESS INTO MASTERY TRACKS & WEEKLY CHART
  Future<void> recordSessionProgress({
    required MathOperationType operation,
    required int solvedCount,
    required int correctCount,
  }) async {
    if (state == null || solvedCount <= 0) return;

    final opKey = operation.name;
    final currentTracks = Map<String, MasteryTrack>.from(state!.masteryTracks);
    final existingTrack =
        currentTracks[opKey] ??
        MasteryTrack(
          operation: operation,
          level: 1,
          title: 'Explorer',
          totalSolved: 0,
          accuracy: 1.0,
        );

    // 1. Calculate new totals & accuracy
    final newTotalSolved = existingTrack.totalSolved + solvedCount;
    final newAccuracy = newTotalSolved == 0
        ? 1.0
        : (((existingTrack.totalSolved * existingTrack.accuracy) +
                      correctCount) /
                  newTotalSolved)
              .clamp(0.0, 1.0);

    // 🌟 2. USE THE 10-LEVEL MASTERY ENGINE!
    final tier = MasteryProgressionEngine.getTierForSolvedCount(newTotalSolved);

    currentTracks[opKey] = existingTrack.copyWith(
      totalSolved: newTotalSolved,
      accuracy: newAccuracy,
      level: tier.level, // 👈 1 to 10!
      title: tier.title, // 👈 "Sprout Explorer", "Rising Star", etc.
    );

    // 🌟 3. ALSO UPDATE CHILD'S GLOBAL HERO LEVEL BASED ON XP
    final globalHeroTier = MasteryProgressionEngine.getTierForXp(state!.xp);

    // 4. Save Day-of-Week progress for the Weekly Bar Chart (Mon = 0, Sun = 6)
    final now = _ref.read(practiceClockProvider)();
    final dayIndex = now.weekday - 1;
    final box = Hive.box('app_settings_box');
    final weeklyMap = Map<String, int>.from(
      box.get('weekly_chart_data', defaultValue: {}) as Map,
    );
    weeklyMap[dayIndex.toString()] =
        (weeklyMap[dayIndex.toString()] ?? 0) + solvedCount;
    await box.put('weekly_chart_data', weeklyMap);
    await DailyPracticeProgress(box).record(state!.id, now, solvedCount);

    // 5. Persist updated profile to Hive
    final updatedProfile = state!.copyWith(
      masteryTracks: currentTracks,
      level: globalHeroTier.level, // 👈 Updates child's profile level!
    );

    state = updatedProfile;
    await _repository.saveProfile(updatedProfile);
    _ref.invalidate(allProfilesProvider);
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile?>((ref) {
      final repo = ref.watch(profileRepositoryProvider);
      return ProfileNotifier(repo, ref);
    });
