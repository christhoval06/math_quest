import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/home_dashboard_screen.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('dashboard_test_');
    Hive.init(hiveDirectory.path);
    await Hive.openBox('app_settings_box');
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  testWidgets('renders dashboard state and scrolls to the mapped tip', (
    tester,
  ) async {
    await _pumpScreen(tester, state: _state(DailyMissionStatus.claimed));

    expect(find.text('875'), findsOneWidget);
    expect(find.text('12d'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Test trick'), 300);

    expect(find.text('Test trick'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('claims through the controller and shows reward feedback', (
    tester,
  ) async {
    var claimCount = 0;
    final controller = _controller(
      claimRewardAction: () async {
        claimCount++;
        return const ClaimedMissionReward(
          coinReward: 50,
          badgeRewardTitle: 'Test Badge',
        );
      },
    );
    await _pumpScreen(
      tester,
      state: _state(DailyMissionStatus.readyToClaim),
      controller: controller,
    );

    await tester.tap(find.text('Claim 50 Coins & Badge! 🎁'));
    await tester.pumpAndSettle();

    expect(claimCount, 1);
    expect(
      find.text('🎁 +50 Star Coins and Test Badge added!'),
      findsOneWidget,
    );
  });

  testWidgets('prepares the daily mission before active-game navigation', (
    tester,
  ) async {
    final events = <String>[];
    await _pumpScreen(
      tester,
      state: _state(DailyMissionStatus.inProgress),
      controller: _controller(
        prepareMissionAction: () {
          events.add('prepare-mission');
          return const PreparedDashboardSession(MathOperation.subtraction);
        },
      ),
      onRoute: (settings) {
        events.add('route:${settings.name}');
        final args = settings.arguments! as ActiveGameArgs;
        expect(args.preservePreparedSession, isTrue);
        expect(args.allowedOperations, [MathOperation.subtraction]);
      },
    );

    await tester.tap(find.text('Continue Mission'));
    await tester.pumpAndSettle();

    expect(events, ['prepare-mission', 'route:${AppRoutes.activeGame}']);
  });

  testWidgets('prepares the challenge before active-game navigation', (
    tester,
  ) async {
    final events = <String>[];
    await _pumpScreen(
      tester,
      state: _state(DailyMissionStatus.claimed),
      controller: _controller(
        prepareChallengeAction: () {
          events.add('prepare-challenge');
          return const PreparedDashboardSession(MathOperation.multiplication);
        },
      ),
      onRoute: (settings) {
        events.add('route:${settings.name}');
        final args = settings.arguments! as ActiveGameArgs;
        expect(args.preservePreparedSession, isTrue);
        expect(args.allowedOperations, [MathOperation.multiplication]);
      },
    );
    await tester.scrollUntilVisible(
      find.text('Try it in your next challenge! →'),
      300,
    );

    await tester.tap(find.text('Try it in your next challenge! →'));
    await tester.pumpAndSettle();

    expect(events, ['prepare-challenge', 'route:${AppRoutes.activeGame}']);
  });
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('dashboard fits 390x844 in ${locale.languageCode}', (
      tester,
    ) async {
      await _pumpScreen(
        tester,
        state: _state(DailyMissionStatus.inProgress),
        locale: locale,
      );
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -700),
      );
      await tester.pumpAndSettle();
    });
  }
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  required HomeDashboardState state,
  HomeDashboardController? controller,
  ValueChanged<RouteSettings>? onRoute,
  Locale locale = const Locale('en'),
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        homeDashboardProvider.overrideWithValue(state),
        homeDashboardControllerProvider.overrideWithValue(
          controller ?? _controller(),
        ),
      ],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeDashboardScreen(),
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
}

HomeDashboardController _controller({
  Future<ClaimedMissionReward> Function()? claimRewardAction,
  PreparedDashboardSession Function()? prepareMissionAction,
  PreparedDashboardSession Function()? prepareChallengeAction,
}) {
  return HomeDashboardController(
    claimRewardAction:
        claimRewardAction ??
        () async => const ClaimedMissionReward(
          coinReward: 50,
          badgeRewardTitle: 'Test Badge',
        ),
    prepareMissionAction:
        prepareMissionAction ??
        () => const PreparedDashboardSession(MathOperation.addition),
    prepareChallengeAction:
        prepareChallengeAction ??
        () => const PreparedDashboardSession(MathOperation.addition),
  );
}

HomeDashboardState _state(DailyMissionStatus status) {
  return HomeDashboardState(
    starCoins: 875,
    streakDays: 12,
    level: 7,
    mission: DailyMissionViewData(
      title: 'Solve 10 Addition Puzzles',
      coinReward: 50,
      badgeRewardTitle: 'Test Badge',
      currentProgress: status == DailyMissionStatus.inProgress ? 3 : 10,
      targetCount: 10,
      progressFraction: status == DailyMissionStatus.inProgress ? 0.3 : 1,
      progressPercent: status == DailyMissionStatus.inProgress ? 30 : 100,
      status: status,
    ),
    tip: const SuperpowerTipViewData(
      icon: '🧠',
      title: 'Test trick',
      description: 'A mapped challenge description.',
    ),
  );
}
