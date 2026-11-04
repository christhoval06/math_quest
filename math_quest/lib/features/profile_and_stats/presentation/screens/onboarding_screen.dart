import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/onboarding_controller.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/onboarding_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/onboarding_widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: ref.read(onboardingProvider).currentPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: state.currentSlide.backgroundTint,
      body: SafeArea(
        child: ResponsiveContainer(
          child: Column(
            children: [
              OnboardingTopBar(onSkip: _finish),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: ref
                      .read(onboardingProvider.notifier)
                      .selectPage,
                  itemCount: state.slides.length,
                  itemBuilder: (context, index) =>
                      OnboardingSlide(slide: state.slides[index]),
                ),
              ),
              OnboardingFooter(state: state, onNext: _next),
            ],
          ),
        ),
      ),
    );
  }

  void _next() {
    final controller = ref.read(onboardingProvider.notifier);
    final result = controller.advance();
    if (result == OnboardingAdvanceResult.finish) {
      _finish();
      return;
    }

    _pageController.animateToPage(
      ref.read(onboardingProvider).currentPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _finish() {
    Navigator.pushReplacementNamed(context, AppRoutes.createProfile);
  }
}
