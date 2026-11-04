import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/gameplay/domain/usecases/generate_adventure_world_usecase.dart';
import 'package:math_quest/features/gameplay/presentation/models/gameplay_localizations.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/feedback_sheet.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/quest_rewards_row.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/quest_stats_card.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/question_review_item.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/unlocked_badge_banner.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/written_answer_pad.dart';
import 'package:math_quest/features/math_engine/domain/entities/answer_submission.dart';
import 'package:math_quest/features/math_engine/domain/entities/exam_report.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  for (final code in ['es', 'pt']) {
    test(
      'adventure catalog translates without changing saved names in $code',
      () async {
        final l10n = await AppLocalizations.delegate.load(Locale(code));
        expect(
          localizedAdventureWorld(l10n, 'Emerald Atoll'),
          code == 'es' ? 'Atolón de esmeralda' : 'Atol de esmeralda',
        );
        final generator = GenerateAdventureWorldUseCase();
        for (var index = 1; index <= 10; index++) {
          final world = generator.execute(worldIndex: index);
          final originalName = world.theme.name;
          expect(
            localizedAdventureWorld(l10n, originalName),
            isNot(originalName),
          );
          expect(world.theme.name, originalName);
          expect(
            localizedAdventureLandmark(l10n, world.theme.bossName),
            isNot(world.theme.bossName),
          );
          for (final level in world.levels) {
            expect(
              localizedAdventureLandmark(l10n, level.title),
              isNot(level.title),
            );
          }
        }
        expect(
          localizedAdventureWorld(l10n, 'My Custom Island'),
          'My Custom Island',
        );
      },
    );

    testWidgets('badge rewards and mistake review fit a phone in $code', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final badge in BadgeItem.allBadges) {
        await tester.pumpWidget(
          _app(
            code,
            Padding(
              padding: const EdgeInsets.all(20),
              child: UnlockedBadgeBanner(badge: badge),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(badge.title), findsNothing, reason: badge.id);
        expect(find.text(badge.description), findsNothing, reason: badge.id);
      }
      const problem = MathProblem(
        num1: 24,
        num2: 38,
        operation: MathOperation.addition,
        correctAnswer: 62,
        options: [60, 61, 62, 63],
      );
      await tester.pumpWidget(
        _app(
          code,
          const QuestionReviewItem(
            submission: AnswerSubmission(
              problem: problem,
              selectedAnswer: 60,
              timeTaken: Duration(seconds: 3),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.text(code == 'es' ? 'Reintentar' : 'Tentar de novo'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('62'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          code == 'es'
              ? '🎉 ¡Genial! ¡Corregiste tu error!'
              : '🎉 Incrível! Você corrigiu seu erro!',
        ),
        findsOneWidget,
      );
    });

    testWidgets('feedback and results render in $code at phone width', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var continued = false;
      const report = ExamReport(
        correctCount: 8,
        totalQuestions: 10,
        totalDuration: Duration(seconds: 25),
        answers: [],
      );
      await tester.pumpWidget(
        _app(
          code,
          Column(
            children: [
              FeedbackSheet(
                isCorrect: false,
                correctAnswer: 42,
                onContinue: () => continued = true,
              ),
              const QuestStatsCard(report: report),
              const QuestRewardsRow(report: report),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          code == 'es'
              ? 'La respuesta correcta es 42'
              : 'A resposta correta é 42',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Continuar'));
      expect(continued, isTrue);
      expect(
        find.text(code == 'es' ? 'Respuestas Correctas' : 'Respostas Corretas'),
        findsOneWidget,
      );
    });
    testWidgets('checking status and retry are localized in $code', (
      tester,
    ) async {
      final pending = Completer<void>();
      var attempts = 0;
      await tester.pumpWidget(
        _app(
          code,
          WrittenAnswerPad(
            digitCount: 1,
            accentColor: Colors.indigo,
            showCheckingStatus: true,
            onSubmit: (_) {
              attempts++;
              return attempts == 1 ? pending.future : Future.value();
            },
          ),
        ),
      );
      await tester.tap(find.byKey(const Key('written-digit-4')));
      await tester.pump(const Duration(milliseconds: 450));
      await tester.pump(const Duration(milliseconds: 250));
      expect(
        find.bySemanticsLabel(
          code == 'es' ? 'Comprobando la respuesta' : 'Verificando a resposta',
        ),
        findsOneWidget,
      );
      pending.completeError(StateError('retry'));
      await tester.pump();
      await tester.tap(
        find.text(code == 'es' ? 'Intentar de nuevo' : 'Tentar novamente'),
      );
      await tester.pump();
      expect(attempts, 2);
    });
  }
}

Widget _app(String code, Widget child) => MaterialApp(
  locale: Locale(code),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);
