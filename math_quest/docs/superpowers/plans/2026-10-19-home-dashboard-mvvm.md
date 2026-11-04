# Home Dashboard MVVM Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor the home dashboard into a thin Riverpod view backed by immutable state and a testable controller, with each visual section in its own widget file.

**Architecture:** A computed `homeDashboardProvider` maps existing feature state into `HomeDashboardState`. A separately testable `HomeDashboardController` delegates commands through injected functions, while the screen owns navigation and snackbars.

**Tech Stack:** Flutter, Dart 3.13, flutter_riverpod 2.5, flutter_test

**Spec:** `docs/superpowers/specs/2026-10-19-home-dashboard-mvvm-design.md`

## Global Constraints

- Preserve the current dashboard appearance, copy, routes, fallback values, and interactions.
- Keep Hive, Hive models, and repository implementations out of dashboard presentation files.
- Keep Riverpod reads out of extracted dashboard widgets.
- Add no dependencies and make no persistence-format changes.
- This checkout has no `.git` directory, so task checkpoints cannot create commits.

## Review Focus

- A missing active profile must show 1,420 coins, a five-day streak, and level four.
- Progress below the mission target must map to `inProgress`; progress at or above the target must map to `readyToClaim` when unclaimed, with the fraction clamped to 1.0 and the percentage to 100.
- A claimed mission must remain `claimed` even when its progress meets the target.
- Claim and launch taps must run each command once and navigate only from the screen callback.
- The four game-mode cards and lower tip card must remain reachable on a phone-sized scroll view without overflow.

---

### Task 1: Immutable Dashboard State and Provider

**Files:**
- Create: `lib/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart`
- Create: `test/features/profile_and_stats/presentation/providers/home_dashboard_provider_test.dart`

**Interfaces:**
- Consumes: `UserProfile?`, `DailyMissionState`, `ChallengeEngineState`, `profileNotifierProvider`, `dailyMissionProvider`, and `challengeEngineProvider`.
- Produces: `DailyMissionStatus`, `DailyMissionViewData`, `SuperpowerTipViewData`, `HomeDashboardState`, and `Provider<HomeDashboardState> homeDashboardProvider`.

- [ ] **Step 1: Write failing state-mapping tests**

Add tests that construct source values without Hive and assert literal results for:

- A real profile with 875 coins, a 12-day streak, and level seven.
- A null profile producing 1,420 coins, five days, and level four.
- Mission progress at 3/10, 10/10 unclaimed, 10/10 claimed, and 14/10 clamped to 1.0 and 100 percent.
- A challenge mapping its icon, title, and description unchanged.

- [ ] **Step 2: Run the provider test and verify RED**

Run: `flutter test test/features/profile_and_stats/presentation/providers/home_dashboard_provider_test.dart`

Expected: FAIL because `home_dashboard_provider.dart` and its state types do not exist.

- [ ] **Step 3: Implement the immutable types and mapper**

Create:

- `enum DailyMissionStatus { inProgress, readyToClaim, claimed }`
- `const DailyMissionViewData(...)` with mission title, coin reward, badge reward title, current progress, target count, progress fraction, progress percent, and status.
- `const SuperpowerTipViewData(...)` with icon, title, and description.
- `const HomeDashboardState(...)` with star coins, streak days, level, `stars = 340`, mission, and tip.
- `factory HomeDashboardState.fromSources({required UserProfile? profile, required DailyMissionState missionState, required ChallengeEngineState challengeState})`.
- `final homeDashboardProvider = Provider<HomeDashboardState>((ref) { ... })` that only watches and maps the three source providers.

- [ ] **Step 4: Run the provider test and verify GREEN**

Run: `flutter test test/features/profile_and_stats/presentation/providers/home_dashboard_provider_test.dart`

Expected: PASS with no warnings.

- [ ] **Step 5: Run formatting and analysis for the task**

Run: `dart format lib/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart test/features/profile_and_stats/presentation/providers/home_dashboard_provider_test.dart`

Run: `flutter analyze lib/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart test/features/profile_and_stats/presentation/providers/home_dashboard_provider_test.dart`

Expected: Both commands succeed.

### Task 2: Testable Dashboard Controller

**Files:**
- Modify: `lib/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart`
- Modify: `test/features/profile_and_stats/presentation/providers/home_dashboard_provider_test.dart`

**Interfaces:**
- Consumes: injected `Future<ClaimedMissionReward> Function()` for claims, `void Function()` for mission preparation, `void Function()` for challenge preparation, plus existing feature notifiers in provider wiring.
- Produces: `HomeDashboardController`, `ClaimedMissionReward`, and `Provider<HomeDashboardController> homeDashboardControllerProvider`.

- [ ] **Step 1: Write failing controller tests**

Create a controller with local counters and assert:

- `claimDailyMissionReward()` invokes the claim function once and returns the current mission's coin reward and badge title.
- `prepareDailyMission()` invokes its injected function once.
- `prepareSuperpowerChallenge()` invokes its injected function once.
- A thrown claim error reaches the caller unchanged.

- [ ] **Step 2: Run the controller tests and verify RED**

Run: `flutter test test/features/profile_and_stats/presentation/providers/home_dashboard_provider_test.dart`

Expected: FAIL because the controller API does not exist.

- [ ] **Step 3: Implement the controller and Riverpod wiring**

Add exact methods:

- `HomeDashboardController({required Future<ClaimedMissionReward> Function() claimReward, required void Function() prepareMission, required void Function() prepareChallenge})`
- `Future<ClaimedMissionReward> claimDailyMissionReward()`
- `void prepareDailyMission()`
- `void prepareSuperpowerChallenge()`

Wire `homeDashboardControllerProvider` so the claim closure captures today's reward values, awaits `dailyMissionProvider.notifier.claimReward()`, and returns `ClaimedMissionReward`. Mission preparation reads today's mission then calls `practiceSessionProvider.notifier.resetSession(operation:, difficulty:)`; challenge preparation calls `challengeEngineProvider.notifier.launchChallenge()`.

- [ ] **Step 4: Run the provider test and verify GREEN**

Run: `flutter test test/features/profile_and_stats/presentation/providers/home_dashboard_provider_test.dart`

Expected: PASS.

- [ ] **Step 5: Format and analyze the provider layer**

Run: `dart format lib/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart test/features/profile_and_stats/presentation/providers/home_dashboard_provider_test.dart`

Run: `flutter analyze lib/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart test/features/profile_and_stats/presentation/providers/home_dashboard_provider_test.dart`

Expected: Both commands succeed.

### Task 3: Extract Mission Card

**Files:**
- Create: `lib/features/profile_and_stats/presentation/widgets/daily_mission_card.dart`
- Create: `test/features/profile_and_stats/presentation/widgets/daily_mission_card_test.dart`

**Interfaces:**
- Consumes: `DailyMissionViewData`, `Color primaryColor`, `Future<void> Function() onClaim`, and `VoidCallback onContinue`.
- Produces: `DailyMissionCard`, a provider-free widget preserving the current mission visuals.

- [ ] **Step 1: Write failing widget tests**

Render the widget in a `MaterialApp` and verify:

- `inProgress` shows `Continue Mission` and invokes `onContinue` once.
- `readyToClaim` shows the reward button and awaits `onClaim` once.
- `claimed` shows `Mission Completed for Today!` and neither action button.
- A progress value of 1.0 renders without framework exceptions.

- [ ] **Step 2: Run the widget test and verify RED**

Run: `flutter test test/features/profile_and_stats/presentation/widgets/daily_mission_card_test.dart`

Expected: FAIL because `DailyMissionCard` does not exist.

- [ ] **Step 3: Extract `DailyMissionCard`**

Move the current mission card markup into the new widget. Render solely from `DailyMissionViewData`; call only the supplied callbacks.

- [ ] **Step 4: Run the widget test and verify GREEN**

Run: `flutter test test/features/profile_and_stats/presentation/widgets/daily_mission_card_test.dart`

Expected: PASS with no overflow or framework exceptions.

- [ ] **Step 5: Format and analyze the mission widget**

Run: `dart format lib/features/profile_and_stats/presentation/widgets/daily_mission_card.dart test/features/profile_and_stats/presentation/widgets/daily_mission_card_test.dart`

Run: `flutter analyze lib/features/profile_and_stats/presentation/widgets/daily_mission_card.dart test/features/profile_and_stats/presentation/widgets/daily_mission_card_test.dart`

Expected: Both commands succeed.

### Task 4: Extract Remaining Dashboard Widgets

**Files:**
- Create: `lib/features/profile_and_stats/presentation/widgets/home_dashboard_app_bar.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/explorer_banner.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/game_modes_section.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/superpower_tip_card.dart`
- Create: `test/features/profile_and_stats/presentation/widgets/home_dashboard_widgets_test.dart`

**Interfaces:**
- Consumes: primitive display values, `SuperpowerTipViewData`, colors, and callbacks.
- Produces: `HomeDashboardAppBar`, `ExplorerBanner`, `GameModesSection`, and `SuperpowerTipCard`; none may import Riverpod.

- [ ] **Step 1: Write failing callback and rendering tests**

Verify literal visible content and callback counts for settings, trophy room, all four game modes, and challenge launch. Pump each widget inside the smallest Material ancestor it requires.

- [ ] **Step 2: Run the widget test and verify RED**

Run: `flutter test test/features/profile_and_stats/presentation/widgets/home_dashboard_widgets_test.dart`

Expected: FAIL because the extracted widget classes do not exist.

- [ ] **Step 3: Extract the four widgets**

Move the existing markup without changing text, padding, colors, typography, or card ordering. Keep the mini-stat and mode-card helpers private to the widget that owns them.

- [ ] **Step 4: Run the widget test and verify GREEN**

Run: `flutter test test/features/profile_and_stats/presentation/widgets/home_dashboard_widgets_test.dart`

Expected: PASS.

- [ ] **Step 5: Format and analyze the extracted widgets**

Run: `dart format lib/features/profile_and_stats/presentation/widgets/home_dashboard_app_bar.dart lib/features/profile_and_stats/presentation/widgets/explorer_banner.dart lib/features/profile_and_stats/presentation/widgets/game_modes_section.dart lib/features/profile_and_stats/presentation/widgets/superpower_tip_card.dart test/features/profile_and_stats/presentation/widgets/home_dashboard_widgets_test.dart`

Run: `flutter analyze lib/features/profile_and_stats/presentation/widgets test/features/profile_and_stats/presentation/widgets`

Expected: Both commands succeed.

### Task 5: Compose the Thin Screen

**Files:**
- Modify: `lib/features/profile_and_stats/presentation/screens/home_dashboard_screen.dart`
- Create: `test/features/profile_and_stats/presentation/screens/home_dashboard_screen_test.dart`

**Interfaces:**
- Consumes: `homeDashboardProvider`, `homeDashboardControllerProvider`, `visualThemeProvider`, extracted widgets, and existing `AppRoutes`.
- Produces: a `HomeDashboardScreen` that owns scaffold layout, navigation, and reward snackbar presentation.

- [ ] **Step 1: Write the failing screen test**

Override `homeDashboardProvider` and `homeDashboardControllerProvider` in a `ProviderScope`, then verify:

- The profile counters and mapped tip appear.
- Scrolling to the bottom produces no overflow exception.
- Claiming invokes the controller and shows the existing reward snackbar text.
- Continue mission and challenge launch prepare their sessions before the route callback records `AppRoutes.activeGame`.

- [ ] **Step 2: Run the screen test and verify RED**

Run: `flutter test test/features/profile_and_stats/presentation/screens/home_dashboard_screen_test.dart`

Expected: FAIL because the existing screen still reads feature providers directly and cannot use the overrides as its only state and command sources.

- [ ] **Step 3: Replace inline sections with the extracted widgets**

Make the screen watch only `visualThemeProvider` and `homeDashboardProvider`. Read the controller inside event callbacks, preserve every existing route and `ActiveGameArgs`, and keep the success snackbar in the screen.

- [ ] **Step 4: Run the screen test and verify GREEN**

Run: `flutter test test/features/profile_and_stats/presentation/screens/home_dashboard_screen_test.dart`

Expected: PASS with no Flutter exceptions.

- [ ] **Step 5: Run focused feature tests**

Run: `flutter test test/features/profile_and_stats`

Expected: PASS.

### Task 6: Final Verification

**Files:**
- Verify all files changed in Tasks 1 through 5.

**Interfaces:**
- Consumes: the complete refactor.
- Produces: formatted, analyzed, regression-tested code with no database leaks in dashboard presentation files.

- [ ] **Step 1: Format all changed Dart files**

Run: `dart format lib/features/profile_and_stats/presentation test/features/profile_and_stats`

Expected: Formatter exits successfully.

- [ ] **Step 2: Verify the database boundary**

Run: `rg -n "hive|Hive|ProfileRepositoryImpl|UserProfileModel" lib/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart lib/features/profile_and_stats/presentation/screens/home_dashboard_screen.dart lib/features/profile_and_stats/presentation/widgets/{home_dashboard_app_bar,explorer_banner,daily_mission_card,game_modes_section,superpower_tip_card}.dart`

Expected: No matches.

- [ ] **Step 3: Analyze the project**

Run: `flutter analyze`

Expected: Exit code 0. Report any pre-existing diagnostic by file and line if the project is not clean.

- [ ] **Step 4: Run the full test suite**

Run: `flutter test`

Expected: All tests pass. Report any unrelated pre-existing failure by test name.

- [ ] **Step 5: Review final file sizes and imports**

Confirm the screen has no business calculations or direct feature-provider watches, each extracted widget has one visual responsibility, and no unused imports remain.
