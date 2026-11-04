# Reusable Parent Gate Design

## Intent

Replace the two inconsistent multiplication dialogs with one professional, reusable full-screen parent-verification flow. A successful verification authorizes only the action that requested it.

## Goals

- Present one consistent full-screen parent gate from Settings and screen-time extension.
- Keep challenge validation directly unit testable and UI rendering provider-free.
- Support purpose-specific title, explanation, and primary-action copy.
- Keep an incorrect answer on the screen with clear inline feedback and retry.
- Support keyboard submission, back/cancel, accessibility, and phone/tablet layouts.

## Non-goals

- Persisting an unlocked parent session.
- Replacing the multiplication challenge with authentication or a PIN.
- Redesigning the screen-time rest dialog or protected Settings controls.

## Architecture

`ParentGateController` owns answer validation and immutable `ParentGateState`. `ParentGateScreen` binds the controller to provider-free widgets and returns a boolean route result. `ParentGateLauncher.requestAccess(...)` is the single navigation entry point and accepts `ParentGateConfig` so each protected action can explain why adult access is required.

The existing domain `ParentGateChallenge` and generator remain the source of challenge creation and validation. Settings and screen-time navigation will both call the launcher; all inline `AlertDialog` gate code and `ParentGateDialog` will be removed.

## Approved Approach

Use a full-screen route with a shared launcher and purpose configuration. A successful challenge unlocks only the current requested action; every later protected action requires a new challenge.
