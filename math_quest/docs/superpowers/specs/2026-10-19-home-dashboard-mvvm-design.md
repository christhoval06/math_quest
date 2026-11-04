# Home Dashboard MVVM Refactor Design

## Goal

Refactor `HomeDashboardScreen` into the same thin-screen pattern used by `TrophyRoomScreen`. Preserve the dashboard's current appearance, copy, routes, defaults, and interactions while moving state composition and commands out of the widget tree.

## Scope

The refactor covers the home dashboard and its tests. It does not redesign the screen, change mission rules, change challenge generation, replace Riverpod, or alter persistence formats.

## Architecture

The dashboard will use two Riverpod providers with separate responsibilities:

- `homeDashboardProvider` watches the profile, daily mission, and challenge providers. It maps their values into an immutable `HomeDashboardState` that contains only the data the dashboard renders.
- `homeDashboardControllerProvider` exposes dashboard commands. `HomeDashboardController` delegates reward claims, mission-session preparation, and challenge-session preparation to the feature providers that own those behaviors.

`HomeDashboardScreen` will watch `visualThemeProvider` and `homeDashboardProvider`. It will read `homeDashboardControllerProvider` only inside event callbacks. The screen will retain navigation and `ScaffoldMessenger` calls because they require `BuildContext` and belong to the view layer.

Neither dashboard provider will import Hive, a Hive model, or a repository implementation. Existing feature providers remain responsible for their own persistence.

## State Model

`HomeDashboardState` will expose:

- Profile summary: star coins, streak days, hero level, and the existing displayed star count.
- `DailyMissionViewData`: title, reward values, progress values, progress fraction, and a `DailyMissionStatus` value with `inProgress`, `readyToClaim`, and `claimed` cases.
- `SuperpowerTipViewData`: icon, title, and description.

The mapper will preserve the current fallback values when no active profile exists: 1,420 coins, a five-day streak, and level four. The displayed star count remains 340 because the current screen has no source for it.

The view state will not expose `Ref`, notifiers, Hive boxes, data-layer models, `BuildContext`, or navigation routes.

## Commands

`HomeDashboardController` will provide these operations:

- `claimDailyMissionReward()` delegates to `DailyMissionNotifier.claimReward()` and returns the message data required by the success snackbar.
- `prepareDailyMission()` reads today's mission and resets the practice session with its operation and difficulty.
- `prepareSuperpowerChallenge()` delegates to `ChallengeEngineNotifier.launchChallenge()`.

The UI will navigate only after the preparation command completes. Errors will continue to propagate to Flutter's normal error handling; this refactor will not introduce new user-facing error behavior.

## View Composition

`home_dashboard_screen.dart` will contain the scaffold, responsive page layout, navigation callbacks, and snackbar presentation. Focused widgets will live in separate files under `presentation/widgets`:

- `home_dashboard_app_bar.dart` renders the title, counters, and settings action.
- `explorer_banner.dart` renders the greeting and summary statistics.
- `daily_mission_card.dart` renders all three mission states and exposes claim/continue callbacks.
- `game_modes_section.dart` renders the four navigation cards.
- `superpower_tip_card.dart` renders today's tip and exposes its launch callback.

These widgets will receive immutable values and callbacks through constructors. They will not read Riverpod providers.

## Data Flow

1. Existing feature providers load profile, mission, and challenge data.
2. `homeDashboardProvider` maps those provider states into `HomeDashboardState`.
3. `HomeDashboardScreen` passes view-state values and callbacks to focused widgets.
4. A user action calls `HomeDashboardController`.
5. The owning feature notifier updates its state and persistence.
6. Riverpod recomputes `homeDashboardProvider`, and the screen rebuilds with the new immutable state.

## SOLID Boundaries

- Each state, controller, screen, and section widget has one reason to change.
- The screen depends on the dashboard provider contract instead of storage implementations.
- Constructor inputs let tests replace callbacks and provider overrides without opening a database.
- Existing feature notifiers remain the owners of mission, challenge, and practice-session behavior.
- The refactor adds no general-purpose abstractions that the current dashboard does not need.

## Testing

Provider tests will use a `ProviderContainer` with overrides and verify:

- Profile values map to the dashboard state.
- Missing profiles use the current fallback values.
- Mission progress maps to the correct fraction, percentage, and status.
- Challenge content maps to the tip view data.
- Each controller command delegates to the correct feature behavior.

Widget tests will render focused widgets with plain constructor inputs and verify:

- Each mission status shows the correct action or completion treatment.
- Taps invoke the supplied callbacks.
- Long dashboard content remains scrollable without overflow at a representative phone size.

The project test suite and `flutter analyze` must pass after the refactor. Any unrelated pre-existing failure will be reported by name.

## Acceptance Criteria

- `HomeDashboardScreen` contains no business calculations and does not watch profile, mission, practice-session, or challenge providers directly.
- Dashboard widgets contain no provider reads and no database imports.
- Dashboard provider files contain no database imports or repository implementations.
- Logic and UI live in separate files.
- Current visuals, text, routes, defaults, and interactions remain unchanged.
- Automated tests cover state mapping, commands, mission variants, and widget callbacks.
