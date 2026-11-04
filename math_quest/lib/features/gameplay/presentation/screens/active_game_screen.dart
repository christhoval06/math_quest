import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/core/haptics/haptic_provider.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/theme/theme_provider.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/features/gameplay/presentation/models/gameplay_localizations.dart';
import 'package:math_quest/features/gameplay/presentation/providers/active_game_provider.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/active_game_app_bar.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/active_game_problem_card.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/answer_options_grid.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/game_mascot_bar.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/game_stage_badge.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/written_answer_pad.dart';
import 'package:math_quest/features/math_engine/domain/entities/exam_report.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/providers/settings_provider.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class ActiveGameScreen extends ConsumerStatefulWidget {
  final int? levelNumber;
  final String? stageTitle;
  final int timerSeconds;
  final bool isExamMode;
  final List<MathOperation> allowedOperations;
  final int totalQuestions;
  final bool preservePreparedSession;
  final bool visualAidsEnabled;
  final bool soundEnabled;

  const ActiveGameScreen({
    super.key,
    this.levelNumber,
    this.stageTitle,
    this.timerSeconds = 0,
    this.isExamMode = false,
    this.allowedOperations = const [MathOperation.addition],
    this.totalQuestions = 10,
    this.preservePreparedSession = false,
    this.visualAidsEnabled = true,
    this.soundEnabled = true,
  });

  @override
  ConsumerState<ActiveGameScreen> createState() => _ActiveGameScreenState();
}

class _ActiveGameScreenState extends ConsumerState<ActiveGameScreen> {
  late final ActiveGameConfig _config;

  @override
  void initState() {
    super.initState();
    _config = ActiveGameConfig(
      levelNumber: widget.levelNumber,
      stageTitle: widget.stageTitle,
      timerSeconds: widget.timerSeconds,
      isExamMode: widget.isExamMode,
      allowedOperations: widget.allowedOperations,
      totalQuestions: widget.totalQuestions,
      preservePreparedSession: widget.preservePreparedSession,
      visualAidsEnabled: widget.visualAidsEnabled,
      soundEnabled: widget.soundEnabled,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(activeGameControllerProvider(_config)).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(visualThemeProvider);
    final state = ref.watch(activeGameProvider(_config));
    final responseMode = ref.watch(responseModeProvider);

    ref.listen(activeGameProvider(_config), (previous, next) {
      final report = next.completedReport;
      if (report == null || identical(previous?.completedReport, report)) {
        return;
      }
      _navigateToResults(report);
    });

    return Scaffold(
      backgroundColor: theme.background,
      appBar: ActiveGameAppBar(
        backgroundColor: theme.background,
        progressFraction: state.progressFraction,
        answeredCount: state.answeredCount,
        totalQuestions: state.totalQuestions,
        isTimerVisible: state.isTimerVisible,
        formattedTime: state.formattedTime,
        isTimerDanger: state.isTimerDanger,
        currentStreak: state.currentStreak,
        primaryColor: theme.primary,
        onBack: () => Navigator.maybePop(context),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewport) => ResponsiveContainer(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: viewport.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 8),
                    GameStageBadge(
                      label: state.isExamMode
                          ? AppLocalizations.of(context)!.examStageLabel(
                              (state.answeredCount + 1).clamp(
                                1,
                                state.totalQuestions,
                              ),
                              state.totalQuestions,
                            )
                          : widget.stageTitle != null
                          ? localizedAdventureLandmark(
                              AppLocalizations.of(context)!,
                              widget.stageTitle!,
                            ).toUpperCase()
                          : AppLocalizations.of(context)!.operationAdventure(
                              localizedOperationName(
                                AppLocalizations.of(context)!,
                                state.problem.operation,
                              ).toUpperCase(),
                            ),
                      isExamMode: state.isExamMode,
                      primaryColor: theme.primary,
                    ),
                    const SizedBox(height: 12),
                    ActiveGameProblemCard(
                      problem: state.problem,
                      showVisualAids: state.showVisualAids,
                      isExamMode: state.isExamMode,
                    ),
                    Center(
                      child: Text(
                        responseMode == ResponseMode.choice
                            ? AppLocalizations.of(context)!.tapCorrectAnswer
                            : AppLocalizations.of(context)!.writeCorrectAnswer,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (responseMode == ResponseMode.choice)
                      AnswerOptionsGrid(
                        options: state.options,
                        correctAnswer: state.problem.correctAnswer,
                        selectedAnswer: state.selectedAnswer,
                        isEvaluating: state.isEvaluating,
                        isExamMode: state.isExamMode,
                        onAnswer: (answer) => ref
                            .read(activeGameControllerProvider(_config))
                            .submitAnswer(answer),
                      )
                    else
                      WrittenAnswerPad(
                        key: ObjectKey(state.problem),
                        digitCount: state.problem.correctAnswer
                            .toString()
                            .length,
                        enabled: !state.isEvaluating,
                        accentColor: theme.primary,
                        feedback: _writtenFeedback(state),
                        onInputFeedback: () => unawaited(
                          ref.read(hapticServiceProvider).selection(),
                        ),
                        onSubmit: (answer) => ref
                            .read(activeGameControllerProvider(_config))
                            .submitAnswer(answer),
                      ),
                    const GameMascotBar(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  WrittenAnswerFeedback _writtenFeedback(ActiveGameState state) {
    if (state.isExamMode ||
        !state.isEvaluating ||
        state.selectedAnswer == null) {
      return WrittenAnswerFeedback.neutral;
    }
    return state.selectedAnswer == state.problem.correctAnswer
        ? WrittenAnswerFeedback.correct
        : WrittenAnswerFeedback.incorrect;
  }

  void _navigateToResults(ExamReport report) {
    if (!mounted) return;
    ref.read(activeGameControllerProvider(_config)).clearCompletedReport();
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.questComplete,
      arguments: QuestCompleteArgs(
        report: report,
        levelNumber: widget.levelNumber,
        timerSeconds: widget.timerSeconds,
      ),
    );
  }
}
