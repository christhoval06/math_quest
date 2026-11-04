import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/core/theme/visual_theme_model.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/game_modes_section.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/home_dashboard_app_bar.dart';
import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/all_badges_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/professional_badge_widget.dart';

void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets(
      'mode descriptions remain readable at 320px in ${locale.languageCode}',
      (tester) async {
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GameModesSection(
                    onQuickPlay: () {},
                    onPracticeArena: () {},
                    onAdventureIsland: () {},
                    onBuddyChallenge: () {},
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        for (final paragraph in tester.renderObjectList<RenderParagraph>(
          find.byType(RichText),
        )) {
          expect(
            paragraph.didExceedMaxLines,
            isFalse,
            reason: paragraph.text.toPlainText(),
          );
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final code in ['es', 'pt']) {
    testWidgets('badge ribbon uses the displayed language in $code', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(code),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Center(
              child: ProfessionalBadgeWidget(
                badge: BadgeViewData.fromItem(
                  BadgeItem.allBadges.firstWhere(
                    (badge) => badge.category == 'SPEED',
                  ),
                  isUnlocked: true,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('SPEED'), findsNothing);
      expect(
        find.text(code == 'es' ? 'VELOCIDAD' : 'VELOCIDADE'),
        findsOneWidget,
      );
    });
  }

  testWidgets('pale dashboard header requests dark status bar content on iOS', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: VisualThemePalette.getPalette(VisualThemeType.galaxyQuest)
            .toThemeData()
            .copyWith(platform: TargetPlatform.iOS),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: HomeDashboardAppBar(
            starCoins: 100,
            streakDays: 1,
            onSettings: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final styles = tester
        .widgetList<AnnotatedRegion<SystemUiOverlayStyle>>(
          find.byWidgetPredicate(
            (widget) => widget is AnnotatedRegion<SystemUiOverlayStyle>,
          ),
        )
        .map((region) => region.value);
    expect(styles.last.statusBarBrightness, Brightness.light);
    expect(styles.last.statusBarIconBrightness, Brightness.dark);
  });
}
