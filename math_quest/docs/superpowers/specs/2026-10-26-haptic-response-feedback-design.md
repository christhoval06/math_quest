# Haptic Response Feedback Design

## Intent

Make answer interactions feel responsive while honoring the existing device-wide **Haptic Touch Buzz** setting. Haptics must work for both Choice and Write response modes, remain silent when disabled, and be easy to unit test without calling platform APIs.

## Selected Experience

Use layered native haptics:

- valid digit and delete actions use a subtle selection click;
- confirming a written answer or selecting a choice uses a medium impact;
- a correct non-exam answer uses a light positive impact;
- an incorrect non-exam answer uses a stronger warning impact;
- exam mode uses submission feedback only and never reveals correctness;
- ignored, disabled, incomplete, stale, or duplicate interactions produce no haptic.

The existing setting remains global and defaults to enabled. Turning it off suppresses every haptic event immediately after the preference is successfully saved.

## Architecture

Create `IHapticService` in `lib/core/haptics/` with semantic methods for selection, answer submission, correct answer, incorrect answer, and runtime enablement. `HapticServiceImpl` wraps Flutter's native `HapticFeedback`, catches platform failures, and performs no work while disabled. A Riverpod provider owns the shared runtime service.

`SettingsController` receives the abstraction, synchronizes its enabled state from persisted preferences at startup, and updates it after a successful Haptic Buzz write. A failed persistence write leaves both the stored preference and runtime service unchanged.

Gameplay controllers trigger semantic answer events so Choice and Write share the same submission/result behavior. `ActiveGameController` emits submission feedback for accepted answers and correct/incorrect feedback only outside exam mode. `BuddyChallengeController` emits feedback only for accepted current-revision attempts, preserving its synchronous scoring and one-attempt locks.

`WrittenAnswerPad` remains provider-free. It receives an optional input-feedback callback and invokes it only after a digit is actually added or a digit is actually deleted. Confirmation haptics remain controller-owned to avoid duplicate events. Buddy passes the callback through its provider-free playing view and player arena.

## Separation and Testability

- Platform APIs exist only in `HapticServiceImpl`.
- Settings and gameplay depend on `IHapticService` or injected callbacks, never static platform calls.
- Widgets remain provider-free and persistence-free.
- Fake services/callbacks verify event ordering and disabled behavior.
- No new package dependency is required.

## Approaches Considered

### Layered semantic service — selected

Semantic methods keep platform mappings centralized and let correct, incorrect, submit, and editing interactions feel distinct. This offers the most professional feedback while remaining testable.

### Minimal confirm/result feedback

This reduces vibration frequency but leaves the custom keypad feeling less tactile. It was not selected.

### Uniform vibration

This is simplest but cannot communicate the difference between editing, submitting, success, and error. It was not selected.

## Verification

Tests will prove service-to-platform mappings, disabled suppression, platform-error containment, Settings synchronization and persistence failure behavior, valid keypad editing feedback, absence of feedback for ignored input, Active Game exam privacy, and Buddy stale/duplicate-attempt suppression. The full Flutter test suite and analyzer will be rerun.
