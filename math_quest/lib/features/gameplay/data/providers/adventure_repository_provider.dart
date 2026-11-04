import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/features/gameplay/data/repositories/adventure_repository_impl.dart';
import 'package:math_quest/features/gameplay/data/sources/adventure_progress_store.dart';
import 'package:math_quest/features/gameplay/domain/repositories/i_adventure_repository.dart';

final adventureRepositoryProvider = Provider<IAdventureRepository>((ref) {
  final store = HiveAdventureProgressStore(
    Hive.box<dynamic>('app_settings_box'),
  );
  return AdventureRepositoryImpl(store);
});
