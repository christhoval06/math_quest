# Custom Mission MVVM Refactor

## Goal

Refactor `CustomMissionScreen` to follow the provider-based MVVM pattern used by `HomeDashboardScreen` and `ActiveGameScreen`. Keep navigation in the screen, move mission state and behavior into a controller, and split the 913-line layout into provider-free widgets.

The refactor must preserve the current visual layout and mission defaults. It must also make the visual-aid and sound controls affect the launched game.

## Current Problems

`CustomMissionScreen` owns selection state, selection rules, practice-session mutation, route construction, navigation, and the complete layout. Private widget-builder methods read mutable screen fields, which prevents isolated widget tests.

The screen displays hardcoded profile counters even though the app already exposes profile state through Riverpod. The visual-aid and sound switches update local fields but do not affect the launched game.

## Architecture

### CustomMissionState

Create an immutable presentation state in `custom_mission_provider.dart` with these values:

- selected operations
- exam mode
- difficulty
- timer duration
- question count
- visual-aid preference
- sound preference
- star coins and streak days

The state takes immutable snapshots of collection inputs. It exposes presentation values that depend on mission state, including the launch-button label. It uses Addition, Medium, 60 seconds, 10 questions, visual aids enabled, and sound enabled as defaults.

### CustomMissionController

The controller owns mission mutations:

- `setExamMode`
- `toggleOperation`
- `selectDifficulty`
- `selectTimer`
- `setVisualAidsEnabled`
- `setSoundEnabled`
- `selectQuestionCount`
- `prepareMission`

The controller keeps at least one operation selected. Entering exam mode disables visual aids. Returning to practice mode enables them, matching the current screen behavior. The controller accepts injected state-read, state-write, and session-preparation actions so unit tests can run without Flutter widgets, audio plugins, Hive, or repositories.

`prepareMission` captures the selected values in an immutable `PreparedCustomMission`, resets the practice session once with the first selected operation and chosen difficulty, and applies the chosen visual-aid setting. The screen converts the prepared result into `ActiveGameArgs` and navigates.

### Providers

Expose two providers:

- `customMissionProvider` supplies `CustomMissionState` and watches the active profile for star coins and streak days.
- `customMissionControllerProvider` supplies `CustomMissionController` and connects it to `practiceSessionProvider`.

The provider layer may depend on other presentation providers. It must not import Hive, data models, repository implementations, or concrete persistence APIs.

### Screen

Convert `CustomMissionScreen` into a thin `ConsumerWidget`. It watches the visual theme and `customMissionProvider`, delegates user actions to `customMissionControllerProvider`, and owns back and launch navigation.

The screen must not call `setState`, reset the practice session, manipulate audio, or implement selection rules.

### Widgets

Extract provider-free widgets under `features/mission_setup/presentation/widgets`:

- `CustomMissionAppBar`
- `MissionLabHeader`
- `MissionModeSelector`
- `MissionOperationGrid`
- `MissionDifficultySelector`
- `MissionTimerSelector`
- `MissionHelperToggles`
- `MissionQuestionSelector`
- `MissionRewardBanner`
- `MissionLaunchButton`

Each widget receives display values and callbacks through its constructor. Widgets must not read Riverpod providers or persistence services.

## Active Game Integration

Add `visualAidsEnabled` and `soundEnabled` to `ActiveGameArgs` and `ActiveGameConfig`.

The practice-session preparation path applies `visualAidsEnabled` before navigation. Add an explicit visual-aid setter to `PracticeSessionNotifier`; avoid toggle-based synchronization because repeated launches must produce the requested value.

`ActiveGameController` uses `soundEnabled` when it selects feedback actions. A disabled mission skips tap, correct, and wrong sounds for that game without changing global sound-service volume. Exam mode keeps its current feedback sequence when sound is enabled.

Other callers receive default values that preserve their current behavior.

## Data Flow

1. The screen watches mission state and renders extracted widgets.
2. A widget callback calls one controller method.
3. The controller writes a new immutable state.
4. Riverpod rebuilds the affected presentation.
5. The launch callback asks the controller for `PreparedCustomMission`.
6. The controller prepares the practice session.
7. The screen creates `ActiveGameArgs` from the prepared result and opens Active Game with `preservePreparedSession: true`.

## Validation and Failure Handling

The controller rejects invalid timer values and question counts at its public boundary. Supported timer values are 0, 30, 60, and 120 seconds. Supported question counts range from 10 through 50 in increments of 5.

The controller ignores an attempt to remove the last selected operation. It stores immutable operation sets and returns immutable operation lists in the launch result.

Session preparation remains synchronous under the current `PracticeSessionNotifier` contract. If that action throws, navigation does not run because the screen receives no prepared result.

## Testing

### Controller tests

Cover:

- defaults and profile-counter mapping
- immutable operation collections
- operation selection and last-operation protection
- difficulty, timer, and question-count changes
- practice and exam mode visual-aid rules
- sound and visual-aid preferences
- invalid timer and question-count rejection
- one session reset per launch
- complete immutable launch configuration

### Widget tests

Render each extracted control without a provider container. Verify selected states, labels, and callback delivery.

### Screen tests

Override presentation providers and verify state rendering, action delegation, route arguments, prepared-session preservation, and layout at the existing phone viewport.

### Active Game tests

Verify that `soundEnabled: false` suppresses feedback actions and that prepared visual-aid state reaches the problem card. Existing timer, answer, navigation, and race-condition tests must remain green.

## Boundaries

The refactor covers Custom Mission presentation, its practice-session preparation, and the two settings required by Active Game. It does not redesign rewards, change global audio preferences, add persistence for draft mission selections, or alter the visual design.

## Success Criteria

- `CustomMissionScreen` contains composition, provider reads, callback delegation, and navigation only.
- Mission rules have controller-level unit tests.
- Extracted widgets run without Riverpod or database setup.
- Custom Mission screen and widgets contain no Hive, data-model, or repository-implementation imports.
- Visual-aid and sound controls affect the launched game.
- The full Flutter test suite passes.
- Changed files pass `flutter analyze`.
