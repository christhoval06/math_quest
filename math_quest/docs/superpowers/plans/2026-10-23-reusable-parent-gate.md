# Reusable Parent Gate Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace duplicated parent-gate dialogs with one professional, reusable, testable full-screen verification flow.

**Architecture:** An immutable state/controller validates the existing domain challenge. A thin Riverpod screen renders provider-free widgets and returns a boolean route result through one shared launcher configured for each protected purpose.

**Tech Stack:** Flutter, Dart, Riverpod 2.6, flutter_test.

**Spec:** `docs/superpowers/specs/2026-10-23-reusable-parent-gate-design.md`

## Global Constraints

- Verification authorizes only the requested action.
- Keep `ParentGateChallenge` and `ParentGateChallengeGenerator` in the domain layer.
- No dialogs for the multiplication gate.
- Extracted widgets must not import Riverpod.
- Incorrect answers stay on-screen and can be retried.
- Preserve existing protected Settings and +15-minute screen-time behavior.

## Review Focus

- Empty, non-numeric, and incorrect input must never unlock the action.
- A correct answer submitted from the keyboard or button must return success once.
- Back/cancel must return false and never run the protected action.
- Repeated taps must not produce duplicate route results or actions.
- Long purpose copy and the numeric keyboard layout must fit 390×844 without overflow.

---

### Task 1: Parent Gate State and Controller

**Files:**
- Create: `lib/features/settings_and_parent_gate/presentation/models/parent_gate_state.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/controllers/parent_gate_controller.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/providers/parent_gate_provider.dart`
- Test: `test/features/settings_and_parent_gate/presentation/controllers/parent_gate_controller_test.dart`

**Interfaces:**
- Consumes: `ParentGateChallenge.accepts(String)`.
- Produces: immutable `ParentGateState`, `ParentGateController.setAnswer(String)`, and `ParentGateController.verify()`.

- [ ] Write failing tests for empty, non-numeric, incorrect, correct, error-clearing, and duplicate verification behavior.
- [ ] Run the controller tests and verify RED.
- [ ] Implement state, controller, and auto-dispose family provider.
- [ ] Run the controller tests and verify GREEN.

### Task 2: Professional Provider-Free UI and Full-Screen Route

**Files:**
- Create: `lib/features/settings_and_parent_gate/presentation/models/parent_gate_config.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/parent_gate_widgets.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/screens/parent_gate_screen.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/navigation/parent_gate_launcher.dart`
- Delete: `lib/features/settings_and_parent_gate/presentation/widgets/parent_gate_dialog.dart`
- Test: `test/features/settings_and_parent_gate/presentation/widgets/parent_gate_widgets_test.dart`
- Test: `test/features/settings_and_parent_gate/presentation/screens/parent_gate_screen_test.dart`

**Interfaces:**
- Consumes: Task 1 provider and a `ParentGateConfig`.
- Produces: `ParentGateLauncher.requestAccess(BuildContext, {required ParentGateChallenge challenge, required ParentGateConfig config}) -> Future<bool>`.

- [ ] Write failing widget tests for professional content, callbacks, error state, accessibility, and 390×844 layout.
- [ ] Write failing screen tests for correct unlock, wrong-answer retry, keyboard submit, cancel, and system back.
- [ ] Implement config, provider-free widgets, thin screen, and full-screen launcher.
- [ ] Remove the obsolete dialog and run focused tests GREEN.

### Task 3: Reuse Across Settings and Screen Time

**Files:**
- Modify: `lib/features/settings_and_parent_gate/presentation/screens/settings_screen.dart`
- Modify: `lib/core/navigation/main_navigation_shell.dart`
- Modify: `test/features/settings_and_parent_gate/presentation/screens/settings_screen_test.dart`
- Modify: `test/features/settings_and_parent_gate/presentation/widgets/settings_widgets_test.dart`

**Interfaces:**
- Consumes: `ParentGateLauncher.requestAccess(...)` and purpose-specific `ParentGateConfig` factories.
- Produces: the same protected Settings actions and +15-minute extension through the shared screen.

- [ ] Write or update failing integration tests proving cancel/wrong answers do not run protected actions and correct answers do.
- [ ] Replace Settings `showDialog` and navigation-shell inline challenge code with the shared launcher.
- [ ] Remove obsolete dialog tests/imports and run integration tests GREEN.

### Task 4: Verification and Review

**Files:**
- Modify only the files above if verification finds issues.

**Interfaces:**
- Consumes: Tasks 1–3.
- Produces: a verified reusable parent gate.

- [ ] Format all changed Dart files.
- [ ] Scan the new widgets for Riverpod and scan the screen for database/repository imports.
- [ ] Run focused tests and focused analysis.
- [ ] Run the full Flutter test suite and full analyzer.
- [ ] Request an independent review focused on authorization correctness, navigation lifecycle, repeated submission, responsiveness, and reuse; fix Critical/Important findings RED→GREEN.
