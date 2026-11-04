import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/onboarding_controller.dart';

void main() {
  test('initial state exposes immutable slides and first-page content', () {
    final controller = OnboardingController();

    expect(controller.state.currentPage, 0);
    expect(controller.state.currentSlide.title, 'Welcome to MathQuest!');
    expect(controller.state.isLastPage, isFalse);
    expect(controller.state.slides.length, 3);
    expect(
      () => controller.state.slides.add(controller.state.slides.first),
      throwsUnsupportedError,
    );
  });

  test('selectPage synchronizes a valid drag and rejects invalid indexes', () {
    final controller = OnboardingController();

    controller.selectPage(1);

    expect(controller.state.currentPage, 1);
    expect(controller.state.currentSlide.title, 'Visual Counting Blocks');
    expect(() => controller.selectPage(-1), throwsRangeError);
    expect(() => controller.selectPage(3), throwsRangeError);
    expect(controller.state.currentPage, 1);
  });

  test('advance selects the next page until the final slide', () {
    final controller = OnboardingController();

    final first = controller.advance();
    final second = controller.advance();

    expect(first, OnboardingAdvanceResult.advance);
    expect(second, OnboardingAdvanceResult.advance);
    expect(controller.state.currentPage, 2);
    expect(controller.state.isLastPage, isTrue);
    expect(controller.state.primaryActionLabel, 'Get Started 🚀');
  });

  test('advance on final slide returns finish without changing state', () {
    final controller = OnboardingController()..selectPage(2);

    final result = controller.advance();

    expect(result, OnboardingAdvanceResult.finish);
    expect(controller.state.currentPage, 2);
  });
}
