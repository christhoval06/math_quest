import 'package:hive/hive.dart';

import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/data/models/mastery_track_model.dart';

class UserProfileModel extends HiveObject {
  late String id;
  late String name;
  late String gradeLabel;
  late String avatar;
  late int level;
  late int starCoins;
  late int xp;
  late int currentStreak;
  late DateTime? lastActiveDate;
  late int dailyGoal;
  late Map<String, MasteryTrackModel> masteryTracks;
  late List<String> unlockedBadgeIds;

  UserProfile toDomain() {
    return UserProfile(
      id: id,
      name: name,
      gradeLabel: gradeLabel,
      avatar: avatar,
      level: level,
      starCoins: starCoins,
      xp: xp,
      currentStreak: currentStreak,
      lastActiveDate: lastActiveDate,
      dailyGoal: dailyGoal,
      masteryTracks: masteryTracks.map((k, v) => MapEntry(k, v.toDomain())),
      unlockedBadgeIds: unlockedBadgeIds,
    );
  }

  static UserProfileModel fromDomain(UserProfile entity) {
    return UserProfileModel()
      ..id = entity.id
      ..name = entity.name
      ..gradeLabel = entity.gradeLabel
      ..avatar = entity.avatar
      ..level = entity.level
      ..starCoins = entity.starCoins
      ..xp = entity.xp
      ..currentStreak = entity.currentStreak
      ..lastActiveDate = entity.lastActiveDate
      ..dailyGoal = entity.dailyGoal
      ..masteryTracks = entity.masteryTracks.map(
        (k, v) => MapEntry(k, MasteryTrackModel.fromDomain(v)),
      )
      ..unlockedBadgeIds = entity.unlockedBadgeIds;
  }
}

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 0;

  @override
  UserProfileModel read(BinaryReader reader) {
    return UserProfileModel()
      ..id = reader.readString()
      ..name = reader.readString()
      ..gradeLabel = reader.readString()
      ..avatar = reader.readString()
      ..level = reader.readInt()
      ..starCoins = reader.readInt()
      ..xp = reader.readInt()
      ..currentStreak = reader.readInt()
      ..lastActiveDate = reader.readBool()
          ? DateTime.fromMillisecondsSinceEpoch(reader.readInt())
          : null
      ..dailyGoal = reader.readInt()
      ..masteryTracks = (reader.readMap()).cast<String, MasteryTrackModel>()
      ..unlockedBadgeIds = reader.readStringList();
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.gradeLabel);
    writer.writeString(obj.avatar);
    writer.writeInt(obj.level);
    writer.writeInt(obj.starCoins);
    writer.writeInt(obj.xp);
    writer.writeInt(obj.currentStreak);
    writer.writeBool(obj.lastActiveDate != null);
    if (obj.lastActiveDate != null) {
      writer.writeInt(obj.lastActiveDate!.millisecondsSinceEpoch);
    }
    writer.writeInt(obj.dailyGoal);
    writer.writeMap(obj.masteryTracks);
    writer.writeStringList(obj.unlockedBadgeIds);
  }
}
