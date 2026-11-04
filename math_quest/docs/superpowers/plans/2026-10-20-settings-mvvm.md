# Settings MVVM Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor Settings into a provider-driven MVVM screen with isolated widgets, typed preference persistence, and functional runtime settings.

**Architecture:** A Hive-backed domain repository supplies immutable `SettingsPreferences`. `settingsProvider` combines those preferences with profile, theme, and locale sources, while an injected `SettingsController` owns validation, persistence, service synchronization, profile actions, parent-gate challenges, and adventure reset. The screen composes provider-free widgets and retains navigation, dialogs, and snackbars.

**Tech Stack:** Flutter, Dart, flutter_riverpod, Hive, flutter_test

**Spec:** `docs/superpowers/specs/2026-10-20-settings-mvvm-design.md`

## Global Constraints

- Preserve the current Settings layout, copy, defaults, parent-gate sequence, and responsive behavior.
- Keep navigation, dialogs, and snackbars in `SettingsScreen`.
- Keep Hive, data models, repository implementations, and concrete persistence APIs out of the screen and Settings widget files.
- Keep extracted widgets independent of Riverpod.
- Persist SFX, music, voice, haptic, screen-limit, and per-profile target-standard values.
- Keep `gradeLabel` unchanged; store target standards under profile-specific settings keys.
- Keep theme and locale persistence in their existing notifiers.
- Do not add text-to-speech, background-music playback, gameplay haptics, cloud sync, or a profile Hive-adapter migration.
- The workspace has no Git metadata. Replace commit steps with ledger checkpoints in `.superpowers/sdd/2026-10-20-settings-mvvm/progress.md`.

## Review Focus

- A failed preference write must preserve the old presentation state and avoid applying the new runtime audio value; Task 2 adds rollback tests for SFX and music.
- Rapid profile changes must show each profile's own target standard or its `gradeLabel` fallback; Task 2 adds a provider-container test with two profiles.
- Invalid values must throw before persistence, state, or service mutation; Task 2 tests every validation boundary.
- A cancelled or incorrect parent gate must perform no protected action; Task 4 adds screen tests for both paths.
- A profile-loading failure must leave audio, theme, language, and parent settings usable; Tasks 2 and 4 add state and screen tests.

---

### Task 1: Typed settings persistence and parent-gate domain logic

**Files:**
- Create: `lib/features/settings_and_parent_gate/domain/entities/settings_preferences.dart`
- Create: `lib/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart`
- Create: `lib/features/settings_and_parent_gate/domain/repositories/i_settings_repository.dart`
- Create: `lib/features/settings_and_parent_gate/data/repositories/settings_repository_impl.dart`
- Create: `lib/features/settings_and_parent_gate/data/providers/settings_repository_provider.dart`
- Create: `test/features/settings_and_parent_gate/data/repositories/settings_repository_impl_test.dart`
- Create: `test/features/settings_and_parent_gate/domain/entities/parent_gate_challenge_test.dart`
- Create: `.superpowers/sdd/2026-10-20-settings-mvvm/progress.md`

**Interfaces:**
- Consumes: an open Hive `Box<dynamic>` named `app_settings_box`.
- Produces: `SettingsPreferences`, `ParentGateChallenge`, `ParentGateChallengeGenerator`, `ISettingsRepository`, `SettingsRepositoryImpl`, and `settingsRepositoryProvider`.

- [ ] **Step 1: Write failing immutable-preference and repository tests**

Add tests with these names and assertions:

- `defaults match the current settings screen`: 0.8 SFX, 0.6 music, voice enabled, haptics enabled, 30 minutes, and an empty target-standard map.
- `target standards are immutable snapshots`: mutating a source map or the exposed map cannot change the entity.
- `repository returns defaults from an empty box`.
- `repository persists and reloads every preference`.
- `repository stores target standards per profile`: saving Leo and Mia produces two independent values.
- `repository target-standard lookup uses grade fallback`: an unknown profile returns the supplied `gradeLabel`.

- [ ] **Step 2: Run persistence tests and verify RED**

Run: `flutter test test/features/settings_and_parent_gate/data/repositories/settings_repository_impl_test.dart`

Expected: compilation fails because the settings entity and repository do not exist.

- [ ] **Step 3: Implement the preference entity and repository contract**

Create:

```dart
class SettingsPreferences {
  final double sfxVolume;
  final double musicVolume;
  final bool voiceReadAloud;
  final bool hapticBuzz;
  final int screenLimitMinutes;
  final Map<String, String> targetMathStandards;

  SettingsPreferences({
    this.sfxVolume = 0.8,
    this.musicVolume = 0.6,
    this.voiceReadAloud = true,
    this.hapticBuzz = true,
    this.screenLimitMinutes = 30,
    Map<String, String> targetMathStandards = const {},
  });

  SettingsPreferences copyWith({
    double? sfxVolume,
    double? musicVolume,
    bool? voiceReadAloud,
    bool? hapticBuzz,
    int? screenLimitMinutes,
    Map<String, String>? targetMathStandards,
  });
  String targetMathStandardFor(String profileId, String gradeFallback);
}
```

Create `ISettingsRepository` with synchronous `loadPreferences()` and asynchronous typed save methods for each field and `saveTargetMathStandard(profileId, standard)`. `SettingsRepositoryImpl` owns the Hive keys and stores target standards as `target_math_standard_<profileId>`.

- [ ] **Step 4: Run persistence tests and verify GREEN**

Run the Step 2 command.

Expected: all repository tests pass.

- [ ] **Step 5: Write failing parent-gate tests**

Add tests proving:

- injected values generate factors from 6 through 10
- the prompt uses number words and a multiplication sign
- trimmed numeric input validates the product
- empty, non-numeric, and incorrect input fail validation

- [ ] **Step 6: Run parent-gate tests and verify RED**

Run: `flutter test test/features/settings_and_parent_gate/domain/entities/parent_gate_challenge_test.dart`

Expected: compilation fails because the challenge types do not exist.

- [ ] **Step 7: Implement parent-gate value and generator**

Create:

```dart
class ParentGateChallenge {
  final int firstFactor;
  final int secondFactor;
  String get prompt;
  bool accepts(String input);
}

class ParentGateChallengeGenerator {
  ParentGateChallengeGenerator({required int Function(int max) nextInt});
  ParentGateChallenge generate();
}
```

Map `nextInt(5)` to factors 6 through 10.

- [ ] **Step 8: Run Task 1 tests and checkpoint**

Run: `flutter test test/features/settings_and_parent_gate/data/repositories/settings_repository_impl_test.dart test/features/settings_and_parent_gate/domain/entities/parent_gate_challenge_test.dart`

Expected: all Task 1 tests pass. Record counts and rulings in the ledger.

---

### Task 2: Settings state, controller, provider wiring, and live screen-time sync

**Files:**
- Create: `lib/features/settings_and_parent_gate/presentation/models/settings_state.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/controllers/settings_controller.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/providers/settings_provider.dart`
- Modify: `lib/core/services/screen_time_provider.dart`
- Create: `test/features/settings_and_parent_gate/presentation/controllers/settings_controller_test.dart`
- Create: `test/features/settings_and_parent_gate/presentation/providers/settings_provider_test.dart`
- Create: `test/core/services/screen_time_provider_test.dart`

**Interfaces:**
- Consumes: Task 1 domain contracts, `UserProfile`, `VisualThemeType`, `ISettingsRepository`, `ISoundService`, and existing profile, theme, locale, screen-time, and adventure providers.
- Produces: `SettingsProfileViewData`, `SettingsProfilesStatus`, `SettingsState`, `SettingsController`, `settingsProvider`, `settingsControllerProvider`, and `ScreenTimeNotifier.updateLimitFromSettings(int)`.

- [ ] **Step 1: Write failing state and provider-composition tests**

Add tests proving:

- state maps active profile coins and immutable profile view data
- missing profiles use 340 coins and `Grade 2`
- loading and error profile sources do not hide preference state
- a profile refresh updates profile cards without resetting preferences
- two active profiles resolve independent target standards, with `gradeLabel` fallback for an unsaved profile
- theme and locale changes update composed state

- [ ] **Step 2: Run state/provider tests and verify RED**

Run: `flutter test test/features/settings_and_parent_gate/presentation/providers/settings_provider_test.dart`

Expected: compilation fails because the presentation state and providers do not exist.

- [ ] **Step 3: Implement immutable presentation state and provider composition**

Create `SettingsProfileViewData` with ID, name, grade label, avatar, level, coins, and active status. Create `SettingsProfilesStatus { loading, data, error }`.

Create `SettingsState` with preferences, profile status and immutable view-data list, active profile ID, star coins, selected theme, locale code, target math standard, and an optional profile error message. Add this source-mapping factory:

```dart
factory SettingsState.fromSources({
  required SettingsPreferences preferences,
  required SettingsProfilesStatus profilesStatus,
  required List<UserProfile> profiles,
  required Object? profilesError,
  required UserProfile? activeProfile,
  required VisualThemeType selectedTheme,
  required String localeCode,
});
```

Use a private `StateNotifierProvider<SettingsPreferencesNotifier, SettingsPreferences>` initialized from `ISettingsRepository.loadPreferences()`. Define `settingsProvider` as a `Provider<SettingsState>` that combines the private preferences with external sources without recreating the preference notifier.

- [ ] **Step 4: Run state/provider tests and verify GREEN**

Run the Step 2 command.

Expected: state and provider tests pass.

- [ ] **Step 5: Write failing controller validation and delegation tests**

Test these public methods:

```dart
Future<void> switchProfile(String profileId);
Future<void> setSfxVolume(double value);
Future<void> setMusicVolume(double value);
Future<void> setVoiceReadAloud(bool enabled);
Future<void> setHapticBuzz(bool enabled);
Future<void> setTheme(VisualThemeType type);
Future<void> setLocale(String languageCode);
Future<void> setScreenLimitMinutes(int minutes);
Future<void> setTargetMathStandard(String standard);
Future<void> resetAdventureProgress();
ParentGateChallenge createParentGateChallenge();
```

Cover valid updates, profile switching, theme and locale delegation, screen-time synchronization, per-profile target-standard persistence, reset delegation, and deterministic challenge creation.

For invalid volume, screen-limit, locale, and standard values, assert `ArgumentError` and zero state, repository, provider, or service calls.

For a target-standard update without an active profile, assert `StateError` and no repository write. For failed SFX and music writes, assert old state remains and the sound service ends at its old volume. For failed theme and locale writes, assert the controller reapplies the previous value before surfacing the error. For other persistence failures, assert old state remains.

- [ ] **Step 6: Run controller tests and verify RED**

Run: `flutter test test/features/settings_and_parent_gate/presentation/controllers/settings_controller_test.dart`

Expected: compilation fails because `SettingsController` does not exist.

- [ ] **Step 7: Implement the injected controller**

Construct `SettingsController` with preference read/write callbacks, active-profile/theme/locale read callbacks, `ISettingsRepository`, `ISoundService`, profile/theme/locale/screen-time/adventure actions, and `ParentGateChallengeGenerator`. Use these read callbacks:

```dart
String? Function() readActiveProfileId;
VisualThemeType Function() readTheme;
String Function() readLocaleCode;
```

Validate before calls. For audio, apply the new runtime volume, persist it, and roll the runtime service back to the old volume if persistence throws. Roll theme and locale back through their injected actions when their persistence actions throw. Publish preference state only after persistence succeeds. Add `synchronizeAudio()` and call it once when `settingsControllerProvider` creates the controller.

- [ ] **Step 8: Write failing live screen-time test**

Test `updateLimitFromSettings` with 0, 15, 30, and 45. Assert it changes `limitMinutes`, preserves `todayUsedSeconds`, and recalculates `isLocked` without another Hive write.

- [ ] **Step 9: Implement live screen-time synchronization**

Add:

```dart
void updateLimitFromSettings(int limitMinutes)
```

to `ScreenTimeNotifier`. This method updates in-memory state only; `ISettingsRepository` owns the settings write.

- [ ] **Step 10: Wire cross-feature actions in `settingsControllerProvider`**

Connect the controller to `profileNotifierProvider`, `visualThemeProvider`, `localeProvider`, `screenTimeProvider`, `adventureProvider`, and `soundServiceProvider`. Keep concrete Hive and repository-implementation imports in the data provider, outside presentation.

- [ ] **Step 11: Run Task 2 tests and checkpoint**

Run: `flutter test test/features/settings_and_parent_gate/presentation test/core/services/screen_time_provider_test.dart`

Expected: all Task 2 tests pass. Record counts and any interface rulings in the ledger.

---

### Task 3: Provider-free Settings widgets

**Files:**
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/settings_app_bar.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/settings_banner.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/settings_profiles_section.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/settings_audio_card.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/settings_theme_selector.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/settings_language_selector.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/settings_parent_zone.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/settings_footer.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/parent_gate_dialog.dart`
- Create: `lib/features/settings_and_parent_gate/presentation/widgets/reset_progress_dialog.dart`
- Create: `test/features/settings_and_parent_gate/presentation/widgets/settings_widgets_test.dart`

**Interfaces:**
- Consumes: primitive display values, `SettingsProfileViewData`, `SettingsProfilesStatus`, `VisualThemeType`, `VisualThemePalette`, `ParentGateChallenge`, and callbacks.
- Produces: the ten provider-free widgets named in the spec.

- [ ] **Step 1: Write failing widget tests**

Cover these contracts:

- app bar renders active coins and invokes back
- banner preserves existing copy
- profiles section renders loading, error, empty, active, switch, add-profile, and full-slot states
- audio card reports both volume values and both switches
- theme selector renders four themes and reports selection
- language selector renders three languages and reports selection
- parent zone reports screen limit, target standard, and reset taps
- footer preserves current copy
- parent-gate dialog displays the generated prompt and returns entered text or cancellation
- reset dialog returns confirmation or cancellation

- [ ] **Step 2: Run widget tests and verify RED**

Run: `flutter test test/features/settings_and_parent_gate/presentation/widgets/settings_widgets_test.dart`

Expected: compilation fails because the widget files do not exist.

- [ ] **Step 3: Extract the widgets**

Move the current visual code into the named `StatelessWidget` classes. Pass mode and theme colors through constructors where required. Preserve existing text, spacing, borders, and selected states. Do not import Riverpod, Hive, models, repositories, or services.

- [ ] **Step 4: Run widget tests and checkpoint**

Run the Step 2 command.

Expected: all widget tests pass. Record the count and boundary scan in the ledger.

---

### Task 4: Thin Settings screen and protected UI flows

**Files:**
- Replace: `lib/features/settings_and_parent_gate/presentation/screens/settings_screen.dart`
- Create: `test/features/settings_and_parent_gate/presentation/screens/settings_screen_test.dart`

**Interfaces:**
- Consumes: Task 2 providers and controller, Task 3 widgets, and `AppRoutes.createProfile`.
- Produces: a thin `SettingsScreen` that owns composition, navigation, dialogs, and snackbars.

- [ ] **Step 1: Write failing rendering and delegation tests**

Use provider overrides and a recording controller to prove:

- the screen renders active coins, profiles, preference selections, locale, and target standard from `settingsProvider`
- profile, audio, switch, theme, and language actions delegate to the matching controller methods
- add profile navigates to `AppRoutes.createProfile` with `true`
- a profile-loading error leaves all non-profile controls rendered and interactive
- back pops when the route can pop

- [ ] **Step 2: Write failing protected-flow tests**

Prove:

- cancelling the parent gate performs no screen-limit, target-standard, or reset action
- an incorrect answer performs no protected action
- a correct answer changes screen limit and target standard through the controller
- reset requires a correct gate answer plus explicit confirmation
- success and persistence failures display the matching snackbar
- the complete screen renders without overflow at 390 by 844

- [ ] **Step 3: Run screen tests and verify RED**

Run: `flutter test test/features/settings_and_parent_gate/presentation/screens/settings_screen_test.dart`

Expected: tests fail because the current screen owns local state, Hive calls, and direct feature mutations.

- [ ] **Step 4: Replace the screen with composition and delegation**

Implement `SettingsScreen extends ConsumerWidget`. Watch `visualThemeProvider` and `settingsProvider`. Read `settingsControllerProvider` only for callbacks. Compose the ten extracted widgets in the current order.

Add private screen helpers for snackbar reporting and the parent-gate/reset dialog sequences. These helpers may use `BuildContext` and `WidgetRef`; they must not implement settings validation or persistence.

- [ ] **Step 5: Run screen and feature tests**

Run: `flutter test test/features/settings_and_parent_gate test/core/services/screen_time_provider_test.dart`

Expected: all Settings and screen-time tests pass.

- [ ] **Step 6: Mutation-check the protected boundary**

Temporarily bypass `challenge.accepts(answer)` in one protected screen helper and run the cancelled/incorrect gate tests. Expected: RED. Restore validation, rerun, and expect GREEN. Record the mutation check in the ledger.

- [ ] **Step 7: Checkpoint Task 4**

Record focused test counts, final screen line count, and any rulings in the ledger.

---

### Task 5: Boundary checks and final verification

**Files:**
- Modify: `.superpowers/sdd/2026-10-20-settings-mvvm/progress.md`
- Verify: all files changed by Tasks 1 through 4

**Interfaces:**
- Consumes: the completed Settings repository, state, controller, provider, widgets, and screen.
- Produces: formatted, analyzed, regression-tested code with recorded evidence.

- [ ] **Step 1: Format changed Dart files**

Run: `dart format <all changed Dart files>`

Expected: formatter exits 0.

- [ ] **Step 2: Verify separation and persistence boundaries**

Run `rg` over `settings_screen.dart` and the Settings widget directory. Assert zero matches for:

- `Hive`
- `RepositoryImpl`
- `profileRepositoryProvider`
- `settingsRepositoryProvider`
- `soundServiceProvider`
- `screenTimeProvider`
- `adventureProvider`
- `setState`

Run `rg` over the widget directory and assert zero matches for `flutter_riverpod`, `ConsumerWidget`, and `WidgetRef`.

- [ ] **Step 3: Analyze changed files**

Run `flutter analyze` with every changed library and test path.

Expected: no issues in changed files.

- [ ] **Step 4: Run the complete test suite**

Run: `flutter test`

Expected: all tests pass.

- [ ] **Step 5: Run full-project analysis**

Run: `flutter analyze`

Expected: no new diagnostics. Compare the result with the current baseline of 38 pre-existing diagnostics.

- [ ] **Step 6: Record completion evidence**

Append formatter, boundary-scan, focused-analysis, full-test, and full-analysis results to the ledger. Record deferred findings with their cost if any remain.
