import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';
import 'package:math_quest/features/gameplay/presentation/controllers/adventure_island_controller.dart';
import 'package:math_quest/features/gameplay/presentation/models/adventure_island_state.dart';
import 'package:math_quest/features/gameplay/presentation/providers/adventure_island_provider.dart';
import 'package:math_quest/features/gameplay/presentation/screens/adventure_island_screen.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  test('adventure game args preserve a prepared non-addition session', () {
    const session = PreparedAdventureSession(
      levelNumber: 7,
      title: 'Times Tower',
      operation: MathOperation.multiplication,
      difficulty: DifficultyLevel.medium,
    );

    final args = buildAdventureGameArgs(session);

    expect(args.levelNumber, 7);
    expect(args.stageTitle, 'Times Tower');
    expect(args.timerSeconds, 0);
    expect(args.allowedOperations, [MathOperation.multiplication]);
    expect(args.preservePreparedSession, isTrue);
  });

  testWidgets('renders provider state and delegates world switching', (
    tester,
  ) async {
    final harness = _Harness(_state());
    await tester.pumpWidget(harness.app());

    expect(find.text('World 2: Factor Forest'), findsOneWidget);
    expect(find.text('Target Boss: Number Beast'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.map_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('World 1: Starter Shores'));

    expect(harness.switchedWorlds, [1]);
  });

  testWidgets('prepares the session before active-game navigation', (
    tester,
  ) async {
    final harness = _Harness(_state());
    await tester.pumpWidget(harness.app());

    await tester.tap(find.text('6'));
    await tester.pumpAndSettle();

    expect(harness.events, ['reset', 'navigate']);
    expect(harness.navigatedArgs?.levelNumber, 6);
    expect(harness.navigatedArgs?.allowedOperations, [
      MathOperation.multiplication,
    ]);
  });

  testWidgets('locked levels do not navigate', (tester) async {
    final harness = _Harness(_state());
    await tester.pumpWidget(harness.app());

    await tester.tap(find.byIcon(Icons.lock_rounded));
    await tester.pump();

    expect(harness.navigatedArgs, isNull);
    expect(harness.events, isEmpty);
  });

  testWidgets('pending celebration opens once and acknowledges once', (
    tester,
  ) async {
    final harness = _Harness(_state(withCelebration: true));
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    expect(find.text('WORLD BOSS DEFEATED!'), findsOneWidget);
    await tester.pump();
    expect(find.text('WORLD BOSS DEFEATED!'), findsOneWidget);

    await tester.tap(find.text('Explore New Island! 🚀'));
    await tester.pumpAndSettle();

    expect(harness.clearCount, 1);
    expect(find.text('WORLD BOSS DEFEATED!'), findsNothing);

    await tester.pump();
    expect(find.text('WORLD BOSS DEFEATED!'), findsNothing);
  });

  testWidgets('unacknowledged celebration is shown again after remount', (
    tester,
  ) async {
    final harness = _Harness(_state(withCelebration: true));
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();
    expect(find.text('WORLD BOSS DEFEATED!'), findsOneWidget);

    Navigator.of(tester.element(find.text('WORLD BOSS DEFEATED!'))).pop();
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SizedBox(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pumpWidget(harness.app());
    await tester.pumpAndSettle();

    expect(find.text('WORLD BOSS DEFEATED!'), findsOneWidget);
    expect(harness.clearCount, 0);
  });

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets(
      'renders without overflow at 390x844 in ${locale.languageCode}',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final harness = _Harness(_state());

        await tester.pumpWidget(harness.app(locale: locale));
        await tester.pump();

        expect(tester.takeException(), isNull);
      },
    );
  }
}

class _Harness {
  _Harness(this.state) {
    controller = AdventureIslandController(
      readState: () => state,
      switchWorldAction: switchedWorlds.add,
      clearNotificationAction: () => clearCount++,
      resetPracticeSessionAction: ({required operation, required difficulty}) {
        events.add('reset');
      },
    );
  }

  final AdventureIslandState state;
  final List<int> switchedWorlds = [];
  final List<String> events = [];
  late final AdventureIslandController controller;
  int clearCount = 0;
  ActiveGameArgs? navigatedArgs;

  Widget app({Locale locale = const Locale('en')}) {
    return ProviderScope(
      overrides: [
        adventureIslandProvider.overrideWithValue(state),
        adventureIslandControllerProvider.overrideWithValue(controller),
      ],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AdventureIslandScreen(),
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.activeGame) {
            events.add('navigate');
            navigatedArgs = settings.arguments! as ActiveGameArgs;
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: Text('Active game')),
            );
          }
          return null;
        },
      ),
    );
  }
}

AdventureIslandState _state({bool withCelebration = false}) {
  return AdventureIslandState(
    activeWorldIndex: 2,
    currentWorldTitle: 'Factor Forest',
    currentWorldEmoji: '🌴',
    primaryColor: Colors.green,
    backgroundColor: const Color(0xFFF0FDF4),
    bossName: 'Number Beast',
    bossEmoji: '🐲',
    worlds: const [
      AdventureWorldOptionViewData(
        worldIndex: 1,
        title: 'Starter Shores',
        emoji: '🌱',
        isSelected: false,
      ),
      AdventureWorldOptionViewData(
        worldIndex: 2,
        title: 'Factor Forest',
        emoji: '🌴',
        isSelected: true,
      ),
    ],
    levels: const [
      AdventureLevelViewData(
        levelNumber: 6,
        title: 'Coral Gate',
        status: LevelStatus.active,
        stars: 0,
        operation: MathOperation.multiplication,
        difficulty: DifficultyLevel.medium,
        isBoss: false,
        pathPosition: AdventurePathPosition.center,
      ),
      AdventureLevelViewData(
        levelNumber: 7,
        title: 'Locked Lagoon',
        status: LevelStatus.locked,
        stars: 0,
        operation: MathOperation.multiplication,
        difficulty: DifficultyLevel.medium,
        isBoss: false,
        pathPosition: AdventurePathPosition.right,
      ),
    ],
    celebration: withCelebration
        ? const AdventureCelebrationViewData(
            worldName: 'Factor Forest',
            emoji: '🌴',
          )
        : null,
  );
}
