import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/landing/landing_app.dart';
import 'package:math_quest/features/landing/services/landing_actions.dart';

class UnavailableActions implements LandingActions {
  final destinations = <Uri>[];
  @override
  Future<bool> open(Uri destination) async {
    destinations.add(destination);
    return false;
  }
}

Future<void> mount(
  WidgetTester tester, {
  Size size = const Size(1280, 900),
  String language = 'en',
  double scale = 1,
  UnavailableActions? actions,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(
    LandingApp(
      initialLocale: Locale(language),
      actions: actions ?? UnavailableActions(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('switching language translates the hero and navigation', (
    tester,
  ) async {
    await mount(tester);
    expect(find.text('Turn math into a'), findsOneWidget);
    await tester.tap(find.byKey(const Key('language-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Español').last);
    await tester.pumpAndSettle();
    expect(find.text('Convierte las matemáticas en una'), findsOneWidget);
    expect(find.text('Cómo aprende'), findsOneWidget);
  });

  for (final language in ['en', 'es', 'pt']) {
    testWidgets(
      'all sections fit a narrow screen with enlarged $language text',
      (tester) async {
        await mount(
          tester,
          size: const Size(360, 800),
          language: language,
          scale: 1.5,
        );
        final scroll = find.byKey(const Key('landing-scroll'));
        for (var i = 0; i < 15; i++) {
          await tester.drag(scroll, const Offset(0, -700));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
        expect(find.byKey(const Key('download-action')), findsOneWidget);
      },
    );
  }

  testWidgets(
    'hero and closing download actions open the supplied App Store listing',
    (tester) async {
      final actions = UnavailableActions();
      await mount(tester, actions: actions);
      await tester.tap(find.byKey(const Key('hero-action')));
      await tester.pumpAndSettle();
      expect(actions.destinations.map((uri) => uri.toString()), [
        'https://apps.apple.com/us/app/mathquest-kids-math-games/id6830852181',
      ]);
      final download = find.byKey(const Key('download-action'));
      await tester.ensureVisible(download);
      await tester.pumpAndSettle();
      await tester.tap(download);
      await tester.pumpAndSettle();
      expect(actions.destinations.length, 2);
      expect(
        actions.destinations.last.toString(),
        'https://apps.apple.com/us/app/mathquest-kids-math-games/id6830852181',
      );
      expect(
        find.text('Could not open the App Store. Please try again.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'contact opens support email with localized content and failure feedback',
    (tester) async {
      final actions = UnavailableActions();
      await mount(tester, actions: actions, language: 'es');
      final contact = find.byKey(const Key('contact-action'));
      await tester.ensureVisible(contact);
      await tester.pumpAndSettle();
      await tester.tap(contact);
      await tester.pumpAndSettle();
      final email = actions.destinations.single;
      expect(email.scheme, 'mailto');
      expect(email.path, 'me@christhoval.dev');
      expect(email.queryParameters['subject'], 'Soporte de MathQuest');
      expect(
        email.queryParameters['body'],
        '¡Hola! Necesito ayuda con MathQuest.',
      );
      expect(
        find.text(
          'No se pudo abrir tu correo. Escríbenos a me@christhoval.dev.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('gallery arrows advance and stop at the boundaries', (
    tester,
  ) async {
    await mount(tester);
    await tester.tap(find.byKey(const Key('nav-gallery')));
    await tester.pumpAndSettle();
    final previous = find.byKey(const Key('gallery-previous'));
    final next = find.byKey(const Key('gallery-next'));
    expect(tester.widget<IconButton>(previous).onPressed, isNull);
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(tester.widget<IconButton>(previous).onPressed, isNotNull);
    for (var i = 0; i < 12; i++) {
      if (tester.widget<IconButton>(next).onPressed == null) break;
      await tester.tap(next);
      await tester.pumpAndSettle();
    }
    expect(tester.widget<IconButton>(next).onPressed, isNull);
  });
}
