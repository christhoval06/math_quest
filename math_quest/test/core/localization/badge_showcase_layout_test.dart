import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/badge_grid_card.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/badge_detail_bottom_sheet.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/all_badges_widgets.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/all_badges_state.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/badge_showcase_section.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  for (final code in ['en', 'es', 'pt']) {
    testWidgets('recent badges use full width and readable titles in $code', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var openedGallery = false;
      await tester.pumpWidget(
        _app(code, onGallery: () => openedGallery = true),
      );
      await tester.pumpAndSettle();
      final heading = find.text(switch (code) {
        'es' => 'Insignias Recientes',
        'pt' => 'Emblemas Recentes',
        _ => 'Recent Badges',
      });
      expect(tester.getTopLeft(heading).dx, 16);
      final action = find.text(switch (code) {
        'es' => 'Ver todas (20)',
        'pt' => 'Ver todos (20)',
        _ => 'View All (20)',
      });
      final actionTarget = find
          .ancestor(of: action, matching: find.byType(InkWell))
          .first;
      expect(tester.getRect(actionTarget).right, closeTo(304, 1));
      for (final paragraph in tester.renderObjectList<RenderParagraph>(
        find.descendant(
          of: find.byType(BadgeGridCard),
          matching: find.byType(RichText),
        ),
      )) {
        expect(
          paragraph.didExceedMaxLines,
          isFalse,
          reason: paragraph.text.toPlainText(),
        );
      }
      await tester.tap(action);
      await tester.pumpAndSettle();
      expect(openedGallery, isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'badge information opens as a dismissible bottom sheet in $code',
      (tester) async {
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(_app(code));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(BadgeGridCard).first);
        await tester.pumpAndSettle();
        expect(find.byType(BottomSheet), findsOneWidget);
        expect(find.byType(AlertDialog), findsNothing);
        final description = switch (code) {
          'es' => 'Responde 5 preguntas en menos de 5 segundos cada una en una ronda.',
          'pt' =>
            'Responda 5 perguntas em menos de 5 segundos cada em uma rodada.',
          _ => 'Answer 5 questions under 5 seconds each in one round.',
        };
        expect(find.text(description), findsOneWidget);
        // The actual description remains visible as scrollable, localized content.
        expect(
          find.descendant(
            of: find.byType(BottomSheet),
            matching: find.byType(SingleChildScrollView),
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining('SPEED'),
          code == 'en' ? findsWidgets : findsNothing,
        );
        final close = find.text(switch (code) {
          'es' => '¡Entendido!',
          'pt' => 'Entendi!',
          _ => 'Got it!',
        });
        await tester.ensureVisible(close);
        await tester.tap(close);
        await tester.pumpAndSettle();
        expect(find.byType(BottomSheet), findsNothing);
        expect(find.text(description), findsNothing);
        await tester.tap(find.byType(BadgeGridCard).first);
        await tester.pumpAndSettle();
        final sheetRect = tester.getRect(find.byType(BottomSheet));
        await tester.flingFrom(
          Offset(sheetRect.center.dx, sheetRect.top + 20),
          const Offset(0, 600),
          1500,
        );
        await tester.pumpAndSettle();
        expect(find.byType(BottomSheet), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets(
    'long badge details scroll on a short screen with a full-width close action',
    (tester) async {
      tester.view.physicalSize = const Size(320, 400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final badge = BadgeViewData(
        id: 'custom',
        title: 'A very long custom achievement title that must wrap',
        description: List.filled(
          20,
          'Complete practice rounds to earn this custom achievement.',
        ).join(' '),
        icon: '🏆',
        category: 'MASTERY',
        tier: BadgeTier.gold,
        isUnlocked: true,
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(1.3)),
            child: child!,
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showBadgeDetailBottomSheet(context, badge),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text(badge.title), findsOneWidget);
      expect(find.text(badge.description), findsOneWidget);
      expect(find.text('Unlocked'), findsOneWidget);
      final close = find.text('Got it!');
      await tester.ensureVisible(close);
      await tester.pumpAndSettle();
      final action = find.ancestor(
        of: close,
        matching: find.byType(ElevatedButton),
      );
      expect(tester.getSize(action).width, closeTo(272, 1));
      await tester.tap(close);
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('badge artwork stays inside narrow cards with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final badges = BadgeItem.allBadges
        .where(
          (badge) =>
              badge.category == 'MILESTONE' || badge.category == 'ADVENTURE',
        )
        .take(2)
        .map((badge) => BadgeViewData.fromItem(badge, isUnlocked: true))
        .toList();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: AllBadgesGrid(badges: badges, onBadgeTap: (_) {}),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

Widget _app(String code, {VoidCallback? onGallery}) => MaterialApp(
  locale: Locale(code),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  routes: {
    '/all-badges': (_) {
      onGallery?.call();
      return const Scaffold(body: Text('Gallery'));
    },
  },
  home: const Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: BadgeShowcaseSection(
          unlockedBadgeIds: ['lightning_math'],
          primaryColor: Colors.blue,
        ),
      ),
    ),
  ),
);
