import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/gameplay/presentation/providers/quest_complete_provider.dart';
import 'package:math_quest/features/gameplay/presentation/screens/quest_complete_screen.dart';
import 'package:math_quest/features/math_engine/domain/entities/answer_submission.dart';
import 'package:math_quest/features/math_engine/domain/entities/exam_report.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets(
      'results and mistake actions fit a phone in ${locale.languageCode}',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        const answer = AnswerSubmission(
          problem: MathProblem(
            num1: 24,
            num2: 38,
            operation: MathOperation.addition,
            correctAnswer: 62,
            options: [60, 61, 62, 63],
          ),
          selectedAnswer: 60,
          timeTaken: Duration(seconds: 3),
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              questCompleteProvider.overrideWith(
                (ref) => _TestQuestCompleteViewModel(ref),
              ),
            ],
            child: MaterialApp(
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const QuestCompleteScreen(
                report: ExamReport(
                  correctCount: 0,
                  totalQuestions: 1,
                  totalDuration: Duration(seconds: 3),
                  answers: [answer],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final label = switch (locale.languageCode) {
          'es' => 'Revisar 1 error 🎯',
          'pt' => 'Revisar 1 erro 🎯',
          _ => 'Review 1 Mistake 🎯',
        };
        await tester.ensureVisible(find.text(label));
        expect(find.text(label), findsOneWidget);
      },
    );
  }

  testWidgets('confetti falls across a full-screen non-interactive overlay', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    late final _TestQuestCompleteViewModel viewModel;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          questCompleteProvider.overrideWith(
            (ref) => viewModel = _TestQuestCompleteViewModel(ref),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: QuestCompleteScreen(
            report: ExamReport(
              correctCount: 1,
              totalQuestions: 1,
              totalDuration: Duration(seconds: 2),
              answers: [],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final overlay = find.byKey(const Key('quest-complete-confetti-overlay'));
    final screenStack = find.ancestor(
      of: find.text('Quest Complete!'),
      matching: find.byType(Stack),
    );
    expect(overlay, findsOneWidget);
    expect(screenStack, findsOneWidget);
    expect(tester.getSize(overlay), tester.getSize(screenStack));
    final pointerGuards = tester.widgetList<IgnorePointer>(
      find.ancestor(of: overlay, matching: find.byType(IgnorePointer)),
    );
    expect(pointerGuards.where((guard) => guard.ignoring), hasLength(1));

    final bursts = tester.widgetList<ConfettiWidget>(
      find.byType(ConfettiWidget),
    );
    expect(bursts, hasLength(2));
    expect(
      bursts.map((burst) => burst.blastDirectionality),
      everyElement(BlastDirectionality.directional),
    );
    expect(
      bursts.map((burst) => burst.blastDirection),
      containsAll(<double>[math.pi / 4, 3 * math.pi / 4]),
    );
    expect(
      bursts.every(
        (burst) =>
            identical(burst.confettiController, viewModel.confettiController),
      ),
      isTrue,
    );

    for (final alignment in [Alignment.topLeft, Alignment.topRight]) {
      final alignedBurst = find.descendant(
        of: overlay,
        matching: find.byWidgetPredicate(
          (widget) => widget is Align && widget.alignment == alignment,
        ),
      );
      expect(alignedBurst, findsOneWidget);
      expect(
        find.descendant(
          of: alignedBurst,
          matching: find.byType(ConfettiWidget),
        ),
        findsOneWidget,
      );
    }

    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
  });
}

class _TestQuestCompleteViewModel extends QuestCompleteViewModel {
  _TestQuestCompleteViewModel(super.ref);

  @override
  void initializeSession({required ExamReport report, int? levelNumber}) {
    confettiController.play();
  }
}
