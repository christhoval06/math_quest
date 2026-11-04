# Profile Flow Screens MVVM Design

## Intent

Refactor All Badges, Create Profile, Onboarding, and Parent Diagnostic to match the Home Dashboard architecture: immutable presentation state, provider/controller-owned logic, thin navigation shells, and provider-free widgets. Preserve the current UI, copy, navigation, badge dialog, and placeholder PDF feedback.

## Goals

- Separate state derivation and user-action logic from Flutter layout.
- Make filtering, profile creation, onboarding progression, and diagnostic calculations directly unit testable.
- Remove Hive and repository access from presentation screens and widgets.
- Keep widgets reusable and testable without `ProviderScope`.
- Preserve current behavior and visual hierarchy.

## Non-goals

- Redesigning the four screens.
- Implementing real PDF export or worksheet generation.
- Changing badge unlock rules, profile starter values, onboarding copy, or diagnostic thresholds.
- Removing unrelated database access elsewhere in the application.

## Constraints

- Riverpod remains the composition mechanism in screen-level providers.
- Extracted widgets must not import Riverpod, Hive, repositories, or data models.
- Screens may own Flutter-only adapters such as `PageController`, navigation, dialogs, and snackbars.
- All persistent onboarding writes must cross a domain repository interface implemented in the data layer.
- Lists exposed by presentation state are immutable snapshots.

## Approaches

1. **One state/controller/provider set per screen (chosen).** Each flow has a focused immutable state model and controller where interaction exists. Providers compose existing profile state and injected persistence. This mirrors Home Dashboard while preventing a large cross-screen view model.
2. **One shared profile-area view model.** This reduces provider count but couples unrelated page lifecycles, resets, and tests.
3. **Keep local widget state and extract only visual widgets.** This is smaller, but filtering, profile construction, page progression, and diagnostics would remain difficult to unit test and would not meet the requested MVVM boundary.

## Design

### All Badges

`AllBadgesState` maps badge entities plus unlocked IDs into immutable `BadgeViewData` rows and owns category filtering. `AllBadgesController` changes the selected category. The screen watches the provider, delegates selection, owns back navigation and `showDialog`, and renders provider-free app bar, filter, grid, and detail widgets.

### Create Profile

`CreateProfileState` owns name, selected avatar, selected grade, immutable options, submission status, and error text. `CreateProfileController` validates/defaults the name, creates the starter `UserProfile` from an injected clock/ID source, coalesces duplicate submissions, calls the existing profile notifier through an injected action, and marks onboarding complete through `IOnboardingRepository`. The screen owns success navigation/snackbar and failure snackbar only. Hive is confined to `OnboardingRepositoryImpl`.

### Onboarding

`OnboardingState` owns immutable slide view data and the selected page. `OnboardingController` validates page changes and returns an explicit advance/finish result. The screen retains only `PageController` because it is a Flutter lifecycle object; all visible content is provider-free.

### Parent Diagnostic

`ParentDiagnosticState.fromProfile` calculates totals, average active-track accuracy, readiness copy/progress, formatted report date, and operation statuses using an injected date. A pure provider maps the active profile into that state. The screen owns back navigation and the existing placeholder snackbars; provider-free widgets render all report sections.

## Error and Lifecycle Behavior

- Profile submission disables while in flight, duplicate calls share one future, failures remain retryable, and the original error reaches the screen.
- Invalid badge categories and onboarding page indexes are ignored or rejected without corrupting state.
- Missing profiles retain the current Leo / Grade 2 / avatar defaults.
- Providers with screen-local interaction auto-dispose so reopening begins with default selections.

## Verification

- Unit tests cover state mapping, immutability, thresholds, controller transitions, duplicate submission, and persistence failure.
- Widget tests cover rendered state, callbacks, navigation/feedback, dialog behavior, and 390×844 layout.
- Boundary scans prove screens/widgets contain no Hive, repository implementation, or direct data-model access, and extracted widgets contain no Riverpod.
- Run focused analysis/tests, then the complete Flutter test and analyzer suites.
