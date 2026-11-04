import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/all_badges_controller.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/all_badges_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/all_badges_screen.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('badges_test_');
    Hive.init(hiveDirectory.path);
    await Hive.openBox('app_settings_box');
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  testWidgets('renders state filters badges and opens detail bottom sheet', (
    tester,
  ) async {
    final controller = AllBadgesController(profile: null, badges: _badges);
    await _pumpScreen(tester, controller);

    expect(find.text('0 / 2'), findsOneWidget);
    expect(find.text('Speed Counter'), findsOneWidget);
    expect(find.text('Accuracy Ace'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(ChoiceChip),
        matching: find.text('SPEED'),
      ),
    );
    await tester.pump();
    expect(find.text('Speed Counter'), findsOneWidget);
    expect(find.text('Accuracy Ace'), findsNothing);

    await tester.tap(find.text('Speed Counter'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text('Locked'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('back action pops the badges route', (tester) async {
    final controller = AllBadgesController(profile: null, badges: _badges);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [allBadgesProvider.overrideWith((ref) => controller)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute(builder: (_) => const AllBadgesScreen()),
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

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Open'), findsOneWidget);
    expect(find.text('All Badges & Trophies'), findsNothing);
  });
}

Future<void> _pumpScreen(
  WidgetTester tester,
  AllBadgesController controller,
) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [allBadgesProvider.overrideWith((ref) => controller)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AllBadgesScreen(),
      ),
    ),
  );
  await tester.pump();
  expect(tester.takeException(), isNull);
}

final _badges = [
  _badge('speed', 'Speed Counter', 'SPEED', BadgeTier.gold),
  _badge('accuracy', 'Accuracy Ace', 'ACCURACY', BadgeTier.silver),
];

BadgeItem _badge(String id, String title, String category, BadgeTier tier) =>
    BadgeItem(
      id: id,
      title: title,
      description: 'Earn this badge.',
      icon: '🏅',
      category: category,
      tier: tier,
      isUnlockConditionMet: (_) => false,
    );
