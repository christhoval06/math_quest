import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';
import 'package:math_quest/features/gameplay/presentation/models/adventure_island_state.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/adventure_boss_banner.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/adventure_island_app_bar.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/adventure_level_map.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/adventure_path_connector.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/new_world_celebration_dialog.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('app bar renders current world and reports world selection', (
    tester,
  ) async {
    int? selected;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: AdventureIslandAppBar(
            activeWorldIndex: 2,
            currentWorldTitle: 'Factor Forest',
            currentWorldEmoji: '🌴',
            worlds: _worlds,
            onWorldSelected: (value) => selected = value,
          ),
        ),
      ),
    );

    expect(find.text('World 2: Factor Forest'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.map_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('World 1: Starter Shores'));

    expect(selected, 1);
  });

  testWidgets('boss banner preserves boss copy', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AdventureBossBanner(
            bossName: 'Number Beast',
            bossEmoji: '🐲',
            primaryColor: Colors.purple,
          ),
        ),
      ),
    );

    expect(find.text('🐲'), findsOneWidget);
    expect(find.text('Target Boss: Number Beast'), findsOneWidget);
  });

  testWidgets('level map uses path positions and reports unlocked taps', (
    tester,
  ) async {
    int? tapped;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AdventureLevelMap(
            levels: _levels,
            onLevelSelected: (level) => tapped = level.levelNumber,
          ),
        ),
      ),
    );

    final alignments = tester
        .widgetList<Align>(
          find.descendant(
            of: find.byType(AdventureLevelMap),
            matching: find.byType(Align),
          ),
        )
        .map((widget) => widget.alignment)
        .toList();
    expect(alignments, [Alignment.center, Alignment.centerRight]);

    await tester.tap(find.text('6'));
    expect(tapped, 6);
    await tester.tap(find.text('Locked Lagoon'));
    expect(tapped, 6);
  });

  testWidgets('path connector renders three dots', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: AdventurePathConnector()),
      ),
    );

    expect(find.byKey(const Key('adventure-path-dot-0')), findsOneWidget);
    expect(find.byKey(const Key('adventure-path-dot-1')), findsOneWidget);
    expect(find.byKey(const Key('adventure-path-dot-2')), findsOneWidget);
  });

  testWidgets('celebration renders copy and acknowledges', (tester) async {
    var acknowledged = false;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: NewWorldCelebrationDialog(
            celebration: const AdventureCelebrationViewData(
              worldName: 'Factor Forest',
              emoji: '🌴',
            ),
            onAcknowledge: () => acknowledged = true,
          ),
        ),
      ),
    );

    expect(find.text('WORLD BOSS DEFEATED!'), findsOneWidget);
    expect(find.text('Welcome to Factor Forest!'), findsOneWidget);
    await tester.tap(find.text('Explore New Island! 🚀'));
    expect(acknowledged, isTrue);
  });
}

const _worlds = [
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
];

const _levels = [
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
];
