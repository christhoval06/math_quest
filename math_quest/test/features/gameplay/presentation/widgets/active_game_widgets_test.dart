import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/active_game_app_bar.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/active_game_problem_card.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/answer_options_grid.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/game_mascot_bar.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/game_stage_badge.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  const problem = MathProblem(
    num1: 6,
    num2: 7,
    operation: MathOperation.multiplication,
    correctAnswer: 42,
    options: [42, 36, 48, 49],
  );

  testWidgets('app bar renders progress timer and streak and invokes back', (
    tester,
  ) async {
    var backCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: ActiveGameAppBar(
            backgroundColor: Colors.white,
            progressFraction: 0.2,
            answeredCount: 2,
            totalQuestions: 10,
            isTimerVisible: true,
            formattedTime: '00:09',
            isTimerDanger: true,
            currentStreak: 3,
            primaryColor: const Color(0xFF2563EB),
            onBack: () => backCount++,
          ),
        ),
      ),
    );

    expect(find.text('2/10'), findsOneWidget);
    expect(find.text('00:09'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0.2,
    );

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    expect(backCount, 1);
  });

  testWidgets('stage badge renders its mapped label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GameStageBadge(
            label: 'EXAM CHALLENGE (1/10)',
            isExamMode: true,
            primaryColor: Color(0xFF2563EB),
          ),
        ),
      ),
    );

    expect(find.text('EXAM CHALLENGE (1/10)'), findsOneWidget);
  });

  testWidgets('problem card hides visual aid in exam mode', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ActiveGameProblemCard(
            problem: problem,
            showVisualAids: true,
            isExamMode: true,
          ),
        ),
      ),
    );

    expect(find.text('6 × 7 = ?'), findsOneWidget);
    expect(find.text('Tens'), findsNothing);
  });

  testWidgets('answer grid invokes the matching option without providers', (
    tester,
  ) async {
    int? selected;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AnswerOptionsGrid(
            options: problem.options,
            correctAnswer: problem.correctAnswer,
            selectedAnswer: null,
            isEvaluating: false,
            isExamMode: false,
            onAnswer: (answer) => selected = answer,
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('D'), findsOneWidget);
    await tester.tap(find.text('42'));

    expect(selected, 42);
  });

  testWidgets('mascot bar renders the existing hint', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: GameMascotBar()),
      ),
    );

    expect(
      find.text('Sparky says: Take your time and think it through!'),
      findsOneWidget,
    );
  });
}
