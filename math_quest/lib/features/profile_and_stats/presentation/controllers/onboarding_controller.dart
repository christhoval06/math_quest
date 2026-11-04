import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/profile_and_stats/presentation/models/onboarding_state.dart';

enum OnboardingAdvanceResult { advance, finish }

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController() : super(OnboardingState.initial());

  void selectPage(int page) {
    RangeError.checkValidIndex(page, state.slides, 'page');
    if (page == state.currentPage) return;
    state = state.withPage(page);
  }

  OnboardingAdvanceResult advance() {
    if (state.isLastPage) return OnboardingAdvanceResult.finish;
    state = state.withPage(state.currentPage + 1);
    return OnboardingAdvanceResult.advance;
  }
}
