# Written Answer Pad Visual Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refresh the shared Write-mode answer input with theme-derived surfaces, professional borders, clearer button hierarchy, and responsive standard/compact variants without changing gameplay behavior.

**Architecture:** Keep all visual composition inside the provider-free `WrittenAnswerPad`. Continue consuming the accent color supplied by Active Game or Buddy Challenge, combine it with `Theme.of(context).colorScheme` for surfaces and states, and retain the existing callbacks, keys, haptics, validation, and submission contract.

**Tech Stack:** Flutter, Dart, Material 3, Flutter Test

**Spec:** `docs/superpowers/specs/2026-10-26-written-answer-pad-visual-refresh-design.md`

## Global Constraints

- Use the active `ColorScheme` and the existing `accentColor` input; do not introduce a hardcoded feature palette.
- Existing `AppColors.successGreen` and `AppColors.errorRed` remain the only semantic result colors.
- Do not change answer validation, input locking, haptics, submission timing, response-mode selection, or public callback behavior.
- Keep `WrittenAnswerPad` free of Riverpod, persistence, repository, and platform-service imports.
- Preserve all existing widget keys and semantics; new visual wrappers may add stable keys for tests.
- The workspace has no Git metadata, so record execution evidence in `.superpowers/sdd/2026-10-26-written-answer-pad-visual-refresh/progress.md` instead of committing.

## Review Focus

- A dark or custom theme is active: surfaces and text remain derived from `ColorScheme`, not fixed white/black values.
- The answer is incomplete or input is locked: confirm, digits, and delete retain visible disabled shapes and do not become interactive.
- Correct or incorrect feedback is shown: the semantic result color overrides the accent only for answer/result decoration.
- Buddy Challenge uses compact mode: the keypad fits its arena and retains an icon confirmation action.
- Active Game uses standard mode at 390×844: the labeled `Check Answer` action and new panel do not overflow.

---

### Task 1: Theme-Derived Answer Console

**Files:**
- Modify: `lib/features/gameplay/presentation/widgets/written_answer_pad.dart`
- Modify: `test/features/gameplay/presentation/widgets/written_answer_pad_test.dart`
- Modify: `test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart`

**Interfaces:**
- Consumes: `WrittenAnswerPad.accentColor`, `compact`, `feedback`, `enabled`, `onInputFeedback`, and `onSubmit` without signature changes.
- Produces: keyed visual surfaces `written-answer-panel` and `written-keypad-panel`; standard mode exposes a labeled `Check Answer` button while compact mode retains the keyed icon confirmation control.

- [ ] **Step 1: Write failing standard-mode visual tests**

Add tests proving that standard mode renders the two keyed themed panels, preserves each answer slot, renders `Check Answer`, keeps `written-confirm`, and uses a full-width labeled primary button whose enabled state follows answer completeness.

- [ ] **Step 2: Run the standard visual tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/widgets/written_answer_pad_test.dart`

Expected: failure because the panel keys and labeled confirmation action do not exist.

- [ ] **Step 3: Write failing theme and state tests**

Pump a custom `ColorScheme` and assert the answer/keypad panel decorations, number-key foreground/border, delete styling, and confirm background derive from that scheme plus `accentColor`. Assert filled slots strengthen the accent border, disabled controls keep their shape, and correct/incorrect feedback uses the existing semantic colors.

- [ ] **Step 4: Implement the standard answer console**

In `written_answer_pad.dart`, derive surface, outline, shadow, text, and disabled colors from `Theme.of(context).colorScheme` and `accentColor`. Wrap slots and controls in rounded keyed `DecoratedBox`/`Container` surfaces. Use 20–24px outer radii, restrained theme-shadow elevation, 12–16px key radii, and theme-derived borders. In standard mode, keep digits 1–9 in a 3-column grid, place delete and zero in a balanced row, and place a full-width `FilledButton.icon` labeled `Check Answer` below them with key `written-confirm`.

- [ ] **Step 5: Implement the compact variant**

Retain the six-column compact grid and icon confirmation control, but apply the same theme-derived panel, border, number-key, delete, confirm, filled-slot, disabled, and semantic-feedback states at compact spacing and radii.

- [ ] **Step 6: Run shared and Buddy widget tests**

Run: `flutter test test/features/gameplay/presentation/widgets/written_answer_pad_test.dart test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart`

Expected: all tests pass, including locked input, haptic callback counts, standard label, compact icon action, theme colors, and semantic feedback.

### Task 2: Screen Integration and Final Verification

**Files:**
- Modify only if required by a failing integration assertion: `test/features/gameplay/presentation/screens/active_game_screen_test.dart`
- Modify only if required by a failing integration assertion: `test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart`
- Modify: `.superpowers/sdd/2026-10-26-written-answer-pad-visual-refresh/progress.md`

**Interfaces:**
- Consumes: the unchanged `WrittenAnswerPad` constructor and callback contract from Task 1.
- Produces: responsive verification evidence for Active Game and Buddy Challenge.

- [ ] **Step 1: Extend screen-level assertions**

Assert Active Game Write mode renders `Check Answer` and the answer console without overflow at 390×844. Assert Buddy Write mode renders the compact keypad without the standard label, remains locked after an accepted attempt, and has no overflow at its existing phone viewport.

- [ ] **Step 2: Run screen integration tests**

Run: `flutter test test/features/gameplay/presentation/screens/active_game_screen_test.dart test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart`

Expected: all tests pass with no layout exceptions.

- [ ] **Step 3: Format and scan architecture boundaries**

Run: `dart format lib test`

Run: `rg -n "flutter_riverpod|Hive|Repository|repositoryProvider|HapticFeedback" lib/features/gameplay/presentation/widgets/written_answer_pad.dart`

Expected: formatting changes no remaining files; architecture scan returns no matches.

- [ ] **Step 4: Run focused analysis**

Run: `flutter analyze lib/features/gameplay/presentation/widgets/written_answer_pad.dart test/features/gameplay/presentation/widgets/written_answer_pad_test.dart test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart test/features/gameplay/presentation/screens/active_game_screen_test.dart test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart`

Expected: no issues found.

- [ ] **Step 5: Run the full suite and analyzer**

Run: `flutter test --reporter compact`

Expected: all tests pass.

Run: `flutter analyze lib test`

Expected: no new diagnostics; report the established 22 unrelated legacy diagnostics separately if unchanged.

- [ ] **Step 6: Request independent review**

Review theme-token usage, contrast, disabled/feedback states, standard/compact responsiveness, accessibility semantics, unchanged input behavior, and provider-free boundaries. Resolve every Critical and Important finding before completion.
