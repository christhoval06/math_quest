import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/all_badges_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/all_badges_widgets.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('category filter reports the selected category', (tester) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AllBadgesCategoryFilter(
            categories: const ['ALL', 'SPEED'],
            selectedCategory: 'ALL',
            primaryColor: Colors.blue,
            onSelected: (category) => selected = category,
          ),
        ),
      ),
    );

    await tester.tap(find.text('SPEED'));

    expect(selected, 'SPEED');
  });

  testWidgets('badge grid reports the tapped presentation row', (tester) async {
    BadgeViewData? tapped;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AllBadgesGrid(
            badges: const [_unlockedBadge, _lockedBadge],
            onBadgeTap: (badge) => tapped = badge,
          ),
        ),
      ),
    );

    expect(find.text('Speed Counter'), findsOneWidget);
    expect(find.text('Unlocked'), findsOneWidget);
    expect(find.text('Locked'), findsOneWidget);
    await tester.tap(find.text('Accuracy Ace'));

    expect(tapped?.id, 'accuracy');
  });

  testWidgets('detail content renders status and invokes close', (
    tester,
  ) async {
    var closeCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BadgeDetailContent(
            badge: _unlockedBadge,
            onClose: () => closeCount++,
          ),
        ),
      ),
    );

    expect(find.text('Unlocked'), findsOneWidget);
    expect(find.text('Answer quickly.'), findsOneWidget);
    await tester.tap(find.text('Got it!'));

    expect(closeCount, 1);
  });
}

const _unlockedBadge = BadgeViewData(
  id: 'speed',
  title: 'Speed Counter',
  description: 'Answer quickly.',
  icon: '⏱️',
  category: 'SPEED',
  tier: BadgeTier.gold,
  isUnlocked: true,
);

const _lockedBadge = BadgeViewData(
  id: 'accuracy',
  title: 'Accuracy Ace',
  description: 'Answer accurately.',
  icon: '🎯',
  category: 'ACCURACY',
  tier: BadgeTier.silver,
  isUnlocked: false,
);
