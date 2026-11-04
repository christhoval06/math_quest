import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:math_quest/features/settings_and_parent_gate/data/repositories/settings_repository_impl.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/repositories/i_settings_repository.dart';

final settingsRepositoryProvider = Provider<ISettingsRepository>((ref) {
  return SettingsRepositoryImpl(Hive.box<dynamic>('app_settings_box'));
});
