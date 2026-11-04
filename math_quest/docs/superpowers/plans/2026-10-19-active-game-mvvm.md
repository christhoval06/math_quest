# Active Game MVVM Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor `ActiveGameScreen` into the same immutable-state, injected-controller, thin-screen pattern used by `HomeDashboardScreen`.

**Architecture:** A private auto-disposed flow notifier owns screen-local gameplay state. `activeGameProvider(config)` combines that flow with `practiceSessionProvider`, while `activeGameControllerProvider(config)` owns timer and answer actions through injected dependencies. The screen renders provider-free widgets and performs route navigation when state contains a completed report.

**Tech Stack:** Flutter, Dart, Riverpod 2, `flutter_test`

**Spec:** `docs/superpowers/specs/2026-10-19-active-game-mvvm-design.md`

## Global Constraints

- Preserve the current UI, route arguments, question flow, scoring rules, prepared-session behavior, timer behavior, sounds, and quest-complete navigation.
- Keep `practiceSessionProvider` as the domain session owner.
- Keep navigation inside `ActiveGameScreen`.
- Keep extracted widgets free of Riverpod and persistence imports.
- Add no Hive or repository implementation references to Active Game presentation code.
- Add no package dependency.
- This workspace has no Git metadata. Replace each commit step with a dated checkpoint in `.superpowers/sdd/2026-10-19-active-game-mvvm/progress.md` unless Git metadata becomes available.

## Review Focus

- A repeated `start()` call must not reset the session or create a second timer; Task 2 tests this idempotency.
- An empty allowed-operation list must fail at `ActiveGameConfig` construction instead of failing after an answer; Task 1 tests the assertion.
- A nonpositive question count must fail at `ActiveGameConfig` construction instead of producing invalid progress; Task 1 tests the assertion.
- Timer expiry racing with the final answer must produce one report; Task 3 tests completion idempotency.
- A thrown session, sound, or delay dependency must release the evaluation lock and surface the error; Task 3 tests failure recovery.

---

## File Structure

- Create `lib/features/gameplay/presentation/providers/active_game_provider.dart`: config, immutable view/flow state, ticker abstraction, controller, and Riverpod wiring.
- Modify `lib/features/gameplay/presentation/screens/active_game_screen.dart`: thin lifecycle, state rendering, callbacks, and result navigation.
- Create `lib/features/gameplay/presentation/widgets/active_game_app_bar.dart`: progress, countdown, streak, and back action.
- Create `lib/features/gameplay/presentation/widgets/game_stage_badge.dart`: stage label presentation.
- Create `lib/features/gameplay/presentation/widgets/active_game_problem_card.dart`: equation and visual aid.
- Create `lib/features/gameplay/presentation/widgets/answer_options_grid.dart`: four answer choices.
- Create `lib/features/gameplay/presentation/widgets/game_mascot_bar.dart`: hint footer.
- Modify `lib/features/gameplay/presentation/widgets/option_card.dart`: remove Riverpod and sound-provider access.
- Create `test/features/gameplay/presentation/providers/active_game_provider_test.dart`: state, lifecycle, timer, answer, report, and error tests.
- Create `test/features/gameplay/presentation/widgets/active_game_widgets_test.dart`: provider-free widget tests.
- Modify `test/features/gameplay/presentation/screens/active_game_screen_test.dart`: integration, completion navigation, and narrow-layout tests.

### Task 1: Configuration and Immutable View State

**Files:**
- Create: `lib/features/gameplay/presentation/providers/active_game_provider.dart`
- Create: `test/features/gameplay/presentation/providers/active_game_provider_test.dart`

**Interfaces:**
- Consumes: `MathOperation`, `MathProblem`, `PracticeSessionState`, `AnswerSubmission`, and `ExamReport`.
- Produces: `ActiveGameConfig`, `ActiveGameFlowState`, and `ActiveGameState.fromSources(...)`.

- [ ] **Step 1: Write failing configuration and mapping tests**

Add tests named `config has value equality`, `config rejects empty operations`, `config rejects nonpositive question count`, `state maps practice and flow sources`, `state formats countdown and danger threshold`, and `state maps stage labels for exam named stage and operation adventure`. Assert the current defaults, `65 -> 01:05`, danger at 10 seconds, clamped progress, and the current label strings.

- [ ] **Step 2: Run the focused test and verify RED**

Run: `flutter test test/features/gameplay/presentation/providers/active_game_provider_test.dart`

Expected: FAIL because `active_game_provider.dart` and its types do not exist.

- [ ] **Step 3: Implement the state contracts**

Add:

```dart
class ActiveGameConfig {
  const ActiveGameConfig({
    this.levelNumber,
    this.stageTitle,
    this.timerSeconds = 0,
    this.isExamMode = false,
    this.allowedOperations = const [MathOperation.addition],
    this.totalQuestions = 10,
    this.preservePreparedSession = false,
  }) : assert(allowedOperations.length > 0),
       assert(totalQuestions > 0),
       assert(timerSeconds >= 0);
}

class ActiveGameFlowState {
  final int? selectedAnswer;
  final bool isEvaluating;
  final List<AnswerSubmission> answers;
  final DateTime questionStartedAt;
  final int secondsRemaining;
  final bool hasStarted;
  final ExamReport? completedReport;
  // const constructor and copyWith with explicit clearSelectedAnswer.
}

class ActiveGameState {
  factory ActiveGameState.fromSources({
    required ActiveGameConfig config,
    required PracticeSessionState session,
    required ActiveGameFlowState flow,
  });
}
```

Implement value equality and stable `hashCode` for `ActiveGameConfig`, with an element-by-element operation-list comparison. Keep `ActiveGameFlowState` internal mutation behind a private `StateNotifier`. Map stage text and formatted time in the factory.

- [ ] **Step 4: Run focused tests and analysis**

Run: `flutter test test/features/gameplay/presentation/providers/active_game_provider_test.dart`

Run: `flutter analyze lib/features/gameplay/presentation/providers/active_game_provider.dart test/features/gameplay/presentation/providers/active_game_provider_test.dart`

Expected: PASS and `No issues found!`

- [ ] **Step 5: Checkpoint**

Commit `feat: add active game view state` or record the task and verification commands in the execution ledger when Git remains unavailable.

### Task 2: Controller Initialization and Countdown

**Files:**
- Modify: `lib/features/gameplay/presentation/providers/active_game_provider.dart`
- Modify: `test/features/gameplay/presentation/providers/active_game_provider_test.dart`

**Interfaces:**
- Consumes: Task 1 config and flow state.
- Produces: `ActiveGameTicker`, `PeriodicActiveGameTicker`, `ActiveGameController.start()`, `ActiveGameController.dispose()`, `activeGameProvider(config)`, and `activeGameControllerProvider(config)`.

- [ ] **Step 1: Write failing lifecycle tests**

Add tests named `start resets an unprepared session once`, `start preserves a prepared session`, `repeated start is idempotent`, `countdown decrements once per tick`, `countdown completes at zero`, `dispose cancels the ticker`, and `provider wiring retains one controller while state is watched`. Use a fake ticker that exposes `tick()` and records cancellation. Use `ProviderContainer.listen` for the wiring test.

- [ ] **Step 2: Run the lifecycle tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/providers/active_game_provider_test.dart`

Expected: FAIL because controller lifecycle and ticker behavior are absent.

- [ ] **Step 3: Implement ticker and lifecycle interfaces**

Add:

```dart
abstract interface class ActiveGameTicker {
  void start(void Function() onTick);
  void cancel();
}

class ActiveGameController {
  ActiveGameController({
    required ActiveGameConfig config,
    required ActiveGameTicker ticker,
    required PracticeSessionState Function() readSession,
    required void Function({MathOperation? operation}) resetSessionAction,
    required DateTime Function() now,
    // Task 3 action dependencies.
  });

  void start();
  void dispose();
}
```

`start()` sets the question start time, resets only when `preservePreparedSession` is false, and starts one ticker only when `timerSeconds > 0`. Each tick decrements positive remaining time; zero triggers the shared completion path. `dispose()` cancels the ticker and ignores later ticks.

- [ ] **Step 4: Wire production dependencies**

Use `Timer.periodic(const Duration(seconds: 1), ...)` inside `PeriodicActiveGameTicker`. Define private `_activeGameFlowProvider`, public `activeGameProvider`, and `activeGameControllerProvider`. Build the controller from Riverpod callbacks around `practiceSessionProvider.notifier`, `soundServiceProvider`, `DateTime.now`, and `Future.delayed`. Register `controller.dispose` with `ref.onDispose`. Make `activeGameProvider(config)` watch the controller provider so Riverpod retains controller lifetime while the UI watches state.

- [ ] **Step 5: Run lifecycle tests and focused analysis**

Run the Task 1 test file and analyze the provider file. Expected: PASS and no issues.

- [ ] **Step 6: Checkpoint**

Commit `feat: move active game timer into controller` or record the checkpoint.

### Task 3: Answer Flow and Report Completion

**Files:**
- Modify: `lib/features/gameplay/presentation/providers/active_game_provider.dart`
- Modify: `test/features/gameplay/presentation/providers/active_game_provider_test.dart`

**Interfaces:**
- Consumes: Task 2 controller lifecycle.
- Produces: `Future<void> ActiveGameController.submitAnswer(int selectedAnswer)` and `void ActiveGameController.clearCompletedReport()`.

- [ ] **Step 1: Write failing answer-flow tests**

Add tests named `submit records elapsed time and evaluates answer`, `overlapping submissions coalesce`, `practice feedback plays tap and result sound then delays 650ms`, `exam feedback preserves the two tap sounds without delay`, `next question uses injected operation choice`, `last answer creates an accurate untimed report`, `timer expiry before an answer uses configured total`, `timer and last answer race creates one report`, and `dependency failure releases evaluation lock and rethrows`.

- [ ] **Step 2: Run the answer-flow tests and verify RED**

Run the provider test file. Expected: FAIL because submission and report behavior are absent.

- [ ] **Step 3: Implement injected answer actions**

Extend the controller constructor with:

```dart
required void Function(int) selectAnswerAction,
required void Function() evaluateAnswerAction,
required void Function({MathOperation? operation}) nextProblemAction,
required Future<void> Function() playTapAction,
required Future<void> Function() playCorrectAction,
required Future<void> Function() playWrongAction,
required Future<void> Function(Duration) delay,
required MathOperation Function(List<MathOperation>) chooseOperation,
```

`submitAnswer` must guard one in-flight evaluation, record the pre-evaluation problem and elapsed time, update flow state, preserve the existing sound sequence, and call the shared completion method at the configured question count. Use `try`/`catch` to release the lock and rethrow dependency errors.

- [ ] **Step 4: Implement shared report completion**

Create one private completion method used by answer submission and timer expiry. Guard against a second report. Preserve the scoring and duration rules from the specification, and copy the answer list into `ExamReport`. `clearCompletedReport()` must clear only the report field after the screen consumes it.

- [ ] **Step 5: Run provider tests and focused analysis**

Run the provider test file and analyze its production/test files. Expected: PASS and no issues.

- [ ] **Step 6: Checkpoint**

Commit `feat: move active game answer flow into controller` or record the checkpoint.

### Task 4: Provider-Free Gameplay Widgets

**Files:**
- Create: `lib/features/gameplay/presentation/widgets/active_game_app_bar.dart`
- Create: `lib/features/gameplay/presentation/widgets/game_stage_badge.dart`
- Create: `lib/features/gameplay/presentation/widgets/active_game_problem_card.dart`
- Create: `lib/features/gameplay/presentation/widgets/answer_options_grid.dart`
- Create: `lib/features/gameplay/presentation/widgets/game_mascot_bar.dart`
- Modify: `lib/features/gameplay/presentation/widgets/option_card.dart`
- Create: `test/features/gameplay/presentation/widgets/active_game_widgets_test.dart`

**Interfaces:**
- Consumes: plain values from `ActiveGameState` and theme colors.
- Produces: the five widget classes named in File Structure and a provider-free `OptionCard` with its existing constructor.

- [ ] **Step 1: Write failing widget tests**

Test progress, timer danger styling, streak, back callback, the three stage-label forms, visual-aid visibility, answer callback and evaluation styling, and mascot copy. Add a source-boundary assertion or static scan proving the six widget files contain no `flutter_riverpod`, `sound_provider`, Hive, or repository implementation imports.

- [ ] **Step 2: Run widget tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/widgets/active_game_widgets_test.dart`

Expected: FAIL because the extracted widget files do not exist.

- [ ] **Step 3: Extract widgets without visual changes**

Move the existing layout values and copy into the five files. Make `OptionCard` a `StatelessWidget`, remove the sound-provider read, and call `onTap` directly. Keep the controller responsible for sound playback.

- [ ] **Step 4: Run widget tests and focused analysis**

Run the widget test file and analyze the six widget files. Expected: PASS and no issues.

- [ ] **Step 5: Checkpoint**

Commit `refactor: extract active game widgets` or record the checkpoint.

### Task 5: Thin Screen and Navigation Integration

**Files:**
- Modify: `lib/features/gameplay/presentation/screens/active_game_screen.dart`
- Modify: `test/features/gameplay/presentation/screens/active_game_screen_test.dart`

**Interfaces:**
- Consumes: Task 1 `ActiveGameConfig` and `ActiveGameState`, Task 3 controller actions, and Task 4 widgets.
- Produces: a thin `ActiveGameScreen` with unchanged public constructor and quest-complete route arguments.

- [ ] **Step 1: Expand screen tests before changing the screen**

Keep the prepared-session regression test. Add tests named `resets an ordinary session after launch`, `submits an answer through the controller`, `navigates once with the completed report`, `back action attempts to pop`, and `renders without overflow at 390x844`. Override the active-game controller/provider seams where interaction isolation helps.

- [ ] **Step 2: Run screen tests and verify RED**

Run the screen test file. Expected: new tests FAIL because the screen still owns gameplay behavior and old layout.

- [ ] **Step 3: Refactor the screen**

Create one `late final ActiveGameConfig` in `initState`, call `controller.start()` after the first frame, watch `activeGameProvider(config)`, and render Task 4 widgets. Use `ref.listen` for the transition to a non-null `completedReport`; call `Navigator.pushReplacementNamed` with unchanged `QuestCompleteArgs`, then clear the report to prevent repeat navigation.

- [ ] **Step 4: Prove the separation boundaries**

Run:

```bash
rg -n "Timer|AnswerSubmission|soundServiceProvider|PracticeSessionNotifier|Hive|RepositoryImpl" lib/features/gameplay/presentation/screens/active_game_screen.dart
```

Expected: no matches. Scan the new provider and widgets for Hive and repository implementations; expect no matches.

- [ ] **Step 5: Run screen, feature, and analysis verification**

Run:

```bash
flutter test test/features/gameplay
flutter test test/features/profile_and_stats/presentation/screens/home_dashboard_screen_test.dart
flutter analyze lib/features/gameplay/presentation/providers/active_game_provider.dart lib/features/gameplay/presentation/screens/active_game_screen.dart lib/features/gameplay/presentation/widgets test/features/gameplay
```

Expected: all tests pass. New files report no analyzer issues; record existing diagnostics outside the changed files without expanding scope.

- [ ] **Step 6: Checkpoint**

Commit `refactor: make active game screen state driven` or record the checkpoint.

### Task 6: Final Regression Verification

**Files:**
- Modify only files required to fix failures introduced by Tasks 1 through 5.
- Update: `.superpowers/sdd/2026-10-19-active-game-mvvm/progress.md`

**Interfaces:**
- Consumes: all prior task outputs.
- Produces: verified Active Game MVVM refactor and an execution record.

- [ ] **Step 1: Format changed Dart files**

Run `dart format` on the changed production and test files. Expected: successful formatting.

- [ ] **Step 2: Run the full test suite**

Run: `flutter test`

Expected: all tests pass.

- [ ] **Step 3: Run full-project analysis**

Run: `flutter analyze`

Expected: record the result. Fix diagnostics introduced by this refactor. Keep the repository's existing unrelated diagnostics outside scope.

- [ ] **Step 4: Run presentation-boundary scans**

Scan the changed Active Game presentation files for Riverpod in widgets and persistence implementations across the feature. Expected: zero boundary violations.

- [ ] **Step 5: Record final evidence**

Append test counts, analysis results, boundary scan results, and any explicit scope rulings to the execution ledger.

- [ ] **Step 6: Final checkpoint**

Commit `test: verify active game MVVM refactor` or preserve the workspace and ledger when Git remains unavailable.
