# Smooth Written-Answer Checking Status Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prevent brief `Checking…` flicker while retaining delayed, accessible progress feedback and an opt-out property.

**Architecture:** Extend the provider-free `WrittenAnswerPad` API with `showCheckingStatus`, defaulting to `true`. Keep a separate 250 ms presentation timer in widget state; submission locking starts immediately, while visible and semantic status starts only if the submission remains pending after that timer.

**Tech Stack:** Flutter, Dart, Material 3, `flutter_test`

**Spec:** `docs/superpowers/specs/2026-10-27-written-answer-checking-status-design.md`

## Global Constraints

- Preserve the existing 450 ms automatic-submission delay.
- `showCheckingStatus` defaults to `true`.
- Checking status becomes visible and announced only after 250 ms of pending submission.
- `showCheckingStatus: false` suppresses visible and semantic checking status.
- Failure always reveals the existing accessible `Try Again` action.
- Do not change answer locking, retry, haptic, provider, repository, or persistence behavior.

## Review Focus

- A submission completing before 250 ms must never render or announce checking status.
- A pending submission must remain quiet at 249 ms and expose one live status at 250 ms.
- Disposing the pad or completing submission must cancel the presentation timer without a post-dispose callback.
- `showCheckingStatus: false` must suppress status in standard and compact modes while preserving submission.
- A thrown submission must reveal `Try Again` even when the progress status never appeared or is disabled.

---

### Task 1: Delayed and optional checking status

**Files:**
- Modify: `lib/features/gameplay/presentation/widgets/written_answer_pad.dart`
- Test: `test/features/gameplay/presentation/widgets/written_answer_pad_test.dart`

**Interfaces:**
- Consumes: existing `WrittenAnswerPad`, its 450 ms auto-submit timer, and `Future<void> Function(int) onSubmit`.
- Produces: `bool showCheckingStatus = true`; internal 250 ms status delay with no provider or persistence dependency.

- [x] **Step 1: Write failing fast/slow status tests**

Add tests asserting an immediately completed submission never exposes `Checking…` or `Checking answer`; a pending submission exposes neither at 249 ms and both at 250 ms; cover standard automatic flow and explicit Check-button flow.

- [x] **Step 2: Write failing opt-out and failure tests**

Assert `showCheckingStatus: false` keeps long-running standard and compact submissions visually and semantically quiet, while a thrown submission still reveals exactly one accessible `Try Again` action.

- [x] **Step 3: Run focused tests to verify RED**

Run: `flutter test test/features/gameplay/presentation/widgets/written_answer_pad_test.dart --reporter compact`

Expected: FAIL because the public property and delayed presentation state do not exist and status currently renders immediately.

- [x] **Step 4: Implement the delayed status state**

Add `showCheckingStatus`; add a 250 ms timer and a boolean controlling status visibility. Start that timer when submission begins, cancel and clear it on completion, failure, widget disposal, and relevant widget updates. Continue rendering failure retry independently from status visibility. Apply the delayed status consistently to hidden and explicit standard/compact confirmation paths.

- [x] **Step 5: Run focused tests to verify GREEN**

Run the Step 3 command.

Expected: all written-answer pad tests pass with no pending-timer, semantics, or overflow exceptions.

- [x] **Step 6: Verify integrations and quality gates**

Run focused tests for the pad, Active Game, and Buddy Challenge; run focused `flutter analyze` on the production widget and affected tests; then run `flutter test --reporter compact`.

Expected: analysis has no issues and all focused and complete tests pass.

- [x] **Step 7: Record integration state**

If Git metadata remains unavailable, retain the verified change directly in the shared workspace and record that branch, commit, and pull-request integration were unavailable.
