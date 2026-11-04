# Global Response Mode Design

## Intent

Let families choose one response style for every playable math question in Math Quest. The global setting offers the current multiple-choice experience or a written-answer experience without duplicating scoring logic or exposing persistence to gameplay widgets.

## User Experience

Settings gains a provider-free **Response Mode** selector with two choices:

- **Choice:** the existing four-option answer cards remain unchanged.
- **Write:** the player enters the result using digit slots and an in-app numeric keypad.

Choice is the default for new and existing installations. The selected mode is global for the device, not profile-specific, and persists between launches.

The written-answer pad contains:

- one digit slot for each digit in the correct result;
- digits `0–9`;
- delete;
- a confirm action that is enabled only when every slot is filled.

Typing or deleting does not consume an attempt. Confirming converts the entered digits to an integer and submits it through the existing game controller. The app's generated answers are non-negative, so a minus-sign control is not needed.

## Gameplay Coverage

`ActiveGameScreen` is the shared question screen for Practice Arena, daily missions, Adventure Island, superpower challenges, exams, and replay/retry flows. It watches the global response mode and renders either the existing `AnswerOptionsGrid` or the shared written-answer pad.

`BuddyChallengeScreen` uses the same global setting. Each player arena renders its own written-answer pad. Player 1's existing rotated layout also rotates its keypad. The existing one-attempt rule applies when the player confirms:

- a wrong confirmation locks only that player's pad;
- the other player remains eligible;
- a correct confirmation scores and advances;
- two wrong confirmations advance without scoring;
- the next problem clears both inputs and locks.

Question review and result screens remain read-only and do not change.

## Architecture

### Domain and persistence

Add a persistence-safe `ResponseMode` enum with `choice` and `write`. `SettingsPreferences` owns the global value and defaults to `choice`. `ISettingsRepository` and `SettingsRepositoryImpl` load and save the enum using a stable string key, falling back to `choice` for missing or malformed values.

`SettingsController.setResponseMode(ResponseMode)` persists through the existing serialized preference queue and updates the in-memory preference snapshot only after a successful write. A focused `responseModeProvider` exposes only the immutable enum to gameplay presentation code, avoiding Hive/repository access outside the data layer.

### Settings UI

Create `SettingsResponseModeSelector`, a provider-free widget. `SettingsScreen` receives the selected mode from `SettingsState`, delegates changes to `SettingsController`, and uses the existing action/error feedback pattern. Changing this child-facing preference does not require the Parent Gate.

### Shared written response UI

Create one provider-free, stateful `WrittenAnswerPad` under gameplay presentation widgets. It owns only transient typed digits. Inputs include:

- `digitCount`;
- `enabled`;
- `accentColor`;
- optional evaluation state for Active Game feedback;
- `ValueChanged<int> onSubmit`.

The parent gives the pad a question-specific widget key. When Active Game's `MathProblem` changes or Buddy's problem revision changes, Flutter recreates the pad and clears its local digits. Controllers continue receiving only an integer answer, so evaluation, scoring, sound, reports, timers, and navigation remain mode-independent.

Active Game shows correct/incorrect feedback during its existing evaluation interval except in exam mode, matching current Choice behavior. Buddy Challenge leaves a confirmed wrong value visible in its disabled pad until the opponent answers or the problem advances.

## Separation of Concerns

- Settings domain state represents the preference.
- The repository is the only layer that knows the storage key.
- The settings controller owns serialized mutation and rollback behavior.
- Gameplay screens select the response presentation through a focused provider.
- `WrittenAnswerPad` owns transient editing only and imports neither Riverpod nor persistence.
- Existing gameplay controllers remain the sole authority for accepting and scoring submitted integers.

## Approaches Considered

### Shared response component (selected)

Use one persisted enum and one written-answer pad in Active Game and Buddy Challenge. This keeps validation and interaction consistent while retaining each screen's existing Choice UI.

### Separate written inputs per screen

This could be implemented faster initially but would duplicate digit limits, keypad behavior, accessibility, reset behavior, and tests. It was rejected because the feature is global and should behave identically throughout the app.

### System numeric keyboard

This would reduce custom UI code, but the keyboard can cover gameplay and works poorly for two players sharing a rotated split screen. It was rejected in favor of an in-app keypad.

## Accessibility and Responsive Behavior

- Every digit key has a semantic label.
- Digit slots expose the current entry and required length to assistive technology.
- Disabled/confirmed pads do not accept pointer or semantic actions.
- Confirm and delete have text/icon semantics, not color-only meaning.
- The pad must fit Active Game and both Buddy arenas at 390×844 without overflow.
- Player 1's complete arena, including semantics and hit targets, follows the existing 180-degree rotation.

## Error and Edge Cases

- Missing or unknown stored mode falls back to Choice.
- Confirm is disabled for incomplete input.
- Extra digits are ignored once all slots are full.
- Delete on an empty input is harmless.
- Zero is a valid one-digit answer.
- Repeated confirms are blocked while Active Game evaluates or after a Buddy player has answered.
- Changing mode in Settings affects subsequently rendered questions; no active game migration is required because Settings is not reachable inside an active question screen.
- A persistence failure leaves the previous mode active and uses the existing Settings error snackbar.

## Verification

Tests will cover enum persistence/fallback, serialized controller updates and failure behavior, provider propagation, Settings selector callbacks, Choice default/backward compatibility, written-pad digit limits/delete/confirm/reset/accessibility/layout, Active Game submission and evaluation, and Buddy per-player locking/reset behavior in Write mode. Full-suite verification and focused architecture scans will confirm no persistence leaks into gameplay widgets.
