import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/profile_and_stats/presentation/controllers/onboarding_controller.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/onboarding_state.dart';

final onboardingProvider =
    StateNotifierProvider.autoDispose<OnboardingController, OnboardingState>(
      (ref) => OnboardingController(),
    );
