import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/profile_and_stats/data/providers/onboarding_repository_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/create_profile_controller.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/create_profile_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';

final createProfileProvider =
    StateNotifierProvider.autoDispose<
      CreateProfileController,
      CreateProfileState
    >((ref) {
      return CreateProfileController(
        createProfileAction: ref
            .read(profileNotifierProvider.notifier)
            .createProfile,
        completeOnboardingAction: ref
            .read(onboardingRepositoryProvider)
            .completeOnboarding,
        now: DateTime.now,
        createId: (timestamp) => 'child_${timestamp.millisecondsSinceEpoch}',
      );
    });
