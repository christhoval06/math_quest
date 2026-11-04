# Settings MVVM Refactor

## Goal

Refactor `SettingsScreen` to follow the provider-based MVVM pattern used by `HomeDashboardScreen`. Keep navigation, dialogs, and snackbars in the screen. Move settings state, validation, persistence coordination, audio updates, profile switching, and adventure reset behavior into a controller. Split the 1,142-line layout into provider-free widgets.

The refactor must preserve the current visual design and parent-gate flow. It must also make the music, voice, haptic, and target-standard controls functional and persistent.

## Current Problems

`SettingsScreen` owns mutable settings fields, reads and writes Hive, changes providers, invokes audio services, switches profiles, resets adventure progress, runs parent-gate logic, and renders the complete layout. Helper methods depend on screen state and `WidgetRef`, which prevents isolated widget tests.

Several controls do not complete their intended behavior:

- Music, voice read-aloud, and haptic values live only in widget state.
- The SFX slider changes the sound service but does not persist its value.
- The target-standard action saves an unchanged profile.
- The app bar displays a hardcoded coin count.
- The screen-time selector writes Hive without synchronizing `screenTimeProvider`.

## Architecture

### SettingsState

Create an immutable presentation state in `settings_provider.dart`. It contains:

- profile loading, error, and data states
- active profile ID and star coins
- SFX and music volume
- voice read-aloud and haptic preferences
- selected visual theme
- selected locale code
- daily screen-limit minutes
- the active profile's target math standard

The state stores immutable profile view-data snapshots rather than data models. Existing values remain the defaults: SFX 0.8, music 0.6, voice enabled, haptics enabled, 30 minutes, English, and Galaxy Quest. An active profile without a saved target standard uses its `gradeLabel`.

### SettingsController

The controller owns settings behavior:

- switch the active profile
- set SFX and music volume
- set voice read-aloud and haptics
- set the visual theme and locale
- set the daily screen limit
- set the active profile's target math standard
- reset adventure progress

The controller accepts injected actions for state reads and writes, persistence, sound updates, provider synchronization, profile switching, and adventure reset. Unit tests can exercise its rules without Flutter widgets, Hive, audio plugins, or concrete repositories.

The controller validates inputs before any state or external-service mutation:

- volumes must fall between 0.0 and 1.0
- screen limits must be 0, 15, 30, or 45 minutes
- locale codes must be `en`, `es`, or `pt`
- target standards must be `Pre-K`, `Grade 1`, `Grade 2`, or `Grade 3+`

Persistence completes before the controller publishes the new preference. If persistence fails, the old state remains visible and the screen shows an error. Theme and locale continue through their existing notifiers, which own their persistence.

### Settings Repository

Add `ISettingsRepository` to the feature domain layer and a Hive implementation to the feature data layer. The interface exposes typed reads and writes for SFX volume, music volume, voice read-aloud, haptics, daily screen limit, and target math standards.

The Hive implementation contains all storage keys and conversions. It stores target standards by profile ID with a key such as `target_math_standard_<profileId>`. This design keeps curriculum separate from the child's school `gradeLabel` and avoids changing the existing positional `UserProfileModelAdapter` format. Existing profiles receive their `gradeLabel` as the fallback until a parent saves a target standard.

The presentation provider may depend on the repository interface provider. `SettingsScreen` and extracted widgets must not import Hive, data models, repository implementations, or concrete persistence APIs.

### Parent Gate

Create a pure `ParentGateChallenge` value with two factors, display text, and answer validation. A generator accepts an injected random-number source so tests can produce stable challenges.

The screen owns the interaction sequence:

1. Request a challenge from the controller.
2. Present the provider-free parent-gate dialog.
3. Submit the entered answer for validation.
4. Run the requested protected action only after a correct answer.

Screen-limit and target-standard changes require the gate. Adventure reset requires the gate followed by the existing confirmation dialog. Cancelled or incorrect answers leave state and persistence unchanged.

### Providers

Expose two providers:

- `settingsProvider` supplies `SettingsState` and combines stored preferences with active-profile, all-profile, theme, and locale sources.
- `settingsControllerProvider` supplies `SettingsController` and connects it to repository, sound, screen-time, profile, theme, locale, and adventure abstractions.

Profile refreshes update profile cards, coins, and the active target-standard fallback without recreating the preference state. Switching profiles loads the selected profile's target standard.

The provider layer may depend on other presentation providers. It must keep storage and data-model details behind domain interfaces.

### Screen

Convert `SettingsScreen` into a thin `ConsumerWidget`. It watches the visual theme and `settingsProvider`, delegates actions to `settingsControllerProvider`, and owns these UI effects:

- back and create-profile navigation
- success and error snackbars
- parent-gate presentation
- reset confirmation

The screen must not call `setState`, access Hive, save repositories, update sound services, implement validation rules, or reset adventure state through a feature notifier.

### Widgets

Extract provider-free widgets under `features/settings_and_parent_gate/presentation/widgets`:

- `SettingsAppBar`
- `SettingsBanner`
- `SettingsProfilesSection`
- `SettingsAudioCard`
- `SettingsThemeSelector`
- `SettingsLanguageSelector`
- `SettingsParentZone`
- `SettingsFooter`
- `ParentGateDialog`
- `ResetProgressDialog`

Each widget receives presentation values and callbacks through its constructor. Widgets must not read Riverpod providers or persistence services.

## Data Flow

1. `settingsProvider` reads preference state and composes it with profile, theme, and locale state.
2. The screen passes plain values and callbacks into extracted widgets.
3. A widget callback asks the controller to change one setting.
4. The controller validates the value and invokes the injected persistence or service action.
5. The controller publishes an immutable state update after the action succeeds.
6. Riverpod rebuilds the affected presentation.
7. The screen reports success or failure through a snackbar when the action needs user feedback.

Protected actions add the parent-gate and confirmation steps before step 3.

## Functional Settings

The refactor gives each visible control a real effect:

- SFX volume persists and updates `ISoundService.setSfxVolume`.
- Music volume persists and updates `ISoundService.setMusicVolume`.
- Voice read-aloud persists for future consumers.
- Haptic preference persists for future consumers.
- Theme and locale continue to update their existing providers and persistence.
- Screen limit persists and updates the live screen-time state.
- Target math standard persists per profile without changing `gradeLabel`.
- Profile switching and adventure reset continue to use their existing feature providers through controller actions.

This work does not add text-to-speech, background-music playback, or haptic feedback calls to gameplay. It provides durable settings that those systems can consume.

## Failure Handling

Controller methods return futures for persistent or cross-feature actions. The screen catches failures and displays an error snackbar. Failed writes leave the previous presentation state intact.

Profile load errors remain local to the profiles section so the rest of Settings stays usable. Missing active profiles use safe display fallbacks. The controller rejects unsupported values with `ArgumentError` before calling persistence or services.

Parent-gate cancellation and incorrect answers produce no mutation. A reset failure keeps the existing adventure state and displays an error.

## Testing

### Repository tests

Use an isolated Hive box to verify defaults, typed persistence, per-profile target-standard keys, and grade-label fallback behavior.

### State and controller tests

Cover:

- defaults and immutable profile snapshots
- profile mapping and active coin count
- profile refresh without preference reset
- valid settings updates
- invalid-value rejection before mutation
- persistence failure preserving old state
- SFX and music service synchronization
- screen-time synchronization
- per-profile target-standard behavior
- profile switching and adventure reset delegation
- deterministic parent-gate generation and validation

### Widget tests

Render each extracted control without a provider container. Verify selected states, labels, loading and error states, and callback delivery.

### Screen tests

Override presentation providers and verify state rendering, action delegation, create-profile navigation, parent-gate flows, reset confirmation, success and error messages, and layout at 390 by 844.

### Regression checks

Run focused feature tests, the complete Flutter test suite, formatting, changed-file analysis, and full-project analysis. Scan the screen and widget directory for Hive, data-model, repository-implementation, direct persistence, and `setState` references. Scan widgets for Riverpod references.

## Boundaries

The refactor covers Settings presentation, preference persistence, live service synchronization, parent-gate logic, active-profile curriculum, and adventure-reset coordination. It does not redesign the UI, add cloud synchronization, implement text-to-speech, start background music, add gameplay haptics, or change the profile Hive adapter schema.

## Success Criteria

- `SettingsScreen` contains composition, provider reads, navigation, dialogs, and snackbar handling only.
- Settings rules and parent-gate behavior have controller-level unit tests.
- Extracted widgets run without Riverpod or database setup.
- Settings screen and widgets contain no Hive, data-model, or repository-implementation imports.
- All visible preferences persist; SFX, music, theme, locale, and screen limit update their current runtime consumers.
- Target math standard persists per profile without changing `gradeLabel`.
- The screen preserves its current layout and renders without overflow at the existing phone viewport.
- The full Flutter test suite passes.
- Changed files pass `flutter analyze`.
