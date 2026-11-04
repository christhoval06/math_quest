import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:math_quest/features/profile_and_stats/data/repositories/onboarding_repository_impl.dart';
import 'package:math_quest/features/profile_and_stats/domain/repositories/i_onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<IOnboardingRepository>((ref) {
  return OnboardingRepositoryImpl(Hive.box<dynamic>('app_settings_box'));
});
