import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/create_profile_controller.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/create_profile_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/create_profile_screen.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('onboarding origin submits then replaces route with welcome', (
    tester,
  ) async {
    final events = <String>[];
    final controller = _controller(
      createProfileAction: (profile) async =>
          events.add('create:${profile.name}'),
      completeOnboardingAction: () async => events.add('complete'),
    );
    await _pumpScreen(
      tester,
      controller: controller,
      onRoute: (settings) => events.add('route:${settings.name}'),
    );

    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('create-profile-name')))
          .initialValue,
      isEmpty,
    );
    await tester.enterText(
      find.byKey(const Key('create-profile-name')),
      'Maya',
    );
    await tester.ensureVisible(find.text('Start My Adventure! 🚀'));
    await tester.pump();
    await tester.tap(find.text('Start My Adventure! 🚀'));
    await tester.pumpAndSettle();

    expect(events, ['create:Maya', 'complete', 'route:${AppRoutes.welcome}']);
  });

  testWidgets('settings origin pops and shows created-profile feedback', (
    tester,
  ) async {
    final controller = _controller();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [createProfileProvider.overrideWith((ref) => controller)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const CreateProfileScreen(isFromSettings: true),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('create-profile-name')),
      'Maya',
    );

    await tester.ensureVisible(find.text('Start My Adventure! 🚀'));
    await tester.pump();
    await tester.tap(find.text('Start My Adventure! 🚀'));
    await tester.pumpAndSettle();

    expect(find.text('Open'), findsOneWidget);
    expect(
      find.text('🎉 Welcome Maya! Profile created and active.'),
      findsOneWidget,
    );
  });

  testWidgets('submission failure stays on form and shows feedback', (
    tester,
  ) async {
    final controller = _controller(
      createProfileAction: (_) async => throw StateError('storage failed'),
    );
    await _pumpScreen(tester, controller: controller);

    await tester.ensureVisible(find.text('Start My Adventure! 🚀'));
    await tester.pump();
    await tester.tap(find.text('Start My Adventure! 🚀'));
    await tester.pumpAndSettle();

    expect(find.text('Create Your Hero!'), findsOneWidget);
    expect(
      find.text('Unable to create profile. Please try again.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets(
      'profile save failure preserves input and retries in ${locale.languageCode}',
      (tester) async {
        var attempts = 0;
        final names = <String>[];
        final controller = _controller(
          createProfileAction: (profile) async {
            names.add(profile.name);
            if (++attempts == 1) throw StateError('storage failed');
          },
        );
        await _pumpScreen(tester, controller: controller, locale: locale);
        await tester.enterText(
          find.byKey(const Key('create-profile-name')),
          'María',
        );
        final label = switch (locale.languageCode) {
          'es' => '¡Comenzar mi aventura! 🚀',
          'pt' => 'Começar minha aventura! 🚀',
          _ => 'Start My Adventure! 🚀',
        };
        final error = switch (locale.languageCode) {
          'es' => 'No se pudo crear el perfil. Inténtalo de nuevo.',
          'pt' => 'Não foi possível criar o perfil. Tente novamente.',
          _ => 'Unable to create profile. Please try again.',
        };
        await tester.ensureVisible(find.text(label));
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(find.text(error), findsOneWidget);
        expect(controller.state.name, 'María');
        expect(find.textContaining('storage failed'), findsNothing);
        // The error snackbar temporarily overlays the bottom submit button.
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(label));
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(names, ['María', 'María']);
        expect(find.text('Destination'), findsOneWidget);
      },
    );
  }
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  required CreateProfileController controller,
  ValueChanged<RouteSettings>? onRoute,
  Locale locale = const Locale('en'),
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [createProfileProvider.overrideWith((ref) => controller)],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CreateProfileScreen(),
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

CreateProfileController _controller({
  Future<void> Function(UserProfile)? createProfileAction,
  Future<void> Function()? completeOnboardingAction,
}) => CreateProfileController(
  createProfileAction: createProfileAction ?? (_) async {},
  completeOnboardingAction: completeOnboardingAction ?? () async {},
  now: () => DateTime(2026, 10, 23),
  createId: (_) => 'child-test',
);
