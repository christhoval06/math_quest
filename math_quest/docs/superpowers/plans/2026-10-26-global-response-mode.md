# Global Response Mode Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a persistent device-wide Choice/Write response preference and apply it to every playable math question through Active Game and Buddy Challenge.

**Architecture:** Settings owns and persists a `ResponseMode` enum, exposing only a focused read-only provider to gameplay. A provider-free `WrittenAnswerPad` owns transient digit editing, while existing gameplay controllers continue to accept and evaluate integer submissions.

**Tech Stack:** Flutter, Dart, Riverpod 2.6, Hive, flutter_test.

**Spec:** `docs/superpowers/specs/2026-10-26-global-response-mode-design.md`

## Global Constraints

- Response Mode is global for the device, not profile-specific.
- Supported values are exactly `choice` and `write`.
- Missing or malformed persistence defaults to `choice`.
- Choice mode preserves the current UI and behavior.
- Write mode uses answer-length digit slots, an in-app keypad, delete, and explicit confirm.
- Only confirm submits an attempt.
- Existing controllers remain the authority for scoring and acceptance.
- Buddy's one-attempt-per-player behavior applies to confirmed written answers.
- Gameplay widgets must not import Hive or repositories.
- `WrittenAnswerPad` and Settings selector widgets must not import Riverpod.
- Written input must fit Active Game and both Buddy arenas at 390×844.

## Review Focus

- A missing/corrupt stored mode must never prevent app startup and must render Choice.
- Persistence failure must keep the prior in-memory mode.
- Rapid confirm taps must submit once; a failed Active Game submission must become retryable.
- Zero, incomplete input, full input, extra digits, and empty delete must behave correctly.
- Written input must reset only when the question changes, including both Buddy arenas after two wrong answers.

---

### Task 1: Response Mode Domain and Persistence

**Files:**
- Create: `lib/features/settings_and_parent_gate/domain/entities/response_mode.dart`
- Modify: `lib/features/settings_and_parent_gate/domain/entities/settings_preferences.dart`
- Modify: `lib/features/settings_and_parent_gate/domain/repositories/i_settings_repository.dart`
- Modify: `lib/features/settings_and_parent_gate/data/repositories/settings_repository_impl.dart`
- Modify: `test/features/settings_and_parent_gate/data/repositories/settings_repository_impl_test.dart`

**Interfaces:**
- Produces: `enum ResponseMode { choice, write }`, `SettingsPreferences.responseMode`, `SettingsPreferences.copyWith(responseMode:)`, and `ISettingsRepository.saveResponseMode(ResponseMode mode)`.
- Persistence key: `response_mode`; stored values: `choice` and `write`; fallback: `ResponseMode.choice`.

- [ ] Write failing repository tests for missing value, `write` loading, malformed fallback, and exact save value.
- [ ] Run the repository tests and verify RED because the preference and repository method do not exist.
- [ ] Implement the enum, immutable preference field/copy behavior, repository decoding, and save method.
- [ ] Run the repository tests and focused analysis GREEN.

### Task 2: Settings State, Controller, Provider, and Selector

**Files:**
- Modify: `lib/features/settings_and_parent_gate/presentation/models/settings_state.dart`
- Modify: `lib/features/settings_and_parent_gate/presentation/controllers/settings_controller.dart`
- Modify: `lib/features/settings_and_parent_gate/presentation/providers/settings_provider.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/settings_response_mode_selector.dart`
- Modify: `lib/features/settings_and_parent_gate/presentation/screens/settings_screen.dart`
- Modify: `test/features/settings_and_parent_gate/presentation/controllers/settings_controller_test.dart`
- Modify: `test/features/settings_and_parent_gate/presentation/providers/settings_provider_test.dart`
- Modify: `test/features/settings_and_parent_gate/presentation/widgets/settings_widgets_test.dart`
- Modify: `test/features/settings_and_parent_gate/presentation/screens/settings_screen_test.dart`

**Interfaces:**
- Consumes: Task 1 `ResponseMode` and `saveResponseMode`.
- Produces: `SettingsState.responseMode`, `SettingsController.setResponseMode(ResponseMode)`, public read-only `responseModeProvider`, and provider-free `SettingsResponseModeSelector(selectedMode:, onChanged:)`.

- [ ] Write failing controller tests that successful persistence updates memory, failure preserves the prior mode, and overlapping mutations serialize/rebase correctly.
- [ ] Write failing provider/widget/screen tests for default propagation, selector rendering/callback, controller delegation, and persistence error feedback without a Parent Gate.
- [ ] Run focused Settings tests and verify RED.
- [ ] Implement state/provider/controller flow, update all `ISettingsRepository` test doubles, create the selector, and place it in Settings before the Parent Zone.
- [ ] Run focused Settings tests and focused analysis GREEN.

### Task 3: Reusable Written Answer Pad

**Files:**
- Create: `lib/features/gameplay/presentation/widgets/written_answer_pad.dart`
- Create: `test/features/gameplay/presentation/widgets/written_answer_pad_test.dart`

**Interfaces:**
- Produces: `enum WrittenAnswerFeedback { neutral, correct, incorrect }` and `WrittenAnswerPad(digitCount:, enabled:, accentColor:, feedback:, onSubmit:)` where `onSubmit` is `Future<void> Function(int)`.
- The widget key supplied by its parent defines question identity and resets local digits when it changes.

- [ ] Write failing widget tests for digit-slot count, digit entry order, incomplete confirm, zero, extra-digit rejection, delete/empty-delete, disabled controls, semantic labels, feedback styling, double-confirm coalescing, retry after submission failure, and 390×844 layout.
- [ ] Run the new widget test and verify RED because the component is absent.
- [ ] Implement a provider-free stateful pad with digits `1–9`, delete, `0`, confirm, local in-flight protection, and accessible digit/entry semantics.
- [ ] Run the pad tests and focused analysis GREEN.

### Task 4: Active Game Global Mode Integration

**Files:**
- Modify: `lib/features/gameplay/presentation/screens/active_game_screen.dart`
- Modify: `test/features/gameplay/presentation/screens/active_game_screen_test.dart`
- Modify: `test/features/gameplay/presentation/widgets/active_game_widgets_test.dart` only if shared fixture coverage requires it.

**Interfaces:**
- Consumes: Task 2 `responseModeProvider`; Task 3 `WrittenAnswerPad`.
- Produces: Choice rendering through existing `AnswerOptionsGrid`, or Write rendering keyed by `ObjectKey(state.problem)` and submitting through `ActiveGameController.submitAnswer(int)`.

- [ ] Write failing screen tests that Choice remains the default, Write hides option cards, correct and incorrect written values reach the real controller, exam mode stays neutral, evaluation disables the pad, and the next `MathProblem` clears input.
- [ ] Run Active Game screen tests and verify RED.
- [ ] Watch `responseModeProvider` at the screen composition boundary and render the selected provider-free input; derive digit count from the non-negative correct answer without moving scoring into the widget.
- [ ] Run Active Game tests and focused analysis GREEN.

### Task 5: Buddy Challenge Global Mode Integration

**Files:**
- Modify: `lib/features/gameplay/presentation/screens/buddy_challenge_screen.dart`
- Modify: `lib/features/gameplay/presentation/widgets/buddy_playing_view.dart`
- Modify: `lib/features/gameplay/presentation/widgets/buddy_player_arena.dart`
- Modify: `test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart`
- Modify: `test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart`

**Interfaces:**
- Consumes: Task 2 `responseModeProvider`; Task 3 `WrittenAnswerPad`; existing `BuddyChallengeState.hasAnswered(int)`.
- Produces: per-player Choice or Write rendering, with Write pads keyed by player number plus `problem.revision` and submissions delegated to the existing controller.

- [ ] Write failing widget/screen tests proving Choice is unchanged; Write renders two pads; confirm locks only that player; incomplete input does not consume an attempt; the opponent remains active; correct confirmation scores; and a correct or double-wrong advance resets both pads.
- [ ] Run Buddy tests and verify RED.
- [ ] Pass the global mode through the screen/view/arena boundary and render the shared pad with per-player enabled state and async submission adapter.
- [ ] Run all Buddy tests and focused analysis GREEN.

### Task 6: Architecture, Full Verification, and Review

**Files:**
- Modify only files above when fixing Critical or Important findings.

**Interfaces:**
- Consumes: Tasks 1–5.
- Produces: verified global Response Mode behavior.

- [ ] Format every changed Dart file.
- [ ] Scan gameplay widgets for Hive/repository imports and new provider-free widgets for Riverpod imports.
- [ ] Run all Settings, Written Answer, Active Game, and Buddy tests plus focused analysis.
- [ ] Run the complete Flutter test suite and full analyzer; distinguish changed-path issues from legacy diagnostics.
- [ ] Request independent review focused on persistence fallback/rollback, complete gameplay coverage, rapid submission, question reset identity, Buddy fairness, responsive layout, and MVVM/database boundaries; fix Critical/Important findings RED→GREEN.
