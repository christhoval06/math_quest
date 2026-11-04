import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/onboarding_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/onboarding_widgets.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('slide renders presentation data', (tester) async {
    const slide = OnboardingSlideViewData(
      icon: '🧱',
      title: 'Visual Counting Blocks',
      description: 'Numbers become visible.',
      accentColor: Colors.blue,
      backgroundTint: Colors.white,
    );
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: OnboardingSlide(slide: slide)),
      ),
    );

    expect(find.text('🧱'), findsOneWidget);
    expect(find.text('Visual Counting Blocks'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Numbers become visible.'), findsOneWidget);
  });

  testWidgets('top bar and footer report skip and next actions', (
    tester,
  ) async {
    final events = <String>[];
    final state = OnboardingState.initial();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            children: [
              OnboardingTopBar(onSkip: () => events.add('skip')),
              OnboardingFooter(state: state, onNext: () => events.add('next')),
            ],
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('onboarding-dot-0-selected')), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.tap(find.text('Next'));

    expect(events, ['skip', 'next']);
  });
}
