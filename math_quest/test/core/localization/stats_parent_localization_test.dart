import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';
import 'package:math_quest/features/profile_and_stats/domain/services/mastery_progression_engine.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/all_badges_widgets.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/mastery_track_card.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/weekly_practice_chart_card.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/controllers/parent_gate_controller.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_config.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/parent_gate_widgets.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  for (final code in ['es', 'pt']) {
    testWidgets('translated badge filters preserve category IDs in $code', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        _app(
          code,
          AllBadgesCategoryFilter(
            categories: const ['ALL', 'SPEED', 'ACCURACY'],
            selectedCategory: 'ALL',
            primaryColor: Colors.blue,
            onSelected: (value) => selected = value,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(code == 'es' ? 'VELOCIDAD' : 'VELOCIDADE'));
      expect(selected, 'SPEED');
    });
    testWidgets('all mastery ranks and chart days fit a phone in $code', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final tier in MasteryProgressionEngine.tiers) {
        await tester.pumpWidget(
          _app(
            code,
            MasteryTrackCard(
              track: MasteryTrack(
                operation: MathOperationType.multiplication,
                level: tier.level,
                title: tier.title,
                totalSolved: tier.requiredSolved,
                accuracy: 0.85,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(code == 'es' ? 'MULTIPLICACIÓN' : 'MULTIPLICAÇÃO'),
          findsOneWidget,
        );
        expect(find.textContaining(tier.title), findsNothing);
      }
      await tester.pumpWidget(
        _app(
          code,
          const WeeklyPracticeChartCard(
            weeklyData: {'Mon': 7, 'Tue': 25},
            primaryColor: Colors.blue,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(code == 'es' ? 'Lun' : 'Seg'), findsOneWidget);
      final data = tester.widget<BarChart>(find.byType(BarChart)).data;
      expect(data.barGroups.first.barRods.first.toY, 7);
      expect(data.barGroups[1].barRods.first.toY, 25);
    });
    testWidgets('parent verification translates prompts and errors in $code', (
      tester,
    ) async {
      final controller = ParentGateController(
        const ParentGateChallenge(firstFactor: 7, secondFactor: 8),
      );
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(code),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: StatefulBuilder(
            builder: (context, update) => ParentGateView(
              config: ParentGateConfig.screenLimit,
              state: controller.state,
              onAnswerChanged: (value) =>
                  update(() => controller.setAnswer(value)),
              onSubmit: () => update(() {
                controller.verify();
              }),
              onCancel: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          code == 'es' ? '¿Cuánto es siete × ocho?' : 'Quanto é sete × oito?',
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(find.byKey(const Key('parent-gate-submit')));
      await tester.tap(find.byKey(const Key('parent-gate-submit')));
      await tester.pumpAndSettle();
      expect(
        find.text(
          code == 'es'
              ? 'Escribe una respuesta para continuar.'
              : 'Digite uma resposta para continuar.',
        ),
        findsOneWidget,
      );
      await tester.enterText(find.byKey(const Key('parent-gate-answer')), '56');
      await tester.ensureVisible(find.byKey(const Key('parent-gate-submit')));
      await tester.tap(find.byKey(const Key('parent-gate-submit')));
      await tester.pumpAndSettle();
      expect(controller.state.isVerified, isTrue);
    });
  }
}

Widget _app(String code, Widget child) => MaterialApp(
  locale: Locale(code),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: child,
    ),
  ),
);
