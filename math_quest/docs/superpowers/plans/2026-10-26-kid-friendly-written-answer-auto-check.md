# Kid-Friendly Written Answer Auto-Check Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give Write mode playful theme-derived controls and submit a complete typed answer once after a 450 ms preview delay.

**Architecture:** Keep all transient input and timer ownership inside the provider-free `WrittenAnswerPad`. Add no screen, provider, repository, or settings dependencies; Active Game and Buddy Challenge inherit the shared behavior without contract changes.

**Tech Stack:** Flutter, Dart, Material 3, `flutter_test`

**Spec:** `docs/superpowers/specs/2026-10-26-kid-friendly-written-answer-auto-check-design.md`

## Global Constraints

- Use only active `ColorScheme` values and the existing `accentColor`; add no fixed decorative palette.
- Schedule automatic submission exactly 450 ms after the final digit.
- Preserve manual confirmation, failure retry, haptic callback, standard/compact layouts, and one-submission locking.
- Keep `WrittenAnswerPad` free of Riverpod, persistence, repositories, and platform services.

## Review Focus

- A manual confirmation during the 450 ms window must cancel the pending automatic check and submit only once.
- Deleting a digit during the delay must cancel the pending automatic check.
- Disabling or disposing the pad during the delay must prevent a late submission.
- A failed automatic submission must unlock the same completed answer for an explicit retry without creating an automatic retry loop.
- Compact Buddy Challenge controls must remain at least 44 px high and fit at 390×844.

---

### Task 1: Playful keypad styling and delayed auto-check

**Files:**
- Modify: `lib/features/gameplay/presentation/widgets/written_answer_pad.dart`
- Test: `test/features/gameplay/presentation/widgets/written_answer_pad_test.dart`
- Test: `test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart`

**Interfaces:**
- Consumes: existing `WrittenAnswerPad` constructor and callbacks unchanged.
- Produces: theme-derived raised digit controls and internal 450 ms auto-check scheduling; no new public API.

- [ ] **Step 1: Write failing behavior tests**

Add widget tests asserting that a complete answer does not submit before 449 ms, submits once at 450 ms, manual confirmation cancels the timer, deletion/disable/disposal cancel it, and a failed automatic submission unlocks for manual retry without rescheduling itself.

- [ ] **Step 2: Write failing visual tests**

Assert digit controls use an accent-tinted theme-derived background, accessible foreground, rounded bordered shape, visible elevation/shadow, and retain a minimum 44 px compact height. Assert the confirmation control exposes an in-progress indicator while submission is pending.

- [ ] **Step 3: Run focused tests to verify RED**

Run: `flutter test test/features/gameplay/presentation/widgets/written_answer_pad_test.dart test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart --reporter compact`

Expected: FAIL because auto-check scheduling, playful visual tokens, and submission progress are absent.

- [ ] **Step 4: Implement timer lifecycle and styling**

In `_WrittenAnswerPadState`, add a nullable `Timer`, cancel helper, widget-update/dispose cancellation, and a 450 ms schedule from `_addDigit` only when the new value completes the answer. `_submit` cancels the timer before setting the existing lock; an exception unlocks without scheduling another timer. Restyle `_DigitButton` from active theme/accent values and show progress in the standard and compact confirmation controls while `_hasSubmitted` is true.

- [ ] **Step 5: Run focused tests to verify GREEN**

Run the Step 3 command.

Expected: all focused widget tests pass with no exceptions.

- [ ] **Step 6: Verify screen integration and responsive layouts**

Run: `flutter test test/features/gameplay/presentation/screens/active_game_screen_test.dart test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart --reporter compact`

Expected: all Active Game and Buddy Challenge tests pass, including 390×844 coverage.

- [ ] **Step 7: Verify quality gates**

Run focused `flutter analyze` on the production widget and four affected widget/screen test files, then `flutter test --reporter compact`.

Expected: focused analysis has no issues and the complete test suite passes.

- [ ] **Step 8: Record integration state**

If Git metadata remains unavailable, record the no-Git limitation and retain the verified changes directly in the workspace instead of attempting a commit.
