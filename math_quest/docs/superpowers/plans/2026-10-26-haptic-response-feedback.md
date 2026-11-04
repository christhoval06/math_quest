# Haptic Response Feedback Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add layered native haptic feedback to Choice and Write answer interactions while honoring the existing global Haptic Touch Buzz setting.

**Architecture:** A core `IHapticService` hides Flutter platform calls and owns runtime enablement. Settings synchronizes that service after persistence; gameplay controllers emit semantic submit/result events; provider-free keypad widgets receive only an editing-feedback callback.

**Tech Stack:** Flutter, Dart, Riverpod, `HapticFeedback`, Flutter Test

**Spec:** `docs/superpowers/specs/2026-10-26-haptic-response-feedback-design.md`

## Global Constraints

- Do not add a package dependency; use Flutter's native `HapticFeedback`.
- The existing global `hapticBuzz` preference remains the source of truth and defaults to enabled.
- Exam mode must never emit correct/incorrect haptic feedback.
- Ignored, disabled, incomplete, stale, and duplicate interactions emit no haptic.
- Widgets remain provider-free and persistence-free; platform calls stay in the core implementation.
- This workspace has no Git metadata, so commit and branch steps are omitted and progress is recorded in `.superpowers/sdd/2026-10-26-haptic-response-feedback/progress.md`.

## Review Focus

- A platform haptic call throws: gameplay continues and the error does not escape the service.
- Haptics are disabled after startup or at runtime: every semantic event becomes a no-op.
- An exam answer is accepted: submit feedback occurs, but correct/incorrect feedback does not.
- A keypad key is disabled, full, or delete is empty: no editing feedback occurs.
- A Buddy attempt is stale or already consumed: no submission or result haptic occurs.

---

### Task 1: Core Haptic Service

**Files:**
- Create: `lib/core/haptics/i_haptic_service.dart`
- Create: `lib/core/haptics/haptic_service_impl.dart`
- Create: `lib/core/haptics/haptic_provider.dart`
- Create: `test/core/haptics/haptic_service_impl_test.dart`

**Interfaces:**
- Produces: `IHapticService` with `Future<void> selection()`, `answerSubmitted()`, `correctAnswer()`, `incorrectAnswer()`, and `void setEnabled(bool enabled)`.
- Produces: `hapticServiceProvider: Provider<IHapticService>`.
- `HapticServiceImpl` accepts optional injected async actions for tests; production defaults map selection to `HapticFeedback.selectionClick`, submit to `mediumImpact`, correct to `lightImpact`, and incorrect to `heavyImpact`.

- [ ] **Step 1: Write failing service tests**

  Prove each semantic method invokes only its mapped injected action, disabled mode suppresses every action, re-enabling restores calls, and a thrown platform error is contained.

- [ ] **Step 2: Run the service test and verify RED**

  Run: `flutter test test/core/haptics/haptic_service_impl_test.dart`

  Expected: compilation failure because the core service files do not exist.

- [ ] **Step 3: Implement the interface, guarded implementation, and provider**

  Catch platform exceptions inside the implementation. Keep enablement in memory and make all methods safe no-ops when disabled.

- [ ] **Step 4: Run focused tests and analysis**

  Run: `flutter test test/core/haptics/haptic_service_impl_test.dart`

  Run: `flutter analyze lib/core/haptics test/core/haptics`

  Expected: all focused tests pass and no diagnostics appear in the new files.

### Task 2: Connect Runtime Enablement to Settings

**Files:**
- Modify: `lib/features/settings_and_parent_gate/presentation/controllers/settings_controller.dart`
- Modify: `lib/features/settings_and_parent_gate/presentation/providers/settings_provider.dart`
- Modify: `lib/features/settings_and_parent_gate/presentation/widgets/settings_audio_card.dart`
- Modify: `test/features/settings_and_parent_gate/presentation/controllers/settings_controller_test.dart`
- Modify: `test/features/settings_and_parent_gate/presentation/screens/settings_screen_test.dart`

**Interfaces:**
- Consumes: `IHapticService` from Task 1.
- Produces: `SettingsController.synchronizeHaptics()` and a `setHapticBuzz(bool)` flow that updates the runtime service only after persistence succeeds.

- [ ] **Step 1: Write failing Settings controller tests**

  Assert startup synchronization applies persisted enabled/disabled state, a successful toggle updates persistence then runtime state, and a failed repository write never changes runtime enablement.

- [ ] **Step 2: Run the controller tests and verify RED**

  Run: `flutter test test/features/settings_and_parent_gate/presentation/controllers/settings_controller_test.dart`

  Expected: compile failures for the missing haptic dependency and synchronization method.

- [ ] **Step 3: Inject and synchronize `IHapticService`**

  Update all Settings controller construction sites and test fakes. Have `settingsControllerProvider` call both existing audio synchronization and the new haptic synchronization. Update the Settings subtitle to describe answer interaction and result feedback.

- [ ] **Step 4: Run Settings tests**

  Run: `flutter test test/features/settings_and_parent_gate/presentation/controllers/settings_controller_test.dart test/features/settings_and_parent_gate/presentation/providers/settings_provider_test.dart test/features/settings_and_parent_gate/presentation/screens/settings_screen_test.dart test/features/settings_and_parent_gate/presentation/widgets/settings_widgets_test.dart`

  Expected: all Settings tests pass.

### Task 3: Active Game and Written Keypad Feedback

**Files:**
- Modify: `lib/features/gameplay/presentation/providers/active_game_provider.dart`
- Modify: `lib/features/gameplay/presentation/screens/active_game_screen.dart`
- Modify: `lib/features/gameplay/presentation/widgets/written_answer_pad.dart`
- Modify: `test/features/gameplay/presentation/providers/active_game_provider_test.dart`
- Modify: `test/features/gameplay/presentation/screens/active_game_screen_test.dart`
- Modify: `test/features/gameplay/presentation/widgets/written_answer_pad_test.dart`

**Interfaces:**
- Consumes: `IHapticService` and `hapticServiceProvider` from Task 1.
- Produces: optional `WrittenAnswerPad.onInputFeedback: VoidCallback?`.
- Active controller consumes injected async actions for submitted, correct, and incorrect haptics.

- [ ] **Step 1: Write failing keypad tests**

  Assert successful digit insertion and non-empty delete each invoke input feedback once; full/disabled digit taps and empty delete do not invoke it; confirm does not invoke the editing callback.

- [ ] **Step 2: Run keypad tests and verify RED**

  Run: `flutter test test/features/gameplay/presentation/widgets/written_answer_pad_test.dart`

  Expected: compile failure because `onInputFeedback` does not exist.

- [ ] **Step 3: Implement valid-edit callbacks in the keypad**

  Invoke the callback only after local state actually changes. Do not add Riverpod or the service abstraction to the widget.

- [ ] **Step 4: Write failing Active Game controller tests**

  Assert an accepted normal answer emits submit then correct/incorrect; an exam answer emits submit only; rejected duplicate/in-flight submissions emit no second sequence; failure rollback remains retryable.

- [ ] **Step 5: Run Active Game tests and verify RED**

  Run: `flutter test test/features/gameplay/presentation/providers/active_game_provider_test.dart test/features/gameplay/presentation/screens/active_game_screen_test.dart`

  Expected: compile failures for missing haptic action dependencies or failed event assertions.

- [ ] **Step 6: Connect the provider and screen composition boundary**

  Inject service methods into `ActiveGameController`. Pass a selection callback from `ActiveGameScreen` to `WrittenAnswerPad`; submission/result feedback stays controller-owned so Choice and Write behave identically.

- [ ] **Step 7: Run Active Game and keypad tests**

  Run: `flutter test test/features/gameplay/presentation/providers/active_game_provider_test.dart test/features/gameplay/presentation/screens/active_game_screen_test.dart test/features/gameplay/presentation/widgets/written_answer_pad_test.dart`

  Expected: all focused tests pass, including exam privacy and ignored-edit cases.

### Task 4: Buddy Challenge Feedback

**Files:**
- Modify: `lib/features/gameplay/presentation/controllers/buddy_challenge_controller.dart`
- Modify: `lib/features/gameplay/presentation/providers/buddy_challenge_provider.dart`
- Modify: `lib/features/gameplay/presentation/screens/buddy_challenge_screen.dart`
- Modify: `lib/features/gameplay/presentation/widgets/buddy_playing_view.dart`
- Modify: `lib/features/gameplay/presentation/widgets/buddy_player_arena.dart`
- Modify: `test/features/gameplay/presentation/controllers/buddy_challenge_controller_test.dart`
- Modify: `test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart`
- Modify: `test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart`

**Interfaces:**
- Consumes: `IHapticService` from Task 1 and `WrittenAnswerPad.onInputFeedback` from Task 3.
- Buddy controller consumes synchronous semantic callbacks for submitted, correct, and incorrect events; provider adapters call async service methods without changing scoring timing.

- [ ] **Step 1: Write failing Buddy controller tests**

  Assert accepted correct and incorrect attempts emit submit followed by the matching result. Assert stale revisions, invalid phases, and already-answered players emit nothing.

- [ ] **Step 2: Run Buddy controller tests and verify RED**

  Run: `flutter test test/features/gameplay/presentation/controllers/buddy_challenge_controller_test.dart`

  Expected: compile failures for missing semantic callback dependencies.

- [ ] **Step 3: Implement controller feedback after validation**

  Keep all guard clauses before haptic callbacks. Preserve synchronous scoring and revision behavior.

- [ ] **Step 4: Write failing Buddy composition tests**

  Assert both compact written pads receive editing feedback, while locked pads ignore editing input. Confirm Choice answers still use controller-owned feedback.

- [ ] **Step 5: Run Buddy screen/widget tests and verify RED**

  Run: `flutter test test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart`

  Expected: failed feedback assertions until the provider/screen/view/arena chain is connected.

- [ ] **Step 6: Connect Buddy provider and provider-free widgets**

  Adapt async service calls with `unawaited` at the provider/screen boundary. Pass only `VoidCallback` through `BuddyPlayingView` and `BuddyPlayerArena`.

- [ ] **Step 7: Run all Buddy tests**

  Run: `flutter test test/features/gameplay/presentation/controllers/buddy_challenge_controller_test.dart test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart`

  Expected: all Buddy tests pass without responsive overflow.

### Task 5: Final Verification and Review

**Files:**
- Modify: `.superpowers/sdd/2026-10-26-haptic-response-feedback/progress.md`

**Interfaces:**
- Consumes: completed Tasks 1–4.
- Produces: verification and review evidence.

- [ ] **Step 1: Run formatter and focused architecture scan**

  Confirm presentation widgets import neither Hive nor repository implementations, and only `HapticServiceImpl` imports Flutter's `HapticFeedback`.

- [ ] **Step 2: Run full tests**

  Run: `flutter test --reporter compact`

  Expected: all tests pass.

- [ ] **Step 3: Run full analyzer**

  Run: `flutter analyze lib test`

  Expected: no new diagnostics; report the known legacy baseline separately if it remains.

- [ ] **Step 4: Request an independent code review**

  Review service gating, Settings synchronization, exam privacy, duplicate suppression, provider-free widget boundaries, and responsive Buddy behavior. Resolve all Critical and Important findings before completion.
