# Adventure, Buddy, and Welcome MVVM Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor Adventure Island, Buddy Challenge, and Welcome Splash into provider-driven MVVM screens with provider-free widgets and no presentation-layer database access.

**Architecture:** Keep the existing adventure application provider public, but inject a repository interface instead of Hive. Add one immutable screen state and one injected controller per screen. Screens retain navigation, transient UI, and Welcome animation lifecycles; extracted widgets receive values and callbacks.

**Tech Stack:** Flutter, Dart, flutter_riverpod, Hive, flutter_test

**Spec:** `docs/superpowers/specs/2026-10-20-adventure-buddy-welcome-mvvm-design.md`

## Global Constraints

- Preserve current layouts, copy, routes, animations, defaults, and game rules.
- Keep Hive, repository implementations, and concrete persistence APIs out of presentation files.
- Keep extracted widgets independent of Riverpod and service providers.
- Keep `adventureProvider` compatible with Settings and `QuestCompleteViewModel`.
- Keep Buddy Challenge at five points with addition/easy problems.
- Keep Welcome's 1.8-second float and 1.4-second loading animations.
- Keep navigation, dialogs, bottom sheets, and snackbars in screens.
- Use test-first RED→GREEN cycles for production changes.
- The workspace has no Git metadata. Replace commit steps with checkpoints in `.superpowers/sdd/2026-10-20-adventure-buddy-welcome-mvvm/progress.md`.

## Review Focus

- A second Adventure completion or reset arriving before the first persistence call finishes must not publish stale state; Task 1 adds controlled-completion notifier tests.
- A Buddy double tap from revision N must not answer revision N+1; Task 4 adds a stale-revision test.
- A failed Welcome profile switch after the active ID changes must restore the prior profile; Task 6 adds a rollback test.
- Malformed Hive progress maps, level keys, star values, and world indices must load world 1 safely; Task 1 adds corrupt-store tests.
- Returning to Adventure with an already-pending new-world notification must show one dialog and clear it once; Task 3 adds initial-state and repeated-rebuild screen tests.

---

### Task 1: Adventure persistence boundary and compatible application state

**Files:**
- Create: `lib/features/gameplay/domain/entities/adventure_progress.dart`
- Create: `lib/features/gameplay/domain/repositories/i_adventure_repository.dart`
- Create: `lib/features/gameplay/data/sources/adventure_progress_store.dart`
- Create: `lib/features/gameplay/data/repositories/adventure_repository_impl.dart`
- Create: `lib/features/gameplay/data/providers/adventure_repository_provider.dart`
- Modify: `lib/features/gameplay/presentation/providers/adventure_provider.dart`
- Create: `test/features/gameplay/data/repositories/adventure_repository_impl_test.dart`
- Create: `test/features/gameplay/presentation/providers/adventure_provider_test.dart`
- Create: `.superpowers/sdd/2026-10-20-adventure-buddy-welcome-mvvm/progress.md`

**Interfaces:**
- Produces `AdventureProgress({required int highestWorldIndex, required Map<int, int> completedLevelStars})` with immutable stars.
- Produces `IAdventureRepository.loadProgress()`, `saveProgress(AdventureProgress)`, and `resetProgress()`.
- Produces internal `AdventureProgressStore.read`, `write`, and `delete`, plus `HiveAdventureProgressStore`.
- Preserves `AdventureState`, `AdventureNotifier.completeLevel`, `switchWorld`, `clearNewWorldNotification`, `resetAdventureProgress`, and `adventureProvider`.

- [ ] **Step 1: Write failing repository tests**

Add tests named:

- `empty store returns world one with no stars`
- `valid progress round trips through legacy keys`
- `progress snapshots cannot be mutated`
- `malformed world and star values use safe defaults`
- `failed second write restores both previous keys`
- `failed reset restores both previous keys`

Use a recording in-memory `AdventureProgressStore` with a controllable write failure. Accept positive level numbers, stars from 1 through 3, and a world index of at least 1.

- [ ] **Step 2: Run repository tests and verify RED**

Run: `flutter test test/features/gameplay/data/repositories/adventure_repository_impl_test.dart`

Expected: compilation fails because the entity, contract, store, and implementation do not exist.

- [ ] **Step 3: Implement the adventure repository boundary**

`AdventureRepositoryImpl` reads the existing `highest_world_index` and `completed_levels_stars` keys. `saveProgress` snapshots both raw values, writes both new values, and attempts to restore both snapshots if either write fails. `resetProgress` saves `AdventureProgress.empty()` through the same path.

- [ ] **Step 4: Run repository tests and verify GREEN**

Run the Step 2 command. Expected: all repository tests pass.

- [ ] **Step 5: Write failing AdventureNotifier tests**

Cover:

- repository progress reconstructs worlds and active levels
- completing a normal level persists before publishing the next active level
- completing a boss persists the next world before publishing it
- persistence failure preserves prior state
- overlapping completions execute in request order
- reset failure preserves prior state
- world switching rejects unavailable indices
- notification clearing is idempotent

Inject a fake `IAdventureRepository` and `GenerateAdventureWorldUseCase`.

- [ ] **Step 6: Run notifier tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/providers/adventure_provider_test.dart`

Expected: tests fail because `AdventureNotifier` still depends on Hive and lacks serialized mutations and validation.

- [ ] **Step 7: Refactor `AdventureNotifier` and wire its data provider**

Construct `AdventureNotifier(GenerateAdventureWorldUseCase generator, IAdventureRepository repository)`. Load through `repository.loadProgress()`. Serialize completion and reset mutations, compute next state without publishing it, persist, then publish. Keep its public methods compatible with current consumers.

- [ ] **Step 8: Run Task 1 tests and checkpoint**

Run: `flutter test test/features/gameplay/data/repositories/adventure_repository_impl_test.dart test/features/gameplay/presentation/providers/adventure_provider_test.dart test/features/settings_and_parent_gate`

Expected: Task 1 and Settings integration tests pass. Record counts and rulings in the ledger.

---

### Task 2: Adventure Island state and controller

**Files:**
- Create: `lib/features/gameplay/presentation/models/adventure_island_state.dart`
- Create: `lib/features/gameplay/presentation/controllers/adventure_island_controller.dart`
- Create: `lib/features/gameplay/presentation/providers/adventure_island_provider.dart`
- Create: `test/features/gameplay/presentation/providers/adventure_island_provider_test.dart`
- Create: `test/features/gameplay/presentation/controllers/adventure_island_controller_test.dart`

**Interfaces:**
- Produces `AdventureWorldOptionViewData`, `AdventureLevelViewData`, `AdventureCelebrationViewData`, and `AdventureIslandState.fromAdventure(AdventureState)`.
- Produces `PreparedAdventureSession` with level number, title, operation, and difficulty.
- Produces `AdventureIslandController.switchWorld(int)`, `prepareLevel(AdventureLevelViewData)`, and `acknowledgeCelebration()`.
- Produces `adventureIslandProvider` and `adventureIslandControllerProvider`.

- [ ] **Step 1: Write failing immutable state tests**

Assert world metadata, colors, switcher rows, immutable levels, the center/right/center/left position cycle, and optional celebration mapping. Mutating source lists must not change mapped state.

- [ ] **Step 2: Run state tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/providers/adventure_island_provider_test.dart`

Expected: compilation fails because the state and provider do not exist.

- [ ] **Step 3: Implement state mapping and provider composition**

Map `adventureProvider` into view snapshots. Do not expose `AdventureWorld` or `AdventureLevel` through the screen state.

- [ ] **Step 4: Write failing controller tests**

Cover valid switching, unavailable-world rejection before delegation, locked-level rejection, practice-session reset before returning a prepared session, and coalesced celebration acknowledgement.

- [ ] **Step 5: Run controller tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/controllers/adventure_island_controller_test.dart`

Expected: compilation fails because the controller does not exist.

- [ ] **Step 6: Implement and wire the injected controller**

Inject a current-state reader, world-switch action, notification-clear action, and practice-session reset action. The production provider connects only to presentation providers and the math session abstraction.

- [ ] **Step 7: Run Task 2 tests and checkpoint**

Run both Task 2 test files. Expected: all tests pass. Record evidence in the ledger.

---

### Task 3: Adventure Island widgets and thin screen

**Files:**
- Create: `lib/features/gameplay/presentation/widgets/adventure_island_app_bar.dart`
- Create: `lib/features/gameplay/presentation/widgets/adventure_boss_banner.dart`
- Create: `lib/features/gameplay/presentation/widgets/adventure_level_map.dart`
- Create: `lib/features/gameplay/presentation/widgets/adventure_path_connector.dart`
- Create: `lib/features/gameplay/presentation/widgets/new_world_celebration_dialog.dart`
- Replace: `lib/features/gameplay/presentation/screens/adventure_island_screen.dart`
- Create: `test/features/gameplay/presentation/widgets/adventure_island_widgets_test.dart`
- Expand: `test/features/gameplay/presentation/screens/adventure_island_screen_test.dart`

**Interfaces:**
- Consumes Task 2 view data and controller.
- Produces `buildAdventureGameArgs(PreparedAdventureSession)` and preserves `AppRoutes.activeGame` navigation.
- Produces five provider-free widgets and a thin `AdventureIslandScreen`.

- [ ] **Step 1: Write failing provider-free widget tests**

Cover app-bar world selection, boss copy, level alignment and callbacks, connector dots, and celebration acknowledgement. Render widgets without `ProviderScope`.

- [ ] **Step 2: Run widget tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/widgets/adventure_island_widgets_test.dart`

Expected: compilation fails because the widgets do not exist.

- [ ] **Step 3: Extract Adventure widgets**

Preserve current sizes, spacing, colors, popup labels, map alignments, and dialog copy. Widgets accept constructor values and callbacks only.

- [ ] **Step 4: Write failing screen tests**

Cover provider rendering, session preparation before navigation, locked-level no-navigation behavior, world-switch delegation, a pending celebration shown once on initial render, repeated rebuilds not reopening it, acknowledgement, and 390×844 overflow.

- [ ] **Step 5: Run screen tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/screens/adventure_island_screen_test.dart`

Expected: tests fail because the current screen owns provider mutation and inline UI.

- [ ] **Step 6: Replace Adventure Island with composition and UI effects**

Use `ref.listen(..., fireImmediately: true)` for celebration transitions. Build `ActiveGameArgs` from `PreparedAdventureSession` in the screen, then navigate. Keep no business state in the widget.

- [ ] **Step 7: Run Adventure feature tests and checkpoint**

Run: `flutter test test/features/gameplay/presentation/providers/adventure_provider_test.dart test/features/gameplay/presentation/providers/adventure_island_provider_test.dart test/features/gameplay/presentation/controllers/adventure_island_controller_test.dart test/features/gameplay/presentation/widgets/adventure_island_widgets_test.dart test/features/gameplay/presentation/screens/adventure_island_screen_test.dart`

Expected: all Adventure tests pass. Record the screen line count and boundary scan.

---

### Task 4: Buddy Challenge state, controller, and provider

**Files:**
- Create: `lib/features/gameplay/presentation/models/buddy_challenge_state.dart`
- Create: `lib/features/gameplay/presentation/controllers/buddy_challenge_controller.dart`
- Create: `lib/features/gameplay/presentation/providers/buddy_challenge_provider.dart`
- Create: `test/features/gameplay/presentation/controllers/buddy_challenge_controller_test.dart`

**Interfaces:**
- Produces `BuddyProblemViewData` with equation, correct answer, immutable options, and revision.
- Produces `BuddyChallengeState` with both scores, target score 5, and optional winner.
- Produces `BuddyChallengeController.submitAnswer({required int playerNumber, required int answer, required int problemRevision})` and `resetGame()`.
- Produces `buddyChallengeProvider` and `buddyChallengeControllerProvider`.

- [ ] **Step 1: Write failing controller tests**

Use a queued deterministic problem factory. Cover opening state, invalid player rejection, malformed problem rejection, wrong-answer no-op, correct scoring, one generated replacement problem, winner at five, no actions after victory, stale-revision double taps, reset, and immutable options.

- [ ] **Step 2: Run controller tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/controllers/buddy_challenge_controller_test.dart`

Expected: compilation fails because the state, controller, and provider do not exist.

- [ ] **Step 3: Implement Buddy state and controller**

Generate addition/easy problems in production. Increment the revision for each new problem. Validate four distinct options containing the correct answer before publishing a generated problem.

- [ ] **Step 4: Wire Buddy providers**

Expose the controller as a `StateNotifierProvider` state source and a controller-only provider for screen callbacks. Keep `GenerateProblemUseCase` construction in the provider layer.

- [ ] **Step 5: Run Task 4 tests and checkpoint**

Run the Step 2 command. Expected: all controller tests pass. Record evidence.

---

### Task 5: Buddy Challenge widgets and thin screen

**Files:**
- Create: `lib/features/gameplay/presentation/widgets/buddy_player_arena.dart`
- Create: `lib/features/gameplay/presentation/widgets/buddy_score_divider.dart`
- Create: `lib/features/gameplay/presentation/widgets/buddy_victory_overlay.dart`
- Replace: `lib/features/gameplay/presentation/screens/buddy_challenge_screen.dart`
- Create: `test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart`
- Create: `test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart`

**Interfaces:**
- Consumes Task 4 state and controller.
- Produces three provider-free widgets and `BuddyChallengeScreen extends ConsumerWidget`.

- [ ] **Step 1: Write failing widget tests**

Cover player labels, five-star progress, equation/options, answer callback with revision, score divider close callback, winner colors/copy, exit, and play-again callbacks.

- [ ] **Step 2: Run widget tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/widgets/buddy_challenge_widgets_test.dart`

Expected: compilation fails because the widgets do not exist.

- [ ] **Step 3: Extract Buddy widgets**

Preserve player-one rotation, colors, grid geometry, score bar, overlay opacity, and victory copy.

- [ ] **Step 4: Write failing screen tests**

Override state/controller providers. Verify both arenas render, answers delegate with the rendered revision, close and victory exit pop, play again delegates, and 390×844 renders without overflow.

- [ ] **Step 5: Run screen tests and verify RED**

Run: `flutter test test/features/gameplay/presentation/screens/buddy_challenge_screen_test.dart`

Expected: tests fail because the current screen owns local match state.

- [ ] **Step 6: Replace Buddy screen with provider composition**

Watch `buddyChallengeProvider`, read `buddyChallengeControllerProvider` for callbacks, and keep Navigator calls in the screen.

- [ ] **Step 7: Run Buddy tests and checkpoint**

Run both Task 4 and Task 5 test files. Expected: all Buddy tests pass. Record the screen line count and boundary scan.

---

### Task 6: Welcome Splash state and controller

**Files:**
- Create: `lib/features/profile_and_stats/presentation/models/welcome_splash_state.dart`
- Create: `lib/features/profile_and_stats/presentation/controllers/welcome_splash_controller.dart`
- Create: `lib/features/profile_and_stats/presentation/providers/welcome_splash_provider.dart`
- Create: `test/features/profile_and_stats/presentation/providers/welcome_splash_provider_test.dart`
- Create: `test/features/profile_and_stats/presentation/controllers/welcome_splash_controller_test.dart`

**Interfaces:**
- Produces `WelcomeProfilesStatus`, `WelcomeProfileViewData`, and `WelcomeSplashState.fromSources(...)`.
- Produces `WelcomeSplashController.playTap()` and `switchProfile(String)`.
- Produces `welcomeSplashProvider` and `welcomeSplashControllerProvider`.

- [ ] **Step 1: Write failing state/provider tests**

Cover active-profile mapping, Leo/Grade 2/👦/1420/5 defaults, immutable profile rows, loading, error-locality, three-profile add limit, profile refresh, and active profile changes.

- [ ] **Step 2: Run provider tests and verify RED**

Run: `flutter test test/features/profile_and_stats/presentation/providers/welcome_splash_provider_test.dart`

Expected: compilation fails because the state and provider do not exist.

- [ ] **Step 3: Implement Welcome state and provider composition**

Combine `profileNotifierProvider` and `allProfilesProvider`. Do not expose `UserProfile` to the screen or widgets.

- [ ] **Step 4: Write failing controller tests**

Cover non-blocking tap sound, duplicate active-profile no-op, serialized rapid switches, switch failure rollback, rollback failure preserving the original error, and later queue recovery after failure.

- [ ] **Step 5: Run controller tests and verify RED**

Run: `flutter test test/features/profile_and_stats/presentation/controllers/welcome_splash_controller_test.dart`

Expected: compilation fails because the controller does not exist.

- [ ] **Step 6: Implement and wire Welcome controller**

Inject active-profile reads, sound playback, and switch actions. Catch sound failures inside `playTap`. Serialize switches and attempt the prior profile on failure.

- [ ] **Step 7: Run Task 6 tests and checkpoint**

Run both Task 6 test files. Expected: all tests pass. Record evidence.

---

### Task 7: Welcome Splash widgets and thin animated screen

**Files:**
- Create: `lib/features/profile_and_stats/presentation/widgets/welcome_status_bar.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/welcome_brand_card.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/welcome_loading_progress.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/welcome_launch_button.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/welcome_profile_pill.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/welcome_profile_switcher.dart`
- Replace: `lib/features/profile_and_stats/presentation/screens/welcome_splash_screen.dart`
- Create: `test/features/profile_and_stats/presentation/widgets/welcome_splash_widgets_test.dart`
- Create: `test/features/profile_and_stats/presentation/screens/welcome_splash_screen_test.dart`

**Interfaces:**
- Consumes Task 6 state/controller.
- Produces `welcomeLoadingStatus(double progress)`, six provider-free widgets, and an animation-only `ConsumerStatefulWidget` screen.

- [ ] **Step 1: Write failing loading-status and widget tests**

Assert the exact status boundaries at 0.0, 0.45, 0.90, and 1.0. Cover counters, brand fallback, progress percentage, launch callback, profile pill, switcher loading/error/empty/data/full states, active-row selection, and add-profile callback without `ProviderScope`.

- [ ] **Step 2: Run widget tests and verify RED**

Run: `flutter test test/features/profile_and_stats/presentation/widgets/welcome_splash_widgets_test.dart`

Expected: compilation fails because the widgets and pure status function do not exist.

- [ ] **Step 3: Extract Welcome widgets**

Preserve copy, image fallback, colors, sizing, profile limit, and current bottom-sheet layout. Pass animation values from the screen into provider-free widgets.

- [ ] **Step 4: Write failing screen tests**

Cover state rendering, tap sound plus main-shell route replacement, sheet loading/error/data states, successful switch closing the sheet, failed switch keeping it open with feedback, active-profile duplicate behavior, create-profile navigation with `false`, animation progress, disposal, and 390×844 layout.

- [ ] **Step 5: Run screen tests and verify RED**

Run: `flutter test test/features/profile_and_stats/presentation/screens/welcome_splash_screen_test.dart`

Expected: tests fail because the current screen reads feature providers and sound services inside inline UI.

- [ ] **Step 6: Replace Welcome screen with animation lifecycle and composition**

Keep only `_floatController`, `_floatAnimation`, `_loadingController`, and `_loadingAnimation` as fields. The screen owns bottom-sheet updates through a `Consumer` builder, navigation, and failure snackbars.

- [ ] **Step 7: Run Welcome tests and checkpoint**

Run Task 6 and Task 7 tests. Expected: all Welcome tests pass. Record the screen line count and boundary scan.

---

### Task 8: Cross-feature verification and review

**Files:**
- Modify: `.superpowers/sdd/2026-10-20-adventure-buddy-welcome-mvvm/progress.md`
- Verify: all files changed in Tasks 1 through 7

**Interfaces:**
- Consumes the completed Adventure, Buddy, and Welcome workstreams.
- Produces formatted, analyzed, regression-tested code with review evidence.

- [ ] **Step 1: Format changed Dart files**

Run `dart format` on every changed Dart file. Expected: exit 0.

- [ ] **Step 2: Verify architecture boundaries**

Scan the three screens and extracted widgets for `Hive`, `RepositoryImpl`, concrete data providers, direct feature-notifier mutation, sound service providers, and business-state `setState`. Scan extracted widgets for `flutter_riverpod`, `ConsumerWidget`, and `WidgetRef`. Expected: zero matches, except Welcome's screen class may contain animation lifecycle calls and its screen-owned `Consumer` bottom-sheet builder.

- [ ] **Step 3: Analyze changed paths**

Run `flutter analyze` with all changed library and test paths. Expected: no issues.

- [ ] **Step 4: Run the complete test suite**

Run: `flutter test`

Expected: all tests pass.

- [ ] **Step 5: Run full-project analysis**

Run: `flutter analyze`

Expected: no new diagnostics compared with the current 29-item out-of-scope baseline.

- [ ] **Step 6: Request one whole-change code review**

Ask a fresh reviewer to inspect persistence rollback, overlapping mutations, stale Buddy revisions, profile-switch rollback, initial celebration delivery, provider boundaries, and test quality. Fix Critical and Important in-scope findings with one RED→GREEN pass. Record every finding and ruling.

- [ ] **Step 7: Record final evidence**

Append formatter, boundary scans, focused analysis, test count, full analysis, review findings, deferred costs, and the no-Git integration ruling to the ledger.
