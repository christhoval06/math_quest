import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/onboarding_controller.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/onboarding_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/onboarding_screen.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('next and swipe synchronize visible and provider pages', (
    tester,
  ) async {
    final controller = OnboardingController();
    await _pumpScreen(tester, controller: controller);

    expect(find.text('Welcome to MathQuest!'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(controller.state.currentPage, 1);
    expect(find.text('Visual Counting Blocks'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(controller.state.currentPage, 2);
    expect(find.text('Defeat Bosses & Win Trophies'), findsOneWidget);
    expect(find.text('Get Started 🚀'), findsOneWidget);
  });

  testWidgets('skip replaces onboarding with create profile route', (
    tester,
  ) async {
    final routes = <String?>[];
    await _pumpScreen(
      tester,
      controller: OnboardingController(),
      onRoute: (settings) => routes.add(settings.name),
    );

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(routes, [AppRoutes.createProfile]);
    expect(find.text('Destination'), findsOneWidget);
  });

  testWidgets(
    'final action replaces onboarding and controller disposes cleanly',
    (tester) async {
      final routes = <String?>[];
      final controller = OnboardingController()..selectPage(2);
      await _pumpScreen(
        tester,
        controller: controller,
        onRoute: (settings) => routes.add(settings.name),
      );

      await tester.tap(find.text('Get Started 🚀'));
      await tester.pumpAndSettle();

      expect(routes, [AppRoutes.createProfile]);
      expect(tester.takeException(), isNull);
    },
  );
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets(
      'all onboarding pages fit and navigate in ${locale.languageCode}',
      (tester) async {
        final controller = OnboardingController();
        final routes = <String?>[];
        await _pumpScreen(
          tester,
          controller: controller,
          locale: locale,
          onRoute: (settings) => routes.add(settings.name),
        );
        final titles = switch (locale.languageCode) {
          'es' => [
            '¡Bienvenido a MathQuest!',
            'Bloques visuales para contar',
            'Derrota jefes y gana trofeos',
          ],
          'pt' => [
            'Boas-vindas ao MathQuest!',
            'Blocos visuais para contar',
            'Derrote chefes e ganhe troféus',
          ],
          _ => [
            'Welcome to MathQuest!',
            'Visual Counting Blocks',
            'Defeat Bosses & Win Trophies',
          ],
        };
        final next = switch (locale.languageCode) {
          'es' => 'Siguiente',
          'pt' => 'Próximo',
          _ => 'Next',
        };
        final start = switch (locale.languageCode) {
          'es' => 'Comenzar 🚀',
          'pt' => 'Começar 🚀',
          _ => 'Get Started 🚀',
        };
        for (var index = 0; index < 3; index++) {
          await tester.pump(const Duration(seconds: 6));
          expect(find.text(titles[index]), findsOneWidget);
          expect(
            find.byKey(Key('onboarding-dot-$index-selected')),
            findsOneWidget,
          );
          await tester.tap(find.text(index == 2 ? start : next));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 400));
        }
        expect(routes, [AppRoutes.createProfile]);
      },
    );
  }
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  required OnboardingController controller,
  ValueChanged<RouteSettings>? onRoute,
  Locale locale = const Locale('en'),
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [onboardingProvider.overrideWith((ref) => controller)],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const OnboardingScreen(),
        onGenerateRoute: (settings) {
          onRoute?.call(settings);
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const Scaffold(body: Text('Destination')),
          );
        },
      ),
    ),
  );
  await tester.pump();
  expect(tester.takeException(), isNull);
}
