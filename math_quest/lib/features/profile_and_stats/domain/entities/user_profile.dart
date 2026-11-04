import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';

class UserProfile {
  final String id;
  final String name;
  final String gradeLabel;
  final String avatar;
  final int level;
  final int starCoins;
  final int xp;
  final int currentStreak;
  final DateTime? lastActiveDate;
  final int dailyGoal;
  final Map<String, MasteryTrack> masteryTracks;
  final List<String> unlockedBadgeIds;

  const UserProfile({
    required this.id,
    required this.name,
    required this.gradeLabel,
    required this.avatar,
    required this.level,
    required this.starCoins,
    required this.xp,
    required this.currentStreak,
    this.lastActiveDate,
    required this.dailyGoal,
    required this.masteryTracks,
    required this.unlockedBadgeIds,
  });

  UserProfile copyWith({
    String? name,
    int? level,
    int? starCoins,
    int? xp,
    int? currentStreak,
    DateTime? lastActiveDate,
    Map<String, MasteryTrack>? masteryTracks,
    List<String>? unlockedBadgeIds,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      gradeLabel: gradeLabel,
      avatar: avatar,
      level: level ?? this.level,
      starCoins: starCoins ?? this.starCoins,
      xp: xp ?? this.xp,
      currentStreak: currentStreak ?? this.currentStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      dailyGoal: dailyGoal,
      masteryTracks: masteryTracks ?? this.masteryTracks,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
    );
  }
}
