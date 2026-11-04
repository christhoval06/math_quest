import 'package:hive/hive.dart';

import 'package:math_quest/features/profile_and_stats/domain/repositories/i_onboarding_repository.dart';

class OnboardingRepositoryImpl implements IOnboardingRepository {
  static const _completedKey = 'has_seen_onboarding';

  final Box<dynamic> _settingsBox;

  OnboardingRepositoryImpl(this._settingsBox);

  @override
  Future<void> completeOnboarding() => _settingsBox.put(_completedKey, true);
}
