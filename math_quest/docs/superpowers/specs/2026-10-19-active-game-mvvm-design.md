# Active Game MVVM Refactor

## Goal

Refactor `ActiveGameScreen` to follow the Home Dashboard presentation pattern. The screen will render immutable view state, forward user actions to a controller, and own Flutter navigation. Provider-free widgets will render each visual section.

The refactor must preserve the current UI, route arguments, question flow, scoring rules, prepared-session behavior, timer behavior, sounds, and quest-complete navigation.

## Current Responsibilities

`ActiveGameScreen` currently manages:

- practice-session initialization;
- countdown timer creation and disposal;
- selected-answer and evaluation state;
- answer recording and elapsed-time calculation;
- sound selection and feedback delay;
- random operation selection;
- report construction and result navigation;
- the full screen layout.

These responsibilities make gameplay logic depend on widget lifecycle and wall-clock time. Unit tests must pump the full screen to exercise most behavior.

## Architecture

### Configuration

`ActiveGameConfig` will contain the values that currently enter through the screen constructor:

- level number and stage title;
- timer duration and exam-mode flag;
- allowed operations and question count;
- prepared-session preservation flag.

The config will implement value equality so Riverpod can reuse one provider-family instance across rebuilds.

### View state

`ActiveGameState` will expose render-ready values:

- the current problem and answer options;
- selected answer and evaluation flag;
- visual-aid visibility and streak;
- answered count, total count, and progress fraction;
- remaining time and formatted timer text;
- stage label and exam-mode presentation flags;
- an optional completed `ExamReport`.

The UI will not derive gameplay rules from domain providers. The provider will map source state and local flow state into `ActiveGameState`.

### Providers and controller

`activeGameProvider(config)` will combine the current practice-session state with private active-game flow state. `ActiveGameScreen` will watch this provider.

`activeGameControllerProvider(config)` will expose `ActiveGameController`. The screen will read the controller in lifecycle hooks and callbacks.

The controller will own:

- session initialization;
- timer start, ticks, cancellation, and expiry;
- answer submission and duplicate-tap protection;
- answer history and question start time;
- practice-session evaluation and next-problem requests;
- sound decisions and feedback delay;
- `ExamReport` construction.

The controller will receive time, timer, delay, sound, and practice-session operations through injected functions or interfaces. Tests can then control time and asynchronous transitions without waiting for wall-clock delays.

### Screen

`ActiveGameScreen` will remain a `ConsumerStatefulWidget` because Flutter lifecycle still starts the game after the first frame. Its state object will:

- create one stable `ActiveGameConfig`;
- watch `activeGameProvider(config)`;
- call controller methods from lifecycle and tap callbacks;
- navigate when the completed report changes from absent to present.

The screen will not own timers, answer collections, scoring calculations, operation selection, or sound rules.

### Widgets

The refactor will extract these provider-free widgets:

- `ActiveGameAppBar` for progress, timer, streak, and back action;
- `GameStageBadge` for exam, stage, and operation labels;
- `ActiveGameProblemCard` for the equation and optional base-ten aid;
- `AnswerOptionsGrid` for the four answer choices;
- `GameMascotBar` for the hint footer.

Each widget will accept plain values and callbacks. `OptionCard` will no longer read the sound provider. The controller will preserve the existing sound sequence through its injected sound actions.

## Data Flow

1. The screen creates `ActiveGameConfig` from its constructor values.
2. After the first frame, the screen calls `start()` on the controller.
3. The controller resets the practice session unless the config preserves a prepared session.
4. The controller starts the countdown when the config contains a positive duration.
5. Riverpod maps practice-session state and local flow state into `ActiveGameState`.
6. The screen renders provider-free widgets from that state.
7. An answer tap calls `submitAnswer()` once while evaluation remains unlocked.
8. The controller records the submission, evaluates it, performs sound feedback, and advances or completes the game.
9. Completion stores one `ExamReport` in state. The screen observes that transition and replaces the route with the quest-complete screen.

Timer expiry and final-answer submission will call the same completion method. A completion guard will prevent duplicate reports and navigation.

## Scoring and Duration

The controller will keep the existing report rules:

- `correctCount` counts correct recorded submissions;
- `totalQuestions` uses the recorded-answer count when answers exist and the configured count when the timer expires before the first answer;
- timed sessions use configured duration minus remaining seconds;
- untimed sessions sum recorded answer durations.

The controller will copy the answer list into the report.

## Error Handling

The controller will release the evaluation lock if a dependency throws before the game advances or completes. It will propagate the error so tests and callers can observe it. The screen will avoid navigation after disposal.

Timer callbacks will ignore ticks after disposal or completion. Controller disposal will cancel the timer.

## Scope Boundaries

This work will not replace `practiceSessionProvider`, change problem generation, redesign the active-game UI, change route names, or refactor the quest-complete screen.

The refactor will preserve the existing exam and practice sound sequence. Sound cleanup can follow as a separate behavior change.

## Testing

Controller tests will cover:

- preserved and reset session initialization;
- countdown ticks, expiry, and disposal;
- answer timing and report accuracy;
- duplicate answer suppression;
- correct and incorrect sound paths;
- next-question operation selection;
- final-question completion and completion idempotency;
- dependency failure propagation and lock release.

Provider tests will verify mapping from practice and flow sources into `ActiveGameState`. Widget tests will verify each provider-free component and its callbacks. Screen tests will cover startup, navigation arguments, prepared sessions, and narrow-screen layout.

## Acceptance Criteria

- `ActiveGameScreen` contains no `Timer`, answer-history collection, scoring calculation, or sound decision.
- The screen watches view state and reads the controller for actions, matching `HomeDashboardScreen`.
- Extracted widgets contain no Riverpod or persistence imports.
- Presentation code contains no Hive or repository implementation references.
- Existing gameplay behavior and visual structure remain intact.
- New controller, provider, widget, and screen tests pass.
- The project test suite passes.
