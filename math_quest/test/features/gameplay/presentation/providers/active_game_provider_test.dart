import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/core/audio/i_sound_service.dart';
import 'package:math_quest/core/audio/sound_provider.dart';
import 'package:math_quest/features/gameplay/presentation/providers/active_game_provider.dart';
import 'package:math_quest/features/math_engine/domain/entities/answer_submission.dart';
import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_problem.dart';
import 'package:math_quest/features/math_engine/domain/usecases/generate_problem_usecase.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_notifier.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_state.dart';

class _FakeTicker implements ActiveGameTicker {
  void Function()? _onTick;
  int startCount = 0;
  int cancelCount = 0;

  @override
  void start(void Function() onTick) {
    startCount++;
    _onTick = onTick;
  }

  void tick() => _onTick?.call();

  @override
  void cancel() {
    cancelCount++;
    _onTick = null;
  }
}

class _FakeSoundService implements ISoundService {
  @override
  Future<void> playCorrect() async {}

  @override
  Future<void> playStar(int starIndex) async {}

  @override
  Future<void> playTap() async {}

  @override
  Future<void> playVictory() async {}

  @override
  Future<void> playWrong() async {}

  @override
  void setMusicVolume(double volume) {}

  @override
  void setSfxVolume(double volume) {}
}

void main() {
  const problem = MathProblem(
    num1: 6,
    num2: 7,
    operation: MathOperation.multiplication,
    correctAnswer: 42,
    options: [42, 36, 48, 49],
  );
  const session = PracticeSessionState(
    operation: MathOperation.multiplication,
    difficulty: DifficultyLevel.medium,
    currentProblem: problem,
    selectedAnswer: 42,
    isAnswerEvaluated: true,
    showVisualAids: false,
    currentStreak: 3,
  );
  final startedAt = DateTime(2026, 10, 19, 12);

  group('ActiveGameConfig', () {
    test('has value equality', () {
      final first = ActiveGameConfig(
        levelNumber: 4,
        stageTitle: 'Pebble Beach',
        timerSeconds: 65,
        isExamMode: true,
        allowedOperations: [
          MathOperation.addition,
          MathOperation.multiplication,
        ],
        totalQuestions: 12,
        preservePreparedSession: true,
      );
      final second = ActiveGameConfig(
        levelNumber: 4,
        stageTitle: 'Pebble Beach',
        timerSeconds: 65,
        isExamMode: true,
        allowedOperations: [
          MathOperation.addition,
          MathOperation.multiplication,
        ],
        totalQuestions: 12,
        preservePreparedSession: true,
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });

    test('rejects empty operations', () {
      expect(
        () => ActiveGameConfig(allowedOperations: const []),
        throwsAssertionError,
      );
    });

    test('rejects nonpositive question count', () {
      expect(() => ActiveGameConfig(totalQuestions: 0), throwsAssertionError);
    });

    test('rejects a negative timer', () {
      expect(() => ActiveGameConfig(timerSeconds: -1), throwsAssertionError);
    });

    test('takes an immutable snapshot of allowed operations', () {
      final operations = [MathOperation.addition];
      final config = ActiveGameConfig(allowedOperations: operations);
      final originalHashCode = config.hashCode;

      operations.add(MathOperation.division);

      expect(config.allowedOperations, [MathOperation.addition]);
      expect(config.hashCode, originalHashCode);
      expect(
        () => config.allowedOperations.add(MathOperation.subtraction),
        throwsUnsupportedError,
      );
    });

    test('visual aid and sound settings participate in equality', () {
      final enabled = ActiveGameConfig();
      final visualAidsDisabled = ActiveGameConfig(visualAidsEnabled: false);
      final soundDisabled = ActiveGameConfig(soundEnabled: false);

      expect(enabled, isNot(visualAidsDisabled));
      expect(enabled, isNot(soundDisabled));
      expect(visualAidsDisabled.hashCode, isNot(enabled.hashCode));
      expect(soundDisabled.hashCode, isNot(enabled.hashCode));
    });
  });

  group('ActiveGameFlowState', () {
    test('takes an immutable snapshot of answers', () {
      final answers = <AnswerSubmission>[];
      final flow = ActiveGameFlowState(
        answers: answers,
        questionStartedAt: startedAt,
        secondsRemaining: 0,
      );

      answers.add(
        AnswerSubmission(
          problem: problem,
          selectedAnswer: 42,
          timeTaken: const Duration(seconds: 1),
        ),
      );

      expect(flow.answers, isEmpty);
      expect(() => flow.answers.add(answers.single), throwsUnsupportedError);
    });
  });

  group('ActiveGameState', () {
    test('maps practice and flow sources', () {
      final flow = ActiveGameFlowState(
        selectedAnswer: 42,
        isEvaluating: true,
        answers: [
          AnswerSubmission(
            problem: problem,
            selectedAnswer: 42,
            timeTaken: const Duration(seconds: 3),
          ),
        ],
        questionStartedAt: startedAt,
        secondsRemaining: 65,
      );

      final state = ActiveGameState.fromSources(
        config: ActiveGameConfig(
          timerSeconds: 65,
          allowedOperations: [MathOperation.multiplication],
          totalQuestions: 4,
        ),
        session: session,
        flow: flow,
      );

      expect(state.problem, same(problem));
      expect(state.options, [42, 36, 48, 49]);
      expect(state.selectedAnswer, 42);
      expect(state.isEvaluating, isTrue);
      expect(state.showVisualAids, isFalse);
      expect(state.currentStreak, 3);
      expect(state.answeredCount, 1);
      expect(state.totalQuestions, 4);
      expect(state.progressFraction, 0.25);
      expect(state.isTimerVisible, isTrue);
      expect(state.completedReport, isNull);
    });

    test('formats countdown and danger threshold', () {
      final normal = ActiveGameState.fromSources(
        config: ActiveGameConfig(timerSeconds: 65),
        session: session,
        flow: ActiveGameFlowState(
          questionStartedAt: startedAt,
          secondsRemaining: 65,
        ),
      );
      final danger = ActiveGameState.fromSources(
        config: ActiveGameConfig(timerSeconds: 65),
        session: session,
        flow: ActiveGameFlowState(
          questionStartedAt: startedAt,
          secondsRemaining: 10,
        ),
      );

      expect(normal.formattedTime, '01:05');
      expect(normal.isTimerDanger, isFalse);
      expect(danger.formattedTime, '00:10');
      expect(danger.isTimerDanger, isTrue);
    });

    test('maps stage labels for exam named stage and operation adventure', () {
      ActiveGameState stateFor(ActiveGameConfig config) {
        return ActiveGameState.fromSources(
          config: config,
          session: session,
          flow: ActiveGameFlowState(
            questionStartedAt: startedAt,
            secondsRemaining: config.timerSeconds,
          ),
        );
      }

      expect(
        stateFor(ActiveGameConfig(isExamMode: true, totalQuestions: 10))
            .stageLabel,
        'EXAM CHALLENGE (1/10)',
      );
      expect(
        stateFor(ActiveGameConfig(stageTitle: 'Pebble Beach')).stageLabel,
        'PEBBLE BEACH',
      );
      expect(
        stateFor(
          ActiveGameConfig(allowedOperations: [MathOperation.multiplication]),
        ).stageLabel,
        'MULTIPLICATION ADVENTURE',
      );
    });
  });

  group('ActiveGameController lifecycle', () {
    late ActiveGameFlowState flow;
    late _FakeTicker ticker;
    late int resetCount;
    late MathOperation? resetOperation;

    ActiveGameController createController({
      ActiveGameConfig? config,
      DateTime Function()? now,
      void Function(int)? selectAnswerAction,
      void Function()? evaluateAnswerAction,
      void Function({MathOperation? operation})? nextProblemAction,
      Future<void> Function()? playTapAction,
      Future<void> Function()? playCorrectAction,
      Future<void> Function()? playWrongAction,
      Future<void> Function(Duration)? delay,
      MathOperation Function(List<MathOperation>)? chooseOperation,
    }) {
      return ActiveGameController(
        config: config ?? ActiveGameConfig(),
        ticker: ticker,
        readFlow: () => flow,
        writeFlow: (next) => flow = next,
        readSession: () => session,
        resetSessionAction: ({operation}) {
          resetCount++;
          resetOperation = operation;
        },
        now: now ?? () => startedAt,
        selectAnswerAction: selectAnswerAction ?? (_) {},
        evaluateAnswerAction: evaluateAnswerAction ?? () {},
        nextProblemAction: nextProblemAction ?? ({operation}) {},
        playTapAction: playTapAction ?? () async {},
        playCorrectAction: playCorrectAction ?? () async {},
        playWrongAction: playWrongAction ?? () async {},
        hapticSubmittedAction: () async {},
        hapticCorrectAction: () async {},
        hapticIncorrectAction: () async {},
        delay: delay ?? (_) async {},
        chooseOperation: chooseOperation ?? (operations) => operations.first,
      );
    }

    setUp(() {
      ticker = _FakeTicker();
      resetCount = 0;
      resetOperation = null;
      flow = ActiveGameFlowState(
        questionStartedAt: startedAt.subtract(const Duration(minutes: 1)),
        secondsRemaining: 0,
      );
    });

    test('start resets an unprepared session once', () {
      final controller = createController(
        config: ActiveGameConfig(
          allowedOperations: [MathOperation.subtraction],
        ),
      );

      controller.start();

      expect(resetCount, 1);
      expect(resetOperation, MathOperation.subtraction);
      expect(flow.hasStarted, isTrue);
      expect(flow.questionStartedAt, startedAt);
    });

    test('start preserves a prepared session', () {
      final controller = createController(
        config: ActiveGameConfig(preservePreparedSession: true),
      );

      controller.start();

      expect(resetCount, 0);
    });

    test('repeated start is idempotent', () {
      flow = ActiveGameFlowState(
        questionStartedAt: startedAt,
        secondsRemaining: 2,
      );
      final controller = createController(
        config: ActiveGameConfig(timerSeconds: 2),
      );

      controller.start();
      controller.start();

      expect(resetCount, 1);
      expect(ticker.startCount, 1);
    });

    test('countdown decrements once per tick', () {
      flow = ActiveGameFlowState(
        questionStartedAt: startedAt,
        secondsRemaining: 2,
      );
      final controller = createController(
        config: ActiveGameConfig(timerSeconds: 2),
      )..start();

      ticker.tick();

      expect(flow.secondsRemaining, 1);
      expect(flow.completedReport, isNull);
      controller.dispose();
    });

    test('countdown completes at zero', () {
      flow = ActiveGameFlowState(
        questionStartedAt: startedAt,
        secondsRemaining: 1,
      );
      createController(config: ActiveGameConfig(timerSeconds: 2)).start();

      ticker.tick();
      ticker.tick();

      expect(flow.secondsRemaining, 0);
      expect(flow.completedReport, isNotNull);
      expect(flow.completedReport!.correctCount, 0);
      expect(flow.completedReport!.totalQuestions, 10);
      expect(flow.completedReport!.totalDuration, const Duration(seconds: 2));
      expect(ticker.cancelCount, 1);
    });

    test('dispose cancels the ticker', () {
      flow = ActiveGameFlowState(
        questionStartedAt: startedAt,
        secondsRemaining: 2,
      );
      final controller = createController(
        config: ActiveGameConfig(timerSeconds: 2),
      )..start();

      controller.dispose();
      ticker.tick();

      expect(ticker.cancelCount, 1);
      expect(flow.secondsRemaining, 2);
    });

    test(
      'provider wiring retains one controller while state is watched',
      () async {
        final notifier = PracticeSessionNotifier(
          generateProblemUseCase: GenerateProblemUseCase(),
        )..state = session;
        final container = ProviderContainer(
          overrides: [
            practiceSessionProvider.overrideWith((ref) => notifier),
            soundServiceProvider.overrideWithValue(_FakeSoundService()),
          ],
        );
        addTearDown(container.dispose);
        final config = ActiveGameConfig(preservePreparedSession: true);
        final subscription = container.listen(
          activeGameProvider(config),
          (previous, next) {},
          fireImmediately: true,
        );
        addTearDown(subscription.close);

        final first = container.read(activeGameControllerProvider(config));
        await Future<void>.delayed(Duration.zero);
        final second = container.read(activeGameControllerProvider(config));

        expect(second, same(first));
      },
    );
  });

  group('ActiveGameController answers', () {
    late ActiveGameFlowState flow;
    late _FakeTicker ticker;
    late List<String> events;
    late List<Duration> delays;
    late List<MathOperation?> nextOperations;

    ActiveGameController createController({
      ActiveGameConfig? config,
      DateTime Function()? now,
      Future<void> Function()? playTapAction,
      Future<void> Function()? playCorrectAction,
      Future<void> Function()? playWrongAction,
      Future<void> Function()? hapticSubmittedAction,
      Future<void> Function()? hapticCorrectAction,
      Future<void> Function()? hapticIncorrectAction,
      Future<void> Function(Duration)? delay,
      MathOperation Function(List<MathOperation>)? chooseOperation,
      void Function()? evaluateAnswerAction,
    }) {
      return ActiveGameController(
        config: config ?? ActiveGameConfig(totalQuestions: 2),
        ticker: ticker,
        readFlow: () => flow,
        writeFlow: (next) => flow = next,
        readSession: () => session,
        resetSessionAction: ({operation}) {},
        now: now ?? () => startedAt.add(const Duration(seconds: 3)),
        selectAnswerAction: (answer) => events.add('select:$answer'),
        evaluateAnswerAction:
            evaluateAnswerAction ?? () => events.add('evaluate'),
        nextProblemAction: ({operation}) {
          events.add('next');
          nextOperations.add(operation);
        },
        playTapAction:
            playTapAction ??
            () async {
              events.add('tap');
            },
        playCorrectAction:
            playCorrectAction ??
            () async {
              events.add('correct');
            },
        playWrongAction:
            playWrongAction ??
            () async {
              events.add('wrong');
            },
        hapticSubmittedAction:
            hapticSubmittedAction ??
            () async {
              events.add('haptic:submitted');
            },
        hapticCorrectAction:
            hapticCorrectAction ??
            () async {
              events.add('haptic:correct');
            },
        hapticIncorrectAction:
            hapticIncorrectAction ??
            () async {
              events.add('haptic:incorrect');
            },
        delay:
            delay ??
            (duration) async {
              delays.add(duration);
              events.add('delay');
            },
        chooseOperation: chooseOperation ?? (operations) => operations.first,
      );
    }

    setUp(() {
      ticker = _FakeTicker();
      events = [];
      delays = [];
      nextOperations = [];
      flow = ActiveGameFlowState(
        questionStartedAt: startedAt,
        secondsRemaining: 0,
      );
    });

    test('submit records elapsed time and evaluates answer', () async {
      final controller = createController();

      await controller.submitAnswer(42);

      expect(flow.answers, hasLength(1));
      expect(flow.answers.single.problem, same(problem));
      expect(flow.answers.single.selectedAnswer, 42);
      expect(flow.answers.single.timeTaken, const Duration(seconds: 3));
      expect(events, containsAllInOrder(['select:42', 'evaluate']));
      expect(flow.isEvaluating, isFalse);
      expect(flow.selectedAnswer, isNull);
    });

    test('overlapping submissions coalesce', () async {
      final gate = Completer<void>();
      final controller = createController(delay: (_) => gate.future);

      final first = controller.submitAnswer(42);
      final second = controller.submitAnswer(36);

      expect(second, same(first));
      expect(flow.answers, hasLength(1));
      expect(
        events.where((event) => event == 'haptic:submitted'),
        hasLength(1),
      );
      gate.complete();
      await first;
      expect(flow.answers, hasLength(1));
    });

    test('disposal stops a submission suspended on feedback', () async {
      final gate = Completer<void>();
      final controller = createController(
        hapticSubmittedAction: () => gate.future,
      );

      final submission = controller.submitAnswer(42);
      controller.dispose();
      gate.complete();
      await submission;

      expect(events, isNot(contains('select:42')));
      expect(events, isNot(contains('evaluate')));
      expect(events, isNot(contains('haptic:correct')));
      expect(events, isNot(contains('haptic:incorrect')));
    });

    test('disposal during result audio suppresses result haptics', () async {
      final soundStarted = Completer<void>();
      final gate = Completer<void>();
      final controller = createController(
        playCorrectAction: () {
          soundStarted.complete();
          return gate.future;
        },
      );

      final submission = controller.submitAnswer(42);
      await soundStarted.future;
      controller.dispose();
      gate.complete();
      await submission;

      expect(events, containsAllInOrder(['select:42', 'evaluate']));
      expect(events, isNot(contains('haptic:correct')));
      expect(events, isNot(contains('delay')));
    });

    test(
      'practice feedback plays tap and result sound then delays 650ms',
      () async {
        final controller = createController();

        await controller.submitAnswer(42);

        expect(events, containsAllInOrder(['tap', 'correct', 'delay']));
        expect(delays, [const Duration(milliseconds: 650)]);
      },
    );

    test('practice emits submit then result haptics', () async {
      final controller = createController();

      await controller.submitAnswer(42);
      await controller.submitAnswer(36);

      expect(
        events,
        containsAllInOrder([
          'haptic:submitted',
          'haptic:correct',
          'haptic:submitted',
          'haptic:incorrect',
        ]),
      );
    });

    test('exam feedback preserves two tap sounds without delay', () async {
      final controller = createController(
        config: ActiveGameConfig(isExamMode: true, totalQuestions: 2),
      );

      await controller.submitAnswer(42);

      expect(events.where((event) => event == 'tap'), hasLength(2));
      expect(events, isNot(contains('correct')));
      expect(events, contains('haptic:submitted'));
      expect(events, isNot(contains('haptic:correct')));
      expect(events, isNot(contains('haptic:incorrect')));
      expect(delays, isEmpty);
    });

    test(
      'sound-disabled practice evaluates and delays without audio actions',
      () async {
        final controller = createController(
          config: ActiveGameConfig(totalQuestions: 2, soundEnabled: false),
        );

        await controller.submitAnswer(42);

        expect(events, containsAllInOrder(['select:42', 'evaluate', 'delay']));
        expect(events, isNot(contains('tap')));
        expect(events, isNot(contains('correct')));
        expect(events, isNot(contains('wrong')));
        expect(delays, [const Duration(milliseconds: 650)]);
      },
    );

    test('sound-disabled exam evaluates without audio or delay', () async {
      final controller = createController(
        config: ActiveGameConfig(
          isExamMode: true,
          totalQuestions: 2,
          soundEnabled: false,
        ),
      );

      await controller.submitAnswer(42);

      expect(events, containsAllInOrder(['select:42', 'evaluate', 'next']));
      expect(events, isNot(contains('tap')));
      expect(events, isNot(contains('correct')));
      expect(events, isNot(contains('wrong')));
      expect(delays, isEmpty);
    });

    test('next question uses injected operation choice', () async {
      final controller = createController(
        config: ActiveGameConfig(
          allowedOperations: [MathOperation.addition, MathOperation.division],
          totalQuestions: 2,
        ),
        chooseOperation: (_) => MathOperation.division,
      );

      await controller.submitAnswer(42);

      expect(nextOperations, [MathOperation.division]);
    });

    test('last answer creates an accurate untimed report', () async {
      final controller = createController(
        config: ActiveGameConfig(totalQuestions: 1),
      );

      await controller.submitAnswer(42);

      final report = flow.completedReport!;
      expect(report.correctCount, 1);
      expect(report.totalQuestions, 1);
      expect(report.totalDuration, const Duration(seconds: 3));
      expect(report.answers, hasLength(1));
    });

    test('consuming timer report cannot reopen completed game', () async {
      final gate = Completer<void>();
      flow = ActiveGameFlowState(
        questionStartedAt: startedAt,
        secondsRemaining: 1,
      );
      final controller = createController(
        config: ActiveGameConfig(timerSeconds: 1, totalQuestions: 1),
        delay: (_) => gate.future,
      )..start();

      final submission = controller.submitAnswer(42);
      ticker.tick();
      expect(flow.completedReport, isNotNull);
      controller.clearCompletedReport();
      expect(flow.completedReport, isNull);
      gate.complete();
      await submission;

      expect(flow.completedReport, isNull);
      expect(flow.isCompleted, isTrue);
      expect(flow.isEvaluating, isFalse);
      expect(nextOperations, isEmpty);
    });

    for (final failure in <String, ActiveGameController Function()>{
      'session': () => createController(
        evaluateAnswerAction: () => throw StateError('session'),
      ),
      'sound': () => createController(
        playCorrectAction: () => Future<void>.error(StateError('sound')),
      ),
      'delay': () => createController(
        delay: (_) => Future<void>.error(StateError('delay')),
      ),
    }.entries) {
      test('${failure.key} failure rolls back the pending answer', () async {
        final controller = failure.value();

        await expectLater(controller.submitAnswer(42), throwsStateError);
        expect(flow.answers, isEmpty);
        expect(flow.selectedAnswer, isNull);
        expect(flow.isEvaluating, isFalse);

        await expectLater(controller.submitAnswer(42), throwsStateError);
        expect(flow.answers, isEmpty);
      });
    }

    test('clear completed report consumes only the navigation event', () async {
      final controller = createController(
        config: ActiveGameConfig(totalQuestions: 1),
      );
      await controller.submitAnswer(42);
      final answers = flow.answers;

      controller.clearCompletedReport();

      expect(flow.completedReport, isNull);
      expect(flow.isCompleted, isTrue);
      expect(flow.answers, answers);
    });
  });
}
