import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:math_quest/features/profile_and_stats/data/repositories/onboarding_repository_impl.dart';

void main() {
  late Directory hiveDirectory;
  late Box<dynamic> settingsBox;

  setUp(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('onboarding_repo_');
    Hive.init(hiveDirectory.path);
    settingsBox = await Hive.openBox<dynamic>('settings');
  });

  tearDown(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  test('completeOnboarding persists the completed flag', () async {
    final repository = OnboardingRepositoryImpl(settingsBox);

    await repository.completeOnboarding();

    expect(settingsBox.get('has_seen_onboarding'), isTrue);
  });
}
