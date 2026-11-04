# Custom Mission MVVM Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor Custom Mission into a provider-driven MVVM screen with isolated widgets and working visual-aid and sound settings.

**Architecture:** A private Riverpod form notifier stores immutable mission selections. `customMissionProvider` combines that form with profile counters, while an injected `CustomMissionController` owns mutations and session preparation. The screen composes provider-free widgets, delegates actions, and performs navigation.

**Tech Stack:** Flutter, Dart, flutter_riverpod, flutter_test

**Spec:** `docs/superpowers/specs/2026-10-19-custom-mission-mvvm-design.md`

## Global Constraints

- Preserve the current Custom Mission layout, copy, defaults, and responsive behavior.
- Keep navigation in `CustomMissionScreen`.
- Keep Hive, data models, repository implementations, and concrete persistence APIs out of Custom Mission screen and widget files.
- Keep extracted widgets independent of Riverpod.
- Use immutable snapshots for operation collections and launch values.
- Make visual-aid and sound controls affect the launched game.
- Preserve existing behavior for Active Game callers through default argument values.
- The workspace has no Git metadata; replace commit steps with ledger checkpoints in `.superpowers/sdd/2026-10-19-custom-mission-mvvm/progress.md`.

## Review Focus

- A profile refresh while the form is open must update counters without resetting mission selections; Task 1 adds a provider-container test.
- Removing the last operation must leave it selected; Task 1 adds a controller test.
- Invalid timer and question values must throw before changing state; Task 1 tests both boundaries and state preservation.
- A prepared mission must not change when the form changes later; Task 1 tests immutable snapshot behavior.
- Sound-disabled practice and exam games must evaluate answers without calling any audio action; Task 2 tests both modes.

---

### Task 1: Custom Mission state and controller

**Files:**
- Create: `lib/features/mission_setup/presentation/providers/custom_mission_provider.dart`
- Create: `test/features/mission_setup/presentation/providers/custom_mission_provider_test.dart`
- Create: `.superpowers/sdd/2026-10-19-custom-mission-mvvm/progress.md`

**Interfaces:**
- Consumes: `MathOperation`, `DifficultyLevel`, `UserProfile?`, `profileNotifierProvider`, and `practiceSessionProvider`.
- Produces: `CustomMissionState`, `PreparedCustomMission`, `CustomMissionController`, `customMissionProvider`, and `customMissionControllerProvider`.

- [ ] **Step 1: Write failing state tests**

Test these names and assertions:

- `defaults match the existing custom mission screen`: Addition, Medium, 60 seconds, 10 questions, practice mode, visual aids on, sound on, 340 coins, and 5 streak days.
- `profile counters map with existing fallbacks`: map real `starCoins` and `currentStreak`; retain 340 and 5 for a null profile.
- `selected operations are immutable snapshots`: mutating the source set or exposed set cannot change state.
- `profile refresh preserves form selections`: override the profile and form sources in a provider container, update the profile source, and retain all form selections.

- [ ] **Step 2: Run state tests and verify RED**

Run: `flutter test test/features/mission_setup/presentation/providers/custom_mission_provider_test.dart`

Expected: compilation fails because `custom_mission_provider.dart` and its interfaces do not exist.

- [ ] **Step 3: Implement the state and provider composition**

Add:

```dart
class CustomMissionState {
  final Set<MathOperation> selectedOperations;
  final bool isExamMode;
  final DifficultyLevel selectedDifficulty;
  final int selectedTimerSeconds;
  final int selectedQuestionCount;
  final bool visualAidsEnabled;
  final bool soundEnabled;
  final int starCoins;
  final int streakDays;

  CustomMissionState({
    Set<MathOperation> selectedOperations = const {MathOperation.addition},
    this.isExamMode = false,
    this.selectedDifficulty = DifficultyLevel.medium,
    this.selectedTimerSeconds = 60,
    this.selectedQuestionCount = 10,
    this.visualAidsEnabled = true,
    this.soundEnabled = true,
    this.starCoins = 340,
    this.streakDays = 5,
  });

  CustomMissionState copyWith({
    Set<MathOperation>? selectedOperations,
    bool? isExamMode,
    DifficultyLevel? selectedDifficulty,
    int? selectedTimerSeconds,
    int? selectedQuestionCount,
    bool? visualAidsEnabled,
    bool? soundEnabled,
    int? starCoins,
    int? streakDays,
  });
  String get launchButtonLabel;
}
```

Use a private `StateNotifierProvider` for form state. Define `customMissionProvider` as a `Provider<CustomMissionState>` that combines the private form state with `profileNotifierProvider`, so profile changes do not recreate the form notifier.

- [ ] **Step 4: Run state tests and verify GREEN**

Run: `flutter test test/features/mission_setup/presentation/providers/custom_mission_provider_test.dart`

Expected: state tests pass.

- [ ] **Step 5: Write failing controller tests**

Test these behaviors through an injected controller:

- toggling an unselected operation adds it
- toggling a selected operation removes it when another remains
- toggling the final operation leaves state unchanged
- selecting practice mode enables visual aids
- selecting exam mode disables visual aids
- attempts to enable visual aids during exam mode leave them disabled
- difficulty and sound setters update one field
- timers accept only 0, 30, 60, and 120
- question counts accept only 10 through 50 in increments of 5
- invalid timer and question inputs throw `ArgumentError` without changing state
- `prepareMission` calls the injected preparation action once with first operation, difficulty, and visual-aid value
- the prepared result includes exam mode, timer, question count, sound, visual aids, and an immutable operation list
- later form mutations do not change a prepared result

- [ ] **Step 6: Run controller tests and verify RED**

Run: `flutter test test/features/mission_setup/presentation/providers/custom_mission_provider_test.dart`

Expected: failures for missing controller and launch interfaces.

- [ ] **Step 7: Implement controller and launch result**

Add:

```dart
class PreparedCustomMission {
  final List<MathOperation> allowedOperations;
  final DifficultyLevel difficulty;
  final int timerSeconds;
  final bool isExamMode;
  final int totalQuestions;
  final bool visualAidsEnabled;
  final bool soundEnabled;

  PreparedCustomMission({
    required List<MathOperation> allowedOperations,
    required this.difficulty,
    required this.timerSeconds,
    required this.isExamMode,
    required this.totalQuestions,
    required this.visualAidsEnabled,
    required this.soundEnabled,
  });
}

class CustomMissionController {
  CustomMissionController({
    required CustomMissionState Function() readState,
    required void Function(CustomMissionState) writeState,
    required void Function({
      required MathOperation operation,
      required DifficultyLevel difficulty,
      required bool visualAidsEnabled,
    }) prepareSessionAction,
  });

  void setExamMode(bool enabled);
  void toggleOperation(MathOperation operation);
  void selectDifficulty(DifficultyLevel difficulty);
  void selectTimer(int seconds);
  void setVisualAidsEnabled(bool enabled);
  void setSoundEnabled(bool enabled);
  void selectQuestionCount(int count);
  PreparedCustomMission prepareMission();
}
```

Connect `customMissionControllerProvider` to the private form notifier and `practiceSessionProvider`. The session action resets once, then sets visual aids to the requested value.

- [ ] **Step 8: Run Task 1 tests and checkpoint**

Run: `flutter test test/features/mission_setup/presentation/providers/custom_mission_provider_test.dart`

Expected: all tests pass. Record counts and any rulings in the ledger.

---

### Task 2: Practice-session and Active Game settings

**Files:**
- Modify: `lib/features/math_engine/presentation/providers/practice_session_notifier.dart`
- Modify: `lib/core/navigation/app_router.dart`
- Modify: `lib/features/gameplay/presentation/providers/active_game_provider.dart`
- Modify: `lib/features/gameplay/presentation/screens/active_game_screen.dart`
- Modify: `test/features/gameplay/presentation/providers/active_game_provider_test.dart`
- Modify: `test/features/gameplay/presentation/screens/active_game_screen_test.dart`
- Test: `test/features/mission_setup/presentation/providers/custom_mission_provider_test.dart`

**Interfaces:**
- Consumes: `PreparedCustomMission` from Task 1 and existing Active Game route/controller contracts.
- Produces: `PracticeSessionNotifier.setVisualAidsEnabled(bool)`, plus `visualAidsEnabled` and `soundEnabled` fields on `ActiveGameArgs` and `ActiveGameConfig`.

- [ ] **Step 1: Write failing practice-session and route tests**

Add tests proving:

- `setVisualAidsEnabled(false)` writes false and repeated false calls remain false
- `setVisualAidsEnabled(true)` writes true
- `ActiveGameArgs` defaults both settings to true
- route-to-screen mapping preserves explicit false values
- `ActiveGameConfig` equality and hash code include both settings

- [ ] **Step 2: Run the focused tests and verify RED**

Run: `flutter test test/features/mission_setup/presentation/providers/custom_mission_provider_test.dart test/features/gameplay/presentation/providers/active_game_provider_test.dart test/features/gameplay/presentation/screens/active_game_screen_test.dart`

Expected: failures for missing setters and fields.

- [ ] **Step 3: Implement the session setter and route/config fields**

Add `void setVisualAidsEnabled(bool enabled)` to `PracticeSessionNotifier` using `state.copyWith(showVisualAids: enabled)`.

Add these defaults to both `ActiveGameArgs` and `ActiveGameConfig`:

```dart
final bool visualAidsEnabled; // default true
final bool soundEnabled; // default true
```

Thread both values through `AppRouter`, `ActiveGameScreen`, and `_config`. Include both in `ActiveGameConfig.operator ==` and `hashCode`.

- [ ] **Step 4: Run the focused tests and verify GREEN**

Run the Step 2 command.

Expected: the new setting and route tests pass.

- [ ] **Step 5: Write failing sound behavior tests**

Add controller tests:

- `sound-disabled practice evaluates and delays without audio actions`
- `sound-disabled exam evaluates without audio actions or practice delay`
- existing sound-enabled practice and exam sequences remain unchanged

- [ ] **Step 6: Run controller tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/providers/active_game_provider_test.dart`

Expected: disabled-sound tests observe audio calls.

- [ ] **Step 7: Gate Active Game audio actions**

In `ActiveGameController._submitAnswer`, call tap, correct, and wrong actions only when `config.soundEnabled` is true. Keep answer evaluation and the 650 ms practice feedback delay independent of sound. Keep exam mode free of the practice delay.

- [ ] **Step 8: Run Task 2 tests and checkpoint**

Run: `flutter test test/features/mission_setup/presentation/providers/custom_mission_provider_test.dart test/features/gameplay/presentation/providers/active_game_provider_test.dart test/features/gameplay/presentation/screens/active_game_screen_test.dart`

Expected: all tests pass. Record counts and rulings in the ledger.

---

### Task 3: Provider-free Custom Mission widgets

**Files:**
- Create: `lib/features/mission_setup/presentation/widgets/custom_mission_app_bar.dart`
- Create: `lib/features/mission_setup/presentation/widgets/mission_lab_header.dart`
- Create: `lib/features/mission_setup/presentation/widgets/mission_mode_selector.dart`
- Create: `lib/features/mission_setup/presentation/widgets/mission_operation_grid.dart`
- Create: `lib/features/mission_setup/presentation/widgets/mission_difficulty_selector.dart`
- Create: `lib/features/mission_setup/presentation/widgets/mission_timer_selector.dart`
- Create: `lib/features/mission_setup/presentation/widgets/mission_helper_toggles.dart`
- Create: `lib/features/mission_setup/presentation/widgets/mission_question_selector.dart`
- Create: `lib/features/mission_setup/presentation/widgets/mission_reward_banner.dart`
- Create: `lib/features/mission_setup/presentation/widgets/mission_launch_button.dart`
- Create: `test/features/mission_setup/presentation/widgets/custom_mission_widgets_test.dart`

**Interfaces:**
- Consumes: primitive display values, `MathOperation`, `DifficultyLevel`, and callbacks.
- Produces: the ten provider-free widgets named in the spec.

- [ ] **Step 1: Write failing widget tests**

Cover these contracts:

- app bar renders coins and streak and invokes back
- mode selector renders selected mode and sends `false` or `true`
- operation grid renders four operations and reports the tapped operation
- difficulty selector reports the tapped difficulty
- timer selector reports 0, 30, 60, or 120
- helper toggles report visual-aid and sound changes and disable visual-aid input in exam mode
- question selector renders the count, reports slider changes, and reports shortcut taps
- launch button renders the supplied label and invokes launch
- lab header and reward banner preserve current copy

- [ ] **Step 2: Run widget tests and verify RED**

Run: `flutter test test/features/mission_setup/presentation/widgets/custom_mission_widgets_test.dart`

Expected: compilation fails because the widget files do not exist.

- [ ] **Step 3: Extract the widgets**

Move the existing visual code into the named `StatelessWidget` classes. Replace deprecated `withOpacity` calls with `withValues(alpha: ...)`. Pass colors derived from mode or theme through constructor values where needed. Do not import Riverpod, profile providers, session providers, Hive, models, or repositories.

- [ ] **Step 4: Run widget tests and checkpoint**

Run: `flutter test test/features/mission_setup/presentation/widgets/custom_mission_widgets_test.dart`

Expected: all widget tests pass. Record counts in the ledger.

---

### Task 4: Thin Custom Mission screen and navigation

**Files:**
- Replace: `lib/features/mission_setup/presentation/screens/custom_mission_screen.dart`
- Create: `test/features/mission_setup/presentation/screens/custom_mission_screen_test.dart`

**Interfaces:**
- Consumes: providers and widgets from Tasks 1 and 3, `PreparedCustomMission`, and extended `ActiveGameArgs` from Task 2.
- Produces: a thin `CustomMissionScreen` that owns composition and navigation.

- [ ] **Step 1: Write failing screen tests**

Use provider overrides and a recording controller to prove:

- the screen renders profile counters and selected form values from `customMissionProvider`
- tapping a mode, operation, difficulty, timer, helper, question shortcut, or slider delegates to the matching controller method
- launch calls `prepareMission` once
- launch navigates to `AppRoutes.activeGame`
- route arguments contain the prepared operation list, timer, mode, question count, visual-aid setting, sound setting, and `preservePreparedSession: true`
- back pops when the route can pop
- the complete screen renders without overflow at 390 by 844

- [ ] **Step 2: Run screen tests and verify RED**

Run: `flutter test test/features/mission_setup/presentation/screens/custom_mission_screen_test.dart`

Expected: tests fail because the current screen owns local state and direct session preparation.

- [ ] **Step 3: Replace the screen with composition and delegation**

Implement `CustomMissionScreen extends ConsumerWidget`. Watch `visualThemeProvider` and `customMissionProvider`. Read `customMissionControllerProvider` inside callbacks. Build the ten extracted widgets in the existing order and spacing.

The launch callback converts `PreparedCustomMission` into:

```dart
ActiveGameArgs(
  timerSeconds: mission.timerSeconds,
  isExamMode: mission.isExamMode,
  allowedOperations: mission.allowedOperations,
  totalQuestions: mission.totalQuestions,
  preservePreparedSession: true,
  visualAidsEnabled: mission.visualAidsEnabled,
  soundEnabled: mission.soundEnabled,
)
```

- [ ] **Step 4: Run screen and feature tests**

Run: `flutter test test/features/mission_setup test/features/gameplay/presentation`

Expected: all tests pass.

- [ ] **Step 5: Mutation-check the launch boundary**

Temporarily set `preservePreparedSession: false` in the screen and run its launch test. Expected: RED because Active Game would reset the prepared mission. Restore `true`, rerun, and expect GREEN. Record the mutation check in the ledger.

- [ ] **Step 6: Checkpoint Task 4**

Record test counts, the final screen line count, and any rulings in the ledger.

---

### Task 5: Boundary checks and final verification

**Files:**
- Modify: `.superpowers/sdd/2026-10-19-custom-mission-mvvm/progress.md`
- Verify: all files changed by Tasks 1 through 4

**Interfaces:**
- Consumes: the completed Custom Mission and Active Game integration.
- Produces: formatted, analyzed, regression-tested code with recorded evidence.

- [ ] **Step 1: Format changed Dart files**

Run: `dart format <all changed Dart files>`

Expected: formatter exits 0.

- [ ] **Step 2: Verify separation and persistence boundaries**

Run `rg` over `custom_mission_screen.dart` and the new Custom Mission widget directory. Assert zero matches for:

- `Hive`
- `RepositoryImpl`
- `profileRepositoryProvider`
- `practiceSessionProvider`
- `soundServiceProvider`
- `setState`

Run `rg` over the widget directory and assert zero matches for `flutter_riverpod` and `ConsumerWidget`.

- [ ] **Step 3: Analyze changed files**

Run `flutter analyze` with every changed library and test path.

Expected: no issues in changed files.

- [ ] **Step 4: Run the complete test suite**

Run: `flutter test`

Expected: all tests pass.

- [ ] **Step 5: Run full-project analysis**

Run: `flutter analyze`

Expected: no new diagnostics. Compare the result with the current baseline of 40 pre-existing diagnostics.

- [ ] **Step 6: Record completion evidence**

Append formatter, boundary-scan, focused-analysis, full-test, and full-analysis results to the ledger. Record deferred findings with their cost if any remain.
