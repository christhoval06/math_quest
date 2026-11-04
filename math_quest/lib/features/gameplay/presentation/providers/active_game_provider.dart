import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/core/audio/sound_provider.dart';
import 'package:math_quest/core/haptics/haptic_provider.dart';
import 'package:math_quest/features/math_engine/domain/entities/answer_submission.dart';
import 'package:math_quest/features/math_engine/domain/entities/exam_report.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_notifier.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_state.dart';

class ActiveGameConfig {
  final int? levelNumber;
  final String? stageTitle;
  final int timerSeconds;
  final bool isExamMode;
  final List<MathOperation> allowedOperations;
  final int totalQuestions;
  final bool preservePreparedSession;
  final bool visualAidsEnabled;
  final bool soundEnabled;

  ActiveGameConfig({
    this.levelNumber,
    this.stageTitle,
    this.timerSeconds = 0,
    this.isExamMode = false,
    List<MathOperation> allowedOperations = const [MathOperation.addition],
    this.totalQuestions = 10,
    this.preservePreparedSession = false,
    this.visualAidsEnabled = true,
    this.soundEnabled = true,
  }) : assert(allowedOperations.isNotEmpty),
       assert(totalQuestions > 0),
       assert(timerSeconds >= 0),
       allowedOperations = List.unmodifiable(allowedOperations);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ActiveGameConfig &&
            levelNumber == other.levelNumber &&
            stageTitle == other.stageTitle &&
            timerSeconds == other.timerSeconds &&
            isExamMode == other.isExamMode &&
            _operationsEqual(allowedOperations, other.allowedOperations) &&
            totalQuestions == other.totalQuestions &&
            preservePreparedSession == other.preservePreparedSession &&
            visualAidsEnabled == other.visualAidsEnabled &&
            soundEnabled == other.soundEnabled;
  }

  @override
  int get hashCode => Object.hash(
    levelNumber,
    stageTitle,
    timerSeconds,
    isExamMode,
    Object.hashAll(allowedOperations),
    totalQuestions,
    preservePreparedSession,
    visualAidsEnabled,
    soundEnabled,
  );

  static bool _operationsEqual(
    List<MathOperation> first,
    List<MathOperation> second,
  ) {
    if (identical(first, second)) return true;
    if (first.length != second.length) return false;

    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }
}

class ActiveGameFlowState {
  final int? selectedAnswer;
  final bool isEvaluating;
  final List<AnswerSubmission> answers;
  final DateTime questionStartedAt;
  final int secondsRemaining;
  final bool hasStarted;
  final bool isCompleted;
  final ExamReport? completedReport;

  ActiveGameFlowState({
    this.selectedAnswer,
    this.isEvaluating = false,
    List<AnswerSubmission> answers = const [],
    required this.questionStartedAt,
    required this.secondsRemaining,
    this.hasStarted = false,
    this.isCompleted = false,
    this.completedReport,
  }) : answers = List.unmodifiable(answers);

  ActiveGameFlowState copyWith({
    int? selectedAnswer,
    bool clearSelectedAnswer = false,
    bool? isEvaluating,
    List<AnswerSubmission>? answers,
    DateTime? questionStartedAt,
    int? secondsRemaining,
    bool? hasStarted,
    bool? isCompleted,
    ExamReport? completedReport,
    bool clearCompletedReport = false,
  }) {
    return ActiveGameFlowState(
      selectedAnswer: clearSelectedAnswer
          ? null
          : selectedAnswer ?? this.selectedAnswer,
      isEvaluating: isEvaluating ?? this.isEvaluating,
      answers: answers ?? this.answers,
      questionStartedAt: questionStartedAt ?? this.questionStartedAt,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      hasStarted: hasStarted ?? this.hasStarted,
      isCompleted: isCompleted ?? this.isCompleted,
      completedReport: clearCompletedReport
          ? null
          : completedReport ?? this.completedReport,
    );
  }
}

class ActiveGameState {
  final MathProblem problem;
  final List<int> options;
  final int? selectedAnswer;
  final bool isEvaluating;
  final bool showVisualAids;
  final int currentStreak;
  final int answeredCount;
  final int totalQuestions;
  final double progressFraction;
  final int secondsRemaining;
  final String formattedTime;
  final bool isTimerVisible;
  final bool isTimerDanger;
  final String stageLabel;
  final bool isExamMode;
  final ExamReport? completedReport;

  const ActiveGameState({
    required this.problem,
    required this.options,
    required this.selectedAnswer,
    required this.isEvaluating,
    required this.showVisualAids,
    required this.currentStreak,
    required this.answeredCount,
    required this.totalQuestions,
    required this.progressFraction,
    required this.secondsRemaining,
    required this.formattedTime,
    required this.isTimerVisible,
    required this.isTimerDanger,
    required this.stageLabel,
    required this.isExamMode,
    required this.completedReport,
  });

  factory ActiveGameState.fromSources({
    required ActiveGameConfig config,
    required PracticeSessionState session,
    required ActiveGameFlowState flow,
  }) {
    final answeredCount = flow.answers.length;
    final progress = (answeredCount / config.totalQuestions).clamp(0.0, 1.0);
    final stageLabel = config.isExamMode
        ? 'EXAM CHALLENGE '
              '(${(answeredCount + 1).clamp(1, config.totalQuestions)}/${config.totalQuestions})'
        : config.stageTitle?.toUpperCase() ??
              '${session.currentProblem.operation.label.toUpperCase()} ADVENTURE';
    final minutes = flow.secondsRemaining ~/ 60;
    final seconds = flow.secondsRemaining % 60;

    return ActiveGameState(
      problem: session.currentProblem,
      options: List.unmodifiable(session.currentProblem.options),
      selectedAnswer: flow.selectedAnswer,
      isEvaluating: flow.isEvaluating,
      showVisualAids: session.showVisualAids,
      currentStreak: session.currentStreak,
      answeredCount: answeredCount,
      totalQuestions: config.totalQuestions,
      progressFraction: progress,
      secondsRemaining: flow.secondsRemaining,
      formattedTime:
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}',
      isTimerVisible: config.timerSeconds > 0,
      isTimerDanger: flow.secondsRemaining <= 10,
      stageLabel: stageLabel,
      isExamMode: config.isExamMode,
      completedReport: flow.completedReport,
    );
  }
}

abstract interface class ActiveGameTicker {
  void start(void Function() onTick);

  void cancel();
}

class PeriodicActiveGameTicker implements ActiveGameTicker {
  Timer? _timer;

  @override
  void start(void Function() onTick) {
    cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => onTick());
  }

  @override
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}

class ActiveGameController {
  final ActiveGameConfig config;
  final ActiveGameTicker ticker;
  final ActiveGameFlowState Function() readFlow;
  final void Function(ActiveGameFlowState) writeFlow;
  final PracticeSessionState Function() readSession;
  final void Function({MathOperation? operation}) resetSessionAction;
  final DateTime Function() now;
  final void Function(int) selectAnswerAction;
  final void Function() evaluateAnswerAction;
  final void Function({MathOperation? operation}) nextProblemAction;
  final Future<void> Function() playTapAction;
  final Future<void> Function() playCorrectAction;
  final Future<void> Function() playWrongAction;
  final Future<void> Function() hapticSubmittedAction;
  final Future<void> Function() hapticCorrectAction;
  final Future<void> Function() hapticIncorrectAction;
  final Future<void> Function(Duration) delay;
  final MathOperation Function(List<MathOperation>) chooseOperation;

  bool _disposed = false;
  Future<void>? _submissionInFlight;

  ActiveGameController({
    required this.config,
    required this.ticker,
    required this.readFlow,
    required this.writeFlow,
    required this.readSession,
    required this.resetSessionAction,
    required this.now,
    required this.selectAnswerAction,
    required this.evaluateAnswerAction,
    required this.nextProblemAction,
    required this.playTapAction,
    required this.playCorrectAction,
    required this.playWrongAction,
    required this.hapticSubmittedAction,
    required this.hapticCorrectAction,
    required this.hapticIncorrectAction,
    required this.delay,
    required this.chooseOperation,
  });

  void start() {
    if (_disposed || readFlow().hasStarted) return;

    if (!config.preservePreparedSession) {
      resetSessionAction(operation: config.allowedOperations.first);
    }

    writeFlow(
      readFlow().copyWith(
        hasStarted: true,
        questionStartedAt: now(),
        secondsRemaining: config.timerSeconds,
      ),
    );
    if (config.timerSeconds > 0) {
      ticker.start(_handleTick);
    }
  }

  void _handleTick() {
    if (_disposed || readFlow().isCompleted) return;

    final remaining = readFlow().secondsRemaining;
    if (remaining > 1) {
      writeFlow(readFlow().copyWith(secondsRemaining: remaining - 1));
      return;
    }

    writeFlow(readFlow().copyWith(secondsRemaining: 0));
    _completeGame();
  }

  void _completeGame() {
    final flow = readFlow();
    if (_disposed || flow.isCompleted) return;

    final answers = List<AnswerSubmission>.from(flow.answers);
    final correctCount = answers.where((answer) => answer.isCorrect).length;
    final totalQuestions = answers.isEmpty
        ? config.totalQuestions
        : answers.length;
    final totalDuration = config.timerSeconds > 0
        ? Duration(seconds: config.timerSeconds - flow.secondsRemaining)
        : answers.fold<Duration>(
            Duration.zero,
            (total, answer) => total + answer.timeTaken,
          );

    ticker.cancel();
    writeFlow(
      flow.copyWith(
        isCompleted: true,
        completedReport: ExamReport(
          correctCount: correctCount,
          totalQuestions: totalQuestions,
          totalDuration: totalDuration,
          answers: answers,
        ),
      ),
    );
  }

  Future<void> submitAnswer(int selectedAnswer) {
    if (_disposed || readFlow().isCompleted) {
      return Future<void>.value();
    }
    return _submissionInFlight ??= _submitAnswer(selectedAnswer)
        .whenComplete(() => _submissionInFlight = null);
  }

  Future<void> _submitAnswer(int selectedAnswer) async {
    final flowBeforeSubmission = readFlow();
    final session = readSession();
    final problem = session.currentProblem;
    final elapsed = now().difference(flowBeforeSubmission.questionStartedAt);
    final answers = [
      ...flowBeforeSubmission.answers,
      AnswerSubmission(
        problem: problem,
        selectedAnswer: selectedAnswer,
        timeTaken: elapsed,
      ),
    ];
    writeFlow(
      readFlow().copyWith(
        selectedAnswer: selectedAnswer,
        isEvaluating: true,
        answers: answers,
      ),
    );

    try {
      await hapticSubmittedAction();
      if (_disposed) return;
      if (config.soundEnabled) {
        await playTapAction();
        if (_disposed) return;
      }
      selectAnswerAction(selectedAnswer);
      evaluateAnswerAction();

      if (config.isExamMode) {
        if (config.soundEnabled) {
          await playTapAction();
          if (_disposed) return;
        }
      } else {
        if (config.soundEnabled) {
          if (selectedAnswer == problem.correctAnswer) {
            await playCorrectAction();
          } else {
            await playWrongAction();
          }
          if (_disposed) return;
        }
        if (selectedAnswer == problem.correctAnswer) {
          await hapticCorrectAction();
        } else {
          await hapticIncorrectAction();
        }
        if (_disposed) return;
        await delay(const Duration(milliseconds: 650));
      }

      if (_disposed) return;
      if (readFlow().isCompleted) {
        writeFlow(readFlow().copyWith(isEvaluating: false));
        return;
      }

      if (readFlow().answers.length >= config.totalQuestions) {
        writeFlow(readFlow().copyWith(isEvaluating: false));
        _completeGame();
        return;
      }

      final nextOperation = chooseOperation(config.allowedOperations);
      nextProblemAction(operation: nextOperation);
      writeFlow(
        readFlow().copyWith(
          clearSelectedAnswer: true,
          isEvaluating: false,
          questionStartedAt: now(),
        ),
      );
    } catch (_) {
      if (!_disposed) {
        final currentFlow = readFlow();
        if (currentFlow.isCompleted) {
          writeFlow(currentFlow.copyWith(isEvaluating: false));
        } else {
          writeFlow(
            currentFlow.copyWith(
              answers: flowBeforeSubmission.answers,
              clearSelectedAnswer: true,
              isEvaluating: false,
            ),
          );
        }
      }
      rethrow;
    }
  }

  void clearCompletedReport() {
    if (_disposed || readFlow().completedReport == null) return;
    writeFlow(readFlow().copyWith(clearCompletedReport: true));
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    ticker.cancel();
  }
}

class _ActiveGameFlowNotifier extends StateNotifier<ActiveGameFlowState> {
  _ActiveGameFlowNotifier(ActiveGameConfig config)
    : super(
        ActiveGameFlowState(
          questionStartedAt: DateTime.now(),
          secondsRemaining: config.timerSeconds,
        ),
      );

  void replace(ActiveGameFlowState next) => state = next;
}

final _activeGameFlowProvider = StateNotifierProvider.autoDispose
    .family<_ActiveGameFlowNotifier, ActiveGameFlowState, ActiveGameConfig>((
      ref,
      config,
    ) {
      return _ActiveGameFlowNotifier(config);
    });

final activeGameControllerProvider = Provider.autoDispose
    .family<ActiveGameController, ActiveGameConfig>((ref, config) {
      final flowNotifier = ref.watch(_activeGameFlowProvider(config).notifier);
      final controller = ActiveGameController(
        config: config,
        ticker: PeriodicActiveGameTicker(),
        readFlow: () => ref.read(_activeGameFlowProvider(config)),
        writeFlow: flowNotifier.replace,
        readSession: () => ref.read(practiceSessionProvider),
        resetSessionAction: ({operation}) => ref
            .read(practiceSessionProvider.notifier)
            .resetSession(operation: operation),
        now: DateTime.now,
        selectAnswerAction: ref
            .read(practiceSessionProvider.notifier)
            .selectAnswer,
        evaluateAnswerAction: ref
            .read(practiceSessionProvider.notifier)
            .evaluateAnswer,
        nextProblemAction: ({operation}) => ref
            .read(practiceSessionProvider.notifier)
            .nextProblem(operation: operation),
        playTapAction: ref.read(soundServiceProvider).playTap,
        playCorrectAction: ref.read(soundServiceProvider).playCorrect,
        playWrongAction: ref.read(soundServiceProvider).playWrong,
        hapticSubmittedAction: ref.read(hapticServiceProvider).answerSubmitted,
        hapticCorrectAction: ref.read(hapticServiceProvider).correctAnswer,
        hapticIncorrectAction: ref.read(hapticServiceProvider).incorrectAnswer,
        delay: Future<void>.delayed,
        chooseOperation: (operations) =>
            (List<MathOperation>.from(operations)..shuffle()).first,
      );
      ref.onDispose(controller.dispose);
      return controller;
    });

final activeGameProvider = Provider.autoDispose
    .family<ActiveGameState, ActiveGameConfig>((ref, config) {
      ref.watch(activeGameControllerProvider(config));
      return ActiveGameState.fromSources(
        config: config,
        session: ref.watch(practiceSessionProvider),
        flow: ref.watch(_activeGameFlowProvider(config)),
      );
    });
