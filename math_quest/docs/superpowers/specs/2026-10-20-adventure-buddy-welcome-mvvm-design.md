# Adventure, Buddy, and Welcome MVVM Refactor

## Goal

Refactor `AdventureIslandScreen`, `BuddyChallengeScreen`, and `WelcomeSplashScreen` to follow the provider-based MVVM structure used by `HomeDashboardScreen`. Preserve each screen's layout, copy, navigation, animations, and game rules while moving state and behavior into testable providers and controllers.

The refactor must keep persistence behind domain interfaces. Screens and extracted widgets must not access Hive, repository implementations, or concrete services.

## Shared Architecture

Each screen consumes one immutable presentation state and one controller provider. Screens own navigation, dialogs, bottom sheets, snackbars, and animation lifecycles. Controllers own validation and feature actions. Extracted widgets receive plain values and callbacks.

Presentation state stores immutable view data instead of mutable models. Provider composition may watch existing feature providers, but screens and widgets must not reach through those providers to mutate state.

The three workstreams share these rules:

- keep business state out of `StatefulWidget` fields and `setState`
- inject actions and generators into controllers
- preserve existing defaults and user-facing copy
- reject invalid actions before state or persistence changes
- keep widgets independent of Riverpod
- serialize or coalesce actions when repeated input can overlap
- keep navigation and transient UI effects in screens

## Adventure Island

### Persistence Boundary

Move adventure Hive access out of `adventure_provider.dart`. Add an adventure progress entity, a domain repository interface, a Hive repository implementation, and a data provider. The repository owns `highest_world_index` and `completed_levels_stars`, validates stored values, and returns safe defaults for malformed data.

Keep the existing `adventureProvider` public contract for `QuestCompleteController` and Settings reset integration. `AdventureNotifier` depends on the repository interface instead of `Box`. A failed write must leave its prior in-memory state visible. Reset must restore both persistence values or report failure without publishing reset state.

Repository operations that change more than one key must snapshot the prior values and restore them when a later write fails. This keeps completed stars and the highest unlocked world consistent without changing the existing storage schema.

### Presentation State

Add `AdventureIslandState` with immutable world and level view data:

- active world index
- current world title, emoji, colors, boss name, and boss emoji
- available worlds for the switcher
- current world's level nodes
- new-world celebration data when pending

Level view data contains the level number, title, status, stars, operation, difficulty, boss flag, and path position. The state factory maps `AdventureState` into snapshots that extracted widgets can render without reading providers.

### Controller

Add `AdventureIslandController` with injected actions for:

- switching worlds
- clearing the new-world notification
- resetting the practice session

`prepareLevel` accepts an adventure level snapshot, rejects locked levels, resets the practice session with the level's operation and difficulty, and returns `PreparedAdventureSession`. The screen maps that result to `ActiveGameArgs` and performs navigation.

World switching rejects an index absent from the current view state. Repeated celebration acknowledgements coalesce into one notification-clear action.

### Screen and Widgets

Convert `AdventureIslandScreen` to a thin `ConsumerWidget`. It watches `adventureIslandProvider`, listens for a pending celebration, and delegates actions to `adventureIslandControllerProvider`. The screen owns the celebration dialog and active-game navigation.

Extract provider-free widgets for the app bar/world switcher, boss banner, winding level map, path connector, and celebration dialog. Preserve the current alignment sequence and visual styling.

## Buddy Challenge

### Presentation State

Add immutable `BuddyChallengeState` containing:

- current problem view data
- player-one and player-two scores
- target score of 5
- optional winner

Problem view data contains the display equation, correct answer, and an immutable four-option list.

The state also carries a monotonically increasing problem revision. Answer callbacks include the rendered revision, so a queued second tap from the previous problem cannot score the replacement problem.

### Controller and Provider

Add `BuddyChallengeController` as the sole owner of match behavior. Inject a problem factory so tests can supply deterministic problems. The controller:

- creates the opening addition/easy problem
- ignores answers after a winner exists or for a stale problem revision
- ignores incorrect answers without changing the problem or scores
- increments the answering player's score once for a correct answer
- declares the winner at five points
- creates one new problem after a correct non-winning answer
- resets both scores, clears the winner, and creates one new problem

Expose the controller through `buddyChallengeControllerProvider` and expose its state as `buddyChallengeProvider`.

### Screen and Widgets

Convert `BuddyChallengeScreen` to a `ConsumerWidget`. It watches the state, delegates answer and reset callbacks, and owns exit navigation.

Extract provider-free widgets for a player arena, center score divider, and victory overlay. Preserve the rotated player-one layout, player colors, star trackers, equation display, answer grid, and victory copy.

## Welcome Splash

### Presentation State

Add `WelcomeSplashState` that combines the active profile and all-profile source into immutable view data. It contains:

- active profile name, grade, avatar, coins, and streak
- profile-list loading, data, or error status
- immutable profile switcher rows
- whether another profile can be added

Keep the current missing-profile defaults: Leo, Grade 2, 👦, 1420 coins, and a five-day streak. A profile-list failure affects the switcher content only; the splash screen remains usable.

### Controller

Add `WelcomeSplashController` with injected actions for tap sound and profile switching. It serializes profile switches, avoids duplicate requests for the active profile, and surfaces failures to the screen. The controller does not navigate or open UI surfaces.

### Screen and Widgets

Keep `WelcomeSplashScreen` as a `ConsumerStatefulWidget` because it owns two `AnimationController` instances. Animation state is a UI concern. Remove profile, sound, and switching logic from the widget state.

The screen watches `welcomeSplashProvider`, reads `welcomeSplashControllerProvider` for callbacks, owns main-shell navigation, and presents the profile switcher bottom sheet. It reports switch failures with a snackbar and closes the sheet only after a successful switch.

Extract provider-free widgets for the top status bar, animated brand card, loading progress, launch button, active-profile pill, and profile-switcher content. Preserve the 1.8-second floating animation and 1.4-second loading animation. Keep loading-status mapping as a pure presentation function with the existing thresholds and copy.

## Data Flow

1. A feature provider supplies domain state or async source data.
2. The screen-specific provider maps those sources into immutable view data.
3. The screen passes values and callbacks into provider-free widgets.
4. A callback asks the screen-specific controller to perform a feature action.
5. The controller validates and delegates through injected interfaces.
6. The source provider publishes the next state, and Riverpod rebuilds the screen.
7. The screen performs navigation or presents feedback when the action completes.

## Failure Handling

Adventure persistence failures preserve the previous in-memory map and reach the caller. Malformed saved progress falls back to world 1 with no completed levels. A locked adventure level cannot prepare or navigate to a game.

Buddy Challenge has no persistence. Invalid player numbers or malformed generated problems throw before state mutation. Incorrect answers remain valid user input and cause no state change.

Welcome profile-loading errors stay inside the switcher. A failed profile switch keeps the prior active profile and sheet open, then the screen shows an error. Sound playback must not block navigation or profile switching.

## Testing

### Adventure

- repository tests for defaults, valid persistence, malformed values, failed writes, and reset consistency
- notifier tests for load, completion, world unlock, switching, notification clearing, and failure preservation
- state/controller tests for mapping, locked-level rejection, session preparation, and returned navigation arguments
- provider-free widget tests for world switching, map rendering, and celebration callbacks
- screen tests for provider rendering, navigation order, celebration flow, and 390 by 844 layout

### Buddy Challenge

- controller tests with deterministic problems for scoring, wrong answers, winning, stale-revision taps, and reset
- widget tests for both orientations, answer callbacks, score display, and victory actions
- screen tests for provider delegation, exit behavior, play-again behavior, and 390 by 844 layout

### Welcome Splash

- state/controller tests for defaults, immutable profile mapping, loading/error states, serialized switching, duplicate active-profile selection, and failures
- pure loading-status threshold tests
- widget tests for display values and callback delivery without a provider container
- screen tests for launch navigation, profile-sheet states, successful and failed switching, create-profile navigation, animation disposal, and 390 by 844 layout

### Regression Checks

Run focused feature tests, the complete Flutter test suite, formatting, changed-path analysis, and full-project analysis. Scan all three screens and their extracted widgets for Hive, repository implementations, concrete persistence, direct service mutation, and business-state `setState`. Scan extracted widgets for Riverpod references.

## Boundaries

This work refactors the three named screens and the adventure persistence boundary required to remove Hive from presentation. It does not redesign the UI, change routes, add multiplayer networking, alter math difficulty, change the five-point Buddy rules, replace Flutter animations, migrate profile storage, or modify gameplay completion rules.

## Success Criteria

- Each screen follows the Home Dashboard provider/controller/composition pattern.
- Buddy Challenge contains no local game state or business logic.
- Welcome keeps only animation lifecycle state in its `State` object.
- Adventure presentation contains no Hive imports or direct storage calls.
- Extracted widgets run without Riverpod, Hive, repositories, or services.
- Adventure level preparation occurs before active-game navigation.
- Repeated Buddy input cannot score one problem more than once.
- Profile switching preserves the prior profile on failure.
- The three screens preserve their current layout and render without overflow at 390 by 844.
- Changed paths pass `flutter analyze`, and the complete Flutter test suite passes.
