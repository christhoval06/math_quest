import 'package:hive/hive.dart';

import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';

class MasteryTrackModel extends HiveObject {
  late String operationKey;
  late int level;
  late String title;
  late int totalSolved;
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

  static MasteryTrackModel fromDomain(MasteryTrack entity) {
    return MasteryTrackModel()
      ..operationKey = entity.operation.name
      ..level = entity.level
      ..title = entity.title
      ..totalSolved = entity.totalSolved
      ..accuracy = entity.accuracy;
  }
}

class MasteryTrackModelAdapter extends TypeAdapter<MasteryTrackModel> {
  @override
  final int typeId = 1;

  @override
  MasteryTrackModel read(BinaryReader reader) {
    return MasteryTrackModel()
      ..operationKey = reader.readString()
      ..level = reader.readInt()
      ..title = reader.readString()
      ..totalSolved = reader.readInt()
      ..accuracy = reader.readDouble();
  }

  @override
  void write(BinaryWriter writer, MasteryTrackModel obj) {
    writer.writeString(obj.operationKey);
    writer.writeInt(obj.level);
    writer.writeString(obj.title);
    writer.writeInt(obj.totalSolved);
    writer.writeDouble(obj.accuracy);
  }
}
