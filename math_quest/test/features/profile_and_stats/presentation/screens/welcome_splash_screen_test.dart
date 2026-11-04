import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/welcome_splash_controller.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/welcome_splash_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/welcome_splash_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/welcome_splash_screen.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('renders state and launch plays tap before replacing routes', (
    tester,
  ) async {
    final harness = _Harness(_state());
    await tester.pumpWidget(harness.app(withMainRoute: true));

    expect(find.text('Hi Leo!'), findsOneWidget);
    expect(find.text('12 Day Streak!'), findsOneWidget);
    expect(find.text('875'), findsOneWidget);

    await tester.tap(find.text('Tap to Start Adventure!'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));

    expect(harness.soundCount, 1);
    expect(find.text('Main shell'), findsOneWidget);
  });

  testWidgets('synchronous sound failure does not block launch navigation', (
    tester,
  ) async {
    final harness = _Harness(_state())..soundThrowsSynchronously = true;
    await tester.pumpWidget(harness.app(withMainRoute: true));

    await tester.tap(find.text('Tap to Start Adventure!'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 400));

    expect(harness.soundCount, 1);
    expect(find.text('Main shell'), findsOneWidget);
  });

  testWidgets('profile sheet renders loading error and data states', (
    tester,
  ) async {
    for (final status in WelcomeProfilesStatus.values) {
      final harness = _Harness(_state(status: status));
      await tester.pumpWidget(harness.app());
      await tester.tap(find.text('Hi Leo!'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      final key = status == WelcomeProfilesStatus.data
          ? const Key('welcome-profile-leo')
          : Key('welcome-profiles-${status.name}');
      expect(find.byKey(key), findsOneWidget);
      expect(harness.soundCount, 1);
    }
  });

  testWidgets('successful profile switch closes the sheet', (tester) async {
    final harness = _Harness(_state());
    await tester.pumpWidget(harness.app());
    await tester.tap(find.text('Hi Leo!'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Mia'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(harness.switchCalls, ['mia']);
    expect(find.text("Who's Playing?"), findsNothing);
  });

  testWidgets('failed switch keeps the sheet open and shows feedback', (
    tester,
  ) async {
    final harness = _Harness(_state())..failProfileId = 'mia';
    await tester.pumpWidget(harness.app());
    await tester.tap(find.text('Hi Leo!'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Mia'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(harness.switchCalls, ['mia', 'leo']);
    expect(find.text("Who's Playing?"), findsOneWidget);
    expect(
      find.text('Could not switch profiles. Please try again.'),
      findsOneWidget,
    );
  });

  testWidgets('active profile selection is a no-op and closes the sheet', (
    tester,
  ) async {
    final harness = _Harness(_state());
    await tester.pumpWidget(harness.app());
    await tester.tap(find.text('Hi Leo!'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Leo').last);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(harness.switchCalls, isEmpty);
    expect(find.text("Who's Playing?"), findsNothing);
  });

  testWidgets('add profile navigates with the welcome origin flag', (
    tester,
  ) async {
    final harness = _Harness(_state());
    await tester.pumpWidget(harness.app(withCreateRoute: true));
    await tester.tap(find.text('Hi Leo!'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Add New Child Profile'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));

    expect(harness.createProfileArgument, isFalse);
    expect(find.text('Create profile'), findsOneWidget);
  });

  testWidgets('animations advance and dispose cleanly', (tester) async {
    final harness = _Harness(_state());
    await tester.pumpWidget(harness.app());

    expect(find.text('0%'), findsOneWidget);
    final initialTransform = tester.widget<Transform>(
      find.byKey(const Key('welcome-brand-float')),
    );
    final initialOffset = initialTransform.transform.getTranslation().y;

    await tester.pump(const Duration(milliseconds: 1400));
    expect(find.text('100%'), findsOneWidget);
    final laterTransform = tester.widget<Transform>(
      find.byKey(const Key('welcome-brand-float')),
    );
    expect(laterTransform.transform.getTranslation().y, isNot(initialOffset));

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SizedBox(),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('welcome fits 390x844 in ${locale.languageCode}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final harness = _Harness(_state());

      await tester.pumpWidget(harness.app(locale: locale));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.takeException(), isNull);
    });
  }
}

class _Harness {
  _Harness(this.state) {
    controller = WelcomeSplashController(
      readActiveProfileId: () => activeId,
      playTapAction: () {
        soundCount++;
        if (soundThrowsSynchronously) {
          throw StateError('audio unavailable');
        }
        return Future<void>.value();
      },
      switchProfileAction: (profileId) async {
        switchCalls.add(profileId);
        activeId = profileId;
        if (profileId == failProfileId) throw StateError('switch failed');
      },
    );
  }

  final WelcomeSplashState state;
  late final WelcomeSplashController controller;
  String? activeId = 'leo';
  String? failProfileId;
  int soundCount = 0;
  bool soundThrowsSynchronously = false;
  final List<String> switchCalls = [];
  Object? createProfileArgument;

  Widget app({
    bool withMainRoute = false,
    bool withCreateRoute = false,
    Locale locale = const Locale('en'),
  }) {
    return ProviderScope(
      key: ValueKey(controller),
      overrides: [
        welcomeSplashProvider.overrideWithValue(state),
        welcomeSplashControllerProvider.overrideWithValue(controller),
      ],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const WelcomeSplashScreen(),
        routes: withMainRoute
            ? {
                AppRoutes.mainShell: (_) =>
                    const Scaffold(body: Text('Main shell')),
              }
            : const {},
        onGenerateRoute: withCreateRoute
            ? (settings) {
                if (settings.name == AppRoutes.createProfile) {
                  createProfileArgument = settings.arguments;
                  return MaterialPageRoute<void>(
                    builder: (_) =>
                        const Scaffold(body: Text('Create profile')),
                  );
                }
                return null;
              }
            : null,
      ),
    );
  }
}

WelcomeSplashState _state({
  WelcomeProfilesStatus status = WelcomeProfilesStatus.data,
}) {
  return WelcomeSplashState(
    activeProfileId: 'leo',
    name: 'Leo',
    gradeLabel: 'Grade 2',
    avatar: '🚀',
    starCoins: 875,
    currentStreak: 12,
    profilesStatus: status,
    profiles: status == WelcomeProfilesStatus.data ? _profiles : const [],
    profilesErrorMessage: status == WelcomeProfilesStatus.error
        ? 'profiles failed'
        : null,
    canAddProfile: true,
  );
}

const _profiles = [
  WelcomeProfileViewData(
    id: 'leo',
    name: 'Leo',
    gradeLabel: 'Grade 2',
    avatar: '🚀',
    starCoins: 875,
    isActive: true,
  ),
  WelcomeProfileViewData(
    id: 'mia',
    name: 'Mia',
    gradeLabel: 'Grade 1',
    avatar: '🦄',
    starCoins: 320,
    isActive: false,
  ),
];
