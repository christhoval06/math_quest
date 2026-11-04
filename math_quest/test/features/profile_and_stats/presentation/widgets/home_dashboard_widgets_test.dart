import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/explorer_banner.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/game_modes_section.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/home_dashboard_app_bar.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/superpower_tip_card.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('app bar renders counters and invokes settings', (tester) async {
    var settingsCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: HomeDashboardAppBar(
            starCoins: 875,
            streakDays: 12,
            onSettings: () => settingsCount++,
          ),
        ),
      ),
    );

    expect(find.text('875'), findsOneWidget);
    expect(find.text('12d'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.settings_rounded));

    expect(settingsCount, 1);
  });

  testWidgets('explorer banner renders stats and invokes trophy room', (
    tester,
  ) async {
    var trophyCount = 0;
    await tester.pumpWidget(
      _body(
        ExplorerBanner(
          primaryColor: Colors.blue,
          secondaryColor: Colors.orange,
          borderColor: Colors.grey,
          streakDays: 12,
          stars: 340,
          level: 7,
          onOpenTrophyRoom: () => trophyCount++,
        ),
      ),
    );

    expect(find.text('12 Days'), findsOneWidget);
    expect(find.text('340'), findsOneWidget);
    expect(find.text('Lvl 7'), findsOneWidget);
    await tester.tap(find.text('340'));

    expect(trophyCount, 1);
  });

  testWidgets('game modes invoke their matching callbacks', (tester) async {
    final taps = <String>[];
    await tester.pumpWidget(
      _body(
        GameModesSection(
          onQuickPlay: () => taps.add('quick'),
          onPracticeArena: () => taps.add('practice'),
          onAdventureIsland: () => taps.add('adventure'),
          onBuddyChallenge: () => taps.add('buddy'),
        ),
      ),
    );

    for (final entry in <(String, String)>[
      ('Quick Play', 'quick'),
      ('Practice Arena', 'practice'),
      ('Adventure Island', 'adventure'),
      ('Buddy Challenge', 'buddy'),
    ]) {
      await tester.tap(find.text(entry.$1));
      await tester.pump();
      expect(taps.last, entry.$2);
    }
    expect(taps.length, 4);
  });

  testWidgets('superpower card renders mapped tip and invokes launch', (
    tester,
  ) async {
    var launchCount = 0;
    await tester.pumpWidget(
      _body(
        SuperpowerTipCard(
          data: const SuperpowerTipViewData(
            icon: '🧠',
            title: 'Test trick',
            description: 'A mapped challenge description.',
          ),
          onLaunch: () => launchCount++,
        ),
      ),
    );

    expect(find.text('Test trick'), findsOneWidget);
    expect(find.text('A mapped challenge description.'), findsOneWidget);
    await tester.tap(find.text('Try it in your next challenge! →'));

    expect(launchCount, 1);
  });
}

Widget _body(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SizedBox(width: 700, child: child)),
  );
}
