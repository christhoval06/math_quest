# Simplified Written-Answer Controls Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Hide delete and manual confirmation by default, keep the keypad balanced, and reveal an accessible retry action only after automatic submission fails.

**Architecture:** Extend the provider-free `WrittenAnswerPad` API with two default-false presentation flags. Keep control visibility, automatic-check progress, and failure-only retry state local to the widget; consuming screens inherit the new defaults without provider or controller changes.

**Tech Stack:** Flutter, Dart, Material 3, `flutter_test`

**Spec:** `docs/superpowers/specs/2026-10-26-hide-written-answer-delete-design.md`

## Global Constraints

- `showDeleteButton` and `showCheckButton` both default to `false`.
- Automatic submission remains exactly 450 ms after the final digit.
- Submission failure must not retry automatically; it reveals one explicit **Try Again** action.
- Explicitly enabling either flag restores its corresponding existing behavior.
- Add no provider, repository, persistence, settings, or platform dependency to `WrittenAnswerPad`.

## Review Focus

- Default standard and compact layouts must have no invisible, focusable, tooltip, or semantics targets for hidden controls.
- Compact default mode must remain two balanced rows and retain at least 44 px touch targets at 390×844.
- A failure occurring while manual confirmation is hidden must expose exactly one retry action and never reschedule itself.
- A pending automatic check must still be cancellable when delete is explicitly enabled.
- Checking progress must remain visible, high-contrast, and announced as a live status even though the normal confirmation button is absent.

---

### Task 1: Default-hidden controls and failure-safe retry

**Files:**
- Modify: `lib/features/gameplay/presentation/widgets/written_answer_pad.dart`
- Test: `test/features/gameplay/presentation/widgets/written_answer_pad_test.dart`
- Test: `test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart`
- Test: `test/features/gameplay/presentation/screens/active_game_screen_test.dart`
- Test: `test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart`

**Interfaces:**
- Consumes: existing `WrittenAnswerPad` constructor, 450 ms automatic submission, and callbacks.
- Produces: optional `bool showDeleteButton = false` and `bool showCheckButton = false`; no other public API changes.

- [x] **Step 1: Write failing default-visibility and layout tests**

Assert default standard and compact pads render neither `written-delete` nor `written-confirm`; standard **0** fills the centered bottom row; compact defaults to a balanced five-column/two-row grid with controls at least 44 px high; semantics and tooltips expose neither hidden action.

- [x] **Step 2: Write failing opt-in and failure tests**

Assert `showDeleteButton: true` restores delete and cancels pending auto-check, `showCheckButton: true` restores standard/compact confirmation, hidden-check submission progress remains a high-contrast `Checking answer` live status, and a thrown automatic submission reveals exactly one accessible `Try Again` action whose tap submits once without an automatic loop.

- [x] **Step 3: Update screen integration tests for the default automatic flow**

Change Active Game and Buddy Challenge Write-mode tests to assert the normal controls are absent and pump 450 ms after completing input instead of tapping confirmation; retain the 390×844 no-overflow assertions.

- [x] **Step 4: Run focused tests to verify RED**

Run: `flutter test test/features/gameplay/presentation/widgets/written_answer_pad_test.dart test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart test/features/gameplay/presentation/screens/active_game_screen_test.dart test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart --reporter compact`

Expected: FAIL because controls are currently visible by default, flags and retry state do not exist, and default screen tests still expose manual controls.

- [x] **Step 5: Implement flags, balanced layouts, status, and retry**

Add the two constructor fields. In state, track whether the last submission failed; clear it on a new edit or retry. Standard mode renders a full-width centered **0** when delete is hidden. Compact mode uses five columns only when both normal controls are hidden. Render checking as a non-interactive live status when check is hidden, and render a themed retry control after failure; explicit opt-ins preserve existing controls.

- [x] **Step 6: Run focused tests to verify GREEN**

Run the Step 4 command.

Expected: all focused widget and screen tests pass with no exceptions or overflow.

- [x] **Step 7: Verify quality gates**

Run focused `flutter analyze` on the production widget and four affected test files, scan the widget for provider/persistence/platform imports, then run `flutter test --reporter compact`.

Expected: focused analysis has no issues, the architecture scan is empty, and the complete suite passes.

- [x] **Step 8: Record integration state**

If Git metadata remains unavailable, retain the verified changes directly in the workspace and record that no branch, commit, or pull-request integration was possible.
