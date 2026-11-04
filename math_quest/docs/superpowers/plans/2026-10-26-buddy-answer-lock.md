# Buddy Challenge Answer Lock Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give each Buddy Challenge player exactly one answer attempt per question and advance without scoring when both attempts are wrong.

**Architecture:** Extend immutable `BuddyChallengeState` with the players who answered the current problem. Keep all acceptance, scoring, and advancement rules in `BuddyChallengeController`; provider-free arena widgets only render the controller-owned lock state.

**Tech Stack:** Flutter, Dart, Riverpod 2.6, flutter_test.

**Spec:** `docs/superpowers/specs/2026-10-26-buddy-answer-lock-design.md`

## Global Constraints

- One attempt per player per problem revision.
- A wrong attempt locks only that player.
- A correct attempt scores and advances immediately.
- Two wrong attempts advance without scoring.
- New problems reset both player locks.
- Stale and repeated submissions do nothing.
- No persistence or database dependencies in presentation state, controllers, or widgets.

## Review Focus

- A player who answered incorrectly must not score by submitting again for the same revision.
- The other player must remain able to answer after the first player's wrong attempt.
- Two wrong answers must not leave the game stuck.
- An accepted correct answer must still score only once.
- Both arenas must unlock when the problem revision changes.

---

### Task 1: Controller-Owned Attempt State

**Files:**
- Modify: `lib/features/gameplay/presentation/models/buddy_challenge_state.dart`
- Modify: `lib/features/gameplay/presentation/controllers/buddy_challenge_controller.dart`
- Test: `test/features/gameplay/presentation/controllers/buddy_challenge_controller_test.dart`

**Interfaces:**
- Consumes: `BuddyChallengeController.submitAnswer({required int playerNumber, required int answer, required int problemRevision})`.
- Produces: immutable `BuddyChallengeState.answeredPlayers` and `BuddyChallengeState.hasAnswered(int playerNumber)` for UI consumption.

- [ ] Write failing controller tests proving the first wrong attempt locks that player, their second submission is ignored, the opponent remains eligible, two wrong attempts advance without scoring, and a new problem has no answered players.
- [ ] Run the controller tests and verify RED because attempt state and one-attempt enforcement are absent.
- [ ] Add immutable answered-player state and update `submitAnswer` to reject repeated/stale submissions, record a first wrong attempt, and advance after both wrong.
- [ ] Run the controller tests and verify GREEN.

### Task 2: Disable Answer Buttons in the Player Arena

**Files:**
- Modify: `lib/features/gameplay/presentation/widgets/buddy_playing_view.dart`
- Modify: `lib/features/gameplay/presentation/widgets/buddy_player_arena.dart`
- Modify: `test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart`
- Modify: `test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart`

**Interfaces:**
- Consumes: Task 1 `BuddyChallengeState.hasAnswered(int playerNumber)`.
- Produces: `BuddyPlayerArena.isAnswerLocked`, which disables every option button for that arena.

- [ ] Write failing widget and screen tests proving all buttons for the player who answered are disabled while all opponent buttons remain enabled.
- [ ] Run the focused widget/screen tests and verify RED because arenas do not accept or render lock state.
- [ ] Pass controller-owned lock state through `BuddyPlayingView` and disable `BuddyPlayerArena` option callbacks when locked.
- [ ] Run focused Buddy tests and focused analysis GREEN.

### Task 3: Verification and Review

**Files:**
- Modify only the files above if verification finds Critical or Important issues.

**Interfaces:**
- Consumes: Tasks 1–2.
- Produces: verified one-attempt Buddy Challenge behavior.

- [ ] Format changed Dart files.
- [ ] Run all Buddy Challenge tests and focused analysis.
- [ ] Run the full Flutter test suite and full analyzer.
- [ ] Request an independent review focused on per-player fairness, stale/repeated submissions, double-wrong advancement, UI disabling, and MVVM boundaries; fix Critical/Important findings RED→GREEN.
