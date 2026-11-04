# Data Persistence & Schema Specification

**App:** MathQuest  
**Target Platforms:** iOS & Android (Offline-First)  
**Database Engine:** **Hive** (`hive_flutter`) — Lightweight, ultra-fast key-value/document store with zero native dependencies.

---

## 1. Storage Strategy & Architecture

To respect **Clean Architecture**, database-specific annotations (`@HiveType`, `@HiveField`) never leak into the **Domain Layer**.

```
┌────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                      │
│   Entities (Pure Dart, Immutable, Free of annotations)  │
│    • UserProfile   • MasteryTrack   • SessionRecord    │
└───────────────────────────▲────────────────────────────┘
                            │ toDomain() / fromDomain()
┌───────────────────────────┴────────────────────────────┐
│                       DATA LAYER                       │
│   Models / DTOs (Hive TypeAdapters, Serialization)     │
│    • UserProfileModel   • MasteryTrackModel            │
│                        │                               │
│                        ▼                               │
│              Local Hive Boxes (Disk)                   │
└────────────────────────────────────────────────────────┘
```

### 1.1 Local Boxes Partitioning
The app partitions storage into three dedicated Hive boxes:

1. **`app_settings_box`**: Global app settings, active profile ID, parental PIN hash, audio preferences.
2. **`user_profiles_box`**: Multi-child profile data (Leo, Mia), avatars, XP, Star Coins.
3. **`session_history_box`**: Historical logs of completed practices and exams (used for the weekly charts on Screen 6).

---

## 2. Domain Entities (Pure Dart)

Save in `lib/features/profile_and_stats/domain/entities/`:

### 2.1 `user_profile.dart`
```dart
class UserProfile {
  final String id;
  final String name;
  final String gradeLabel; // e.g., "Grade 2", "Kindergarten"
  final String avatarId;   // e.g., "star_leo", "star_mia"
  final int level;         // e.g., 4
  final int starCoins;     // e.g., 1420
  final int xp;            // e.g., 540
  final int currentStreak; // e.g., 7
  final DateTime? lastActiveDate;
  final int dailyGoal;     // e.g., 20 questions
  final int screenLimitMinutes; // e.g., 30 (From Screen 7)
  final Map<String, MasteryTrack> masteryTracks;
  final List<String> unlockedBadgeIds;

  const UserProfile({
    required this.id,
    required this.name,
    required this.gradeLabel,
    required this.avatarId,
    required this.level,
    required this.starCoins,
    required this.xp,
    required this.currentStreak,
    this.lastActiveDate,
    required this.dailyGoal,
    required this.screenLimitMinutes,
    required this.masteryTracks,
    required this.unlockedBadgeIds,
  });
}
```

### 2.2 `mastery_track.dart`
Matches the 4 progress tracks on **Screen 6**:
```dart
enum MathOperationType { addition, subtraction, multiplication, division }

class MasteryTrack {
  final MathOperationType operation;
  final int level;          // e.g., Level 5 "Master!"
  final String title;       // e.g., "Master!", "Superhero", "Rising Star"
  final int totalSolved;    // e.g., 520
  final double accuracy;    // e.g., 0.98 (98%)

  const MasteryTrack({
    required this.operation,
    required this.level,
    required this.title,
    required this.totalSolved,
    required this.accuracy,
  });
}
```

---

## 3. Data Layer Models & Hive Adapters

Save in `lib/features/profile_and_stats/data/models/`:

### 3.1 `user_profile_model.dart`
```dart
import 'package:hive/hive.dart';
import '../../domain/entities/user_profile.dart';
import 'mastery_track_model.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 0)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String gradeLabel;

  @HiveField(3)
  late String avatarId;

  @HiveField(4)
  late int level;

  @HiveField(5)
  late int starCoins;

  @HiveField(6)
  late int xp;

  @HiveField(7)
  late int currentStreak;

  @HiveField(8)
  late DateTime? lastActiveDate;

  @HiveField(9)
  late int dailyGoal;

  @HiveField(10)
  late int screenLimitMinutes;

  @HiveField(11)
  late Map<String, MasteryTrackModel> masteryTracks;

  @HiveField(12)
  late List<String> unlockedBadgeIds;

  UserProfile toDomain() {
    return UserProfile(
      id: id,
      name: name,
      gradeLabel: gradeLabel,
      avatarId: avatarId,
      level: level,
      starCoins: starCoins,
      xp: xp,
      currentStreak: currentStreak,
      lastActiveDate: lastActiveDate,
      dailyGoal: dailyGoal,
      screenLimitMinutes: screenLimitMinutes,
      masteryTracks: masteryTracks.map((k, v) => MapEntry(k, v.toDomain())),
      unlockedBadgeIds: unlockedBadgeIds,
    );
  }

  factory UserProfileModel.fromDomain(UserProfile entity) {
    return UserProfileModel()
      ..id = entity.id
      ..name = entity.name
      ..gradeLabel = entity.gradeLabel
      ..avatarId = entity.avatarId
      ..level = entity.level
      ..starCoins = entity.starCoins
      ..xp = entity.xp
      ..currentStreak = entity.currentStreak
      ..lastActiveDate = entity.lastActiveDate
      ..dailyGoal = entity.dailyGoal
      ..screenLimitMinutes = entity.screenLimitMinutes
      ..masteryTracks = entity.masteryTracks.map((k, v) => MapEntry(k, MasteryTrackModel.fromDomain(v)))
      ..unlockedBadgeIds = entity.unlockedBadgeIds;
  }
}
```

### 3.2 `mastery_track_model.dart`
```dart
import 'package:hive/hive.dart';
import '../../domain/entities/mastery_track.dart';

part 'mastery_track_model.g.dart';

@HiveType(typeId: 1)
class MasteryTrackModel extends HiveObject {
  @HiveField(0)
  late String operationKey; // "addition", "subtraction", etc.

  @HiveField(1)
  late int level;

  @HiveField(2)
  late String title;

  @HiveField(3)
  late int totalSolved;

  @HiveField(4)
  late double accuracy;

  MasteryTrack toDomain() {
    return MasteryTrack(
      operation: MathOperationType.values.byName(operationKey),
      level: level,
      title: title,
      totalSolved: totalSolved,
      accuracy: accuracy,
    );
  }

  factory MasteryTrackModel.fromDomain(MasteryTrack entity) {
    return MasteryTrackModel()
      ..operationKey = entity.operation.name
      ..level = entity.level
      ..title = entity.title
      ..totalSolved = entity.totalSolved
      ..accuracy = entity.accuracy;
  }
}
```

### 3.3 `session_record_model.dart`
Used for recording each mission to feed the **Weekly Practice Chart** (Screen 6):
```dart
import 'package:hive/hive.dart';

part 'session_record_model.g.dart';

@HiveType(typeId: 2)
class SessionRecordModel extends HiveObject {
  @HiveField(0)
  late String profileId;

  @HiveField(1)
  late DateTime timestamp;

  @HiveField(2)
  late int questionsSolved;

  @HiveField(3)
  late int correctCount;

  @HiveField(4)
  late int timeSpentSeconds;

  @HiveField(5)
  late String mode; // "practice" or "exam"
}
```

---

## 4. Streak Calculation Engine

The streak logic ensures fairness across time zones without penalizing children for midnight boundary crossovers.

```dart
class StreakEngine {
  /// Checks and calculates updated streak count based on current timestamp
  static int computeUpdatedStreak({
    required DateTime now,
    required DateTime? lastActiveDate,
    required int currentStreak,
  }) {
    if (lastActiveDate == null) return 1;

    final today = DateTime(now.year, now.month, now.day);
    final lastActiveDay = DateTime(
      lastActiveDate.year, 
      lastActiveDate.month, 
      lastActiveDate.day
    );

    final differenceInDays = today.difference(lastActiveDay).inDays;

    if (differenceInDays == 0) {
      // Already played today: maintain streak
      return currentStreak;
    } else if (differenceInDays == 1) {
      // Consecutive day: increment streak!
      return currentStreak + 1;
    } else {
      // Missed more than 1 calendar day: streak resets
      return 1;
    }
  }
}
```

---

## 5. Repository Contract & Implementation

### 5.1 Domain Interface (`i_profile_repository.dart`)
```dart
abstract class IProfileRepository {
  Future<List<UserProfile>> getAllProfiles();
  Future<UserProfile?> getActiveProfile();
  Future<void> setActiveProfile(String profileId);
  Future<void> saveProfile(UserProfile profile);
  Future<void> recordCompletedSession(SessionRecordModel session);
  Future<List<SessionRecordModel>> getWeeklyHistory(String profileId);
}
```

### 5.2 Implementation (`profile_repository_impl.dart`)
```dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../models/user_profile_model.dart';
import '../models/session_record_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final Box<UserProfileModel> _profileBox;
  final Box<SessionRecordModel> _sessionBox;
  final Box _settingsBox;

  ProfileRepositoryImpl({
    required Box<UserProfileModel> profileBox,
    required Box<SessionRecordModel> sessionBox,
    required Box settingsBox,
  })  : _profileBox = profileBox,
        _sessionBox = sessionBox,
        _settingsBox = settingsBox;

  @override
  Future<UserProfile?> getActiveProfile() async {
    final activeId = _settingsBox.get('active_profile_id') as String?;
    if (activeId == null) return null;
    final model = _profileBox.get(activeId);
    return model?.toDomain();
  }

  @override
  Future<void> setActiveProfile(String profileId) async {
    await _settingsBox.put('active_profile_id', profileId);
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    final model = UserProfileModel.fromDomain(profile);
    await _profileBox.put(profile.id, model);
  }

  @override
  Future<List<UserProfile>> getAllProfiles() async {
    return _profileBox.values.map((model) => model.toDomain()).toList();
  }

  @override
  Future<void> recordCompletedSession(SessionRecordModel session) async {
    await _sessionBox.add(session);
  }

  @override
  Future<List<SessionRecordModel>> getWeeklyHistory(String profileId) async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return _sessionBox.values
        .where((s) => s.profileId == profileId && s.timestamp.isAfter(sevenDaysAgo))
        .toList();
  }
}
```

---

## 6. Initialization & Seed Data

On first app boot, seed the repository with default mock profiles matching your proposal UI (*Leo* and *Mia*):

```dart
class DatabaseBootstrapper {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // 1. Register generated adapters
    Hive.registerAdapter(UserProfileModelAdapter());
    Hive.registerAdapter(MasteryTrackModelAdapter());
    Hive.registerAdapter(SessionRecordModelAdapter());

    // 2. Open partitioned boxes
    final profileBox = await Hive.openBox<UserProfileModel>('user_profiles_box');
    await Hive.openBox<SessionRecordModel>('session_history_box');
    final settingsBox = await Hive.openBox('app_settings_box');

    // 3. Seed default profiles if fresh install
    if (profileBox.isEmpty) {
      final defaultLeo = UserProfile(
        id: 'leo_profile_01',
        name: 'Leo',
        gradeLabel: 'Grade 2',
        avatarId: 'star_leo',
        level: 4,
        starCoins: 1420,
        xp: 540,
        currentStreak: 5,
        lastActiveDate: DateTime.now(),
        dailyGoal: 20,
        screenLimitMinutes: 30,
        masteryTracks: {
          'addition': const MasteryTrack(
            operation: MathOperationType.addition,
            level: 5,
            title: 'Master!',
            totalSolved: 520,
            accuracy: 0.98,
          ),
          'subtraction': const MasteryTrack(
            operation: MathOperationType.subtraction,
            level: 4,
            title: 'Superhero',
            totalSolved: 340,
            accuracy: 0.89,
          ),
        },
        unlockedBadgeIds: ['speed_counter', 'century_club'],
      );

      await profileBox.put(defaultLeo.id, UserProfileModel.fromDomain(defaultLeo));
      await settingsBox.put('active_profile_id', defaultLeo.id);
    }
  }
}
```
