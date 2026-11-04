# Buddy Challenge Answer Lock Design

## Intent

Prevent a Buddy Challenge player from guessing repeatedly on the same question while preserving the two-player race.

## Behavior

- Each player receives one answer attempt per problem revision.
- After a player answers, every answer button in that player's arena is disabled for the current problem.
- The other player may still answer.
- A correct answer awards one point and advances immediately to the next problem.
- If both players answer incorrectly, the match advances to the next problem without awarding a point.
- A new problem resets both players' answer availability.
- Stale or repeated submissions remain ignored.

## Architecture

The immutable `BuddyChallengeState` records which players have answered the current problem. `BuddyChallengeController.submitAnswer` owns attempt validation, scoring, and problem advancement. `BuddyPlayingView` passes each player's locked state into the provider-free `BuddyPlayerArena`, which disables all four buttons for that player.

No persistence, repository, or database changes are required.

## Approaches Considered

1. **Per-player lock (selected):** preserves a fair chance for the other player and advances after two wrong attempts.
2. **Global first-tap lock:** turns the match into a fastest-tap game and prevents the second player from responding, so it does not match the requested player-specific rule.
3. **UI-only lock:** rejected because controller calls could bypass it and both wrong answers could leave the game stuck.

## Verification

Controller tests will cover one-attempt enforcement, the other player's opportunity, two-wrong-answer advancement, correct scoring, stale submissions, and reset on the next problem. Widget/screen tests will verify that all buttons in only the answering player's arena become disabled and re-enable for a new problem.
