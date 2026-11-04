import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/core/storage/database_bootstrapper.dart';
import 'package:math_quest/features/profile_and_stats/data/repositories/profile_repository_impl.dart';
import 'package:math_quest/features/profile_and_stats/data/models/user_profile_model.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  const channel = MethodChannel('plugins.flutter.io/path_provider');

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('profile_bootstrap_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => directory.path);
  });

  tearDown(() async {
    await Hive.close();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await directory.delete(recursive: true);
  });

  test(
    'a new installation starts without profiles or an active profile',
    () async {
      await DatabaseBootstrapper.initialize();

      expect(Hive.box<UserProfileModel>('user_profiles_box').isEmpty, isTrue);
      expect(Hive.box('app_settings_box').get('active_profile_id'), isNull);
    },
  );

  test('startup preserves saved profiles and the active selection', () async {
    await DatabaseBootstrapper.initialize();
    final profiles = Hive.box<UserProfileModel>('user_profiles_box');
    final settings = Hive.box('app_settings_box');
    final profile = UserProfile(
      id: 'leo_01',
      name: 'Leo',
      gradeLabel: 'Grade 1',
      avatar: '🦊',
      level: 2,
      starCoins: 150,
      xp: 120,
      currentStreak: 1,
      dailyGoal: 10,
      masteryTracks: const {},
      unlockedBadgeIds: const [],
      lastActiveDate: DateTime(2026, 11, 4),
    );
    await profiles.put(profile.id, UserProfileModel.fromDomain(profile));
    await settings.put('active_profile_id', profile.id);
    await Hive.close();

    await DatabaseBootstrapper.initialize();

    final saved = Hive.box<UserProfileModel>('user_profiles_box');
    expect(saved.keys.toList(), [profile.id]);
    expect(saved.get(profile.id)!.name, 'Leo');
    expect(saved.get(profile.id)!.xp, 120);
    expect(Hive.box('app_settings_box').get('active_profile_id'), profile.id);
    final savedSettings = Hive.box('app_settings_box');
    await savedSettings.delete('active_profile_id');
    final repository = ProfileRepositoryImpl(
      profileBox: saved,
      settingsBox: savedSettings,
    );
    expect(await repository.getActiveProfile(), isNull);
    expect(saved.get(profile.id)!.name, 'Leo');
  });
}
