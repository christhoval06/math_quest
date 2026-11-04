import 'package:hive_flutter/hive_flutter.dart';

import 'package:math_quest/features/profile_and_stats/data/models/user_profile_model.dart';
import 'package:math_quest/features/profile_and_stats/data/models/mastery_track_model.dart';

class DatabaseBootstrapper {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // 1. Register Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProfileModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MasteryTrackModelAdapter());
    }

    // 2. Open Boxes
    await Hive.openBox<UserProfileModel>('user_profiles_box');
    await Hive.openBox('app_settings_box');
  }
}
