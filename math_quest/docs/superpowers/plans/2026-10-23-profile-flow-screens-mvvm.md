# Profile Flow Screens MVVM Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor All Badges, Create Profile, Onboarding, and Parent Diagnostic into testable MVVM flows with thin screens, provider-free widgets, and no presentation-layer database access.

**Architecture:** Each screen receives an immutable presentation state from a focused Riverpod provider and delegates actions to a controller. Screens retain navigation, dialogs, snackbars, and Flutter lifecycle objects; extracted widgets receive plain values and callbacks. Onboarding persistence crosses a new domain repository interface implemented against Hive in the data layer.

**Tech Stack:** Flutter, Dart, Riverpod 2.6, Hive behind repository interfaces, flutter_test.

**Spec:** `docs/superpowers/specs/2026-10-23-profile-flow-screens-mvvm-design.md`

## Global Constraints

- Preserve current UI copy, navigation, badge dialog, and placeholder PDF feedback.
- No Hive, repository implementation, or data-model imports in screens or presentation widgets.
- No Riverpod imports in extracted widgets.
- Exposed state collections are immutable snapshots.
- Use RED→GREEN TDD for every behavior change.

## Review Focus

- A profile update while All Badges is open must refresh unlock state without restoring a stale filtered list.
- Rapid repeated profile submissions must create and persist exactly one profile.
- A failed profile/onboarding write must re-enable submission and preserve the original error for UI feedback.
- Dragging onboarding pages and pressing Next must keep provider state and `PageController` synchronized.
- Empty and malformed mastery data must produce finite diagnostic progress and safe fallback content.

---

### Task 1: All Badges State, Controller, and Provider-Free UI

**Files:**
- Create: `lib/features/profile_and_stats/presentation/models/all_badges_state.dart`
- Create: `lib/features/profile_and_stats/presentation/controllers/all_badges_controller.dart`
- Create: `lib/features/profile_and_stats/presentation/providers/all_badges_provider.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/all_badges_widgets.dart`
- Modify: `lib/features/profile_and_stats/presentation/screens/all_badges_screen.dart`
- Create: `test/features/profile_and_stats/presentation/controllers/all_badges_controller_test.dart`
- Create: `test/features/profile_and_stats/presentation/screens/all_badges_screen_test.dart`
- Create: `test/features/profile_and_stats/presentation/widgets/all_badges_widgets_test.dart`

**Interfaces:**
- Consumes: `UserProfile?`, `BadgeItem.allBadges`, and `visualThemeProvider`.
- Produces: `BadgeViewData`, `AllBadgesState.fromSources(...)`, `AllBadgesController.selectCategory(String)`, and `allBadgesProvider` as an auto-dispose state-notifier provider.

- [ ] **Step 1: Write failing state/controller tests** for default `ALL`, category filtering, unlocked mapping, immutable lists, invalid categories, and profile-source refresh preserving a valid selection.
- [ ] **Step 2: Run the controller test and verify RED** because the model/controller contracts do not exist.
- [ ] **Step 3: Implement the immutable model, controller, and provider composition** with categories `ALL`, `SPEED`, `ACCURACY`, `STREAK`, `MILESTONE`, `MASTERY`, and `ADVENTURE`.
- [ ] **Step 4: Run the controller test and verify GREEN.**
- [ ] **Step 5: Write failing widget/screen tests** for count rendering, category delegation, unlocked/locked detail dialog, back navigation, profile refresh, and 390×844 overflow safety.
- [ ] **Step 6: Extract provider-free app bar/filter/grid/detail widgets and reduce the screen to provider wiring plus navigation/dialog ownership.**
- [ ] **Step 7: Run all All Badges tests and focused analysis.**

### Task 2: Create Profile Persistence Boundary and MVVM Flow

**Files:**
- Create: `lib/features/profile_and_stats/domain/repositories/i_onboarding_repository.dart`
- Create: `lib/features/profile_and_stats/data/repositories/onboarding_repository_impl.dart`
- Create: `lib/features/profile_and_stats/data/providers/onboarding_repository_provider.dart`
- Create: `lib/features/profile_and_stats/presentation/models/create_profile_state.dart`
- Create: `lib/features/profile_and_stats/presentation/controllers/create_profile_controller.dart`
- Create: `lib/features/profile_and_stats/presentation/providers/create_profile_provider.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/create_profile_widgets.dart`
- Modify: `lib/features/profile_and_stats/presentation/screens/create_profile_screen.dart`
- Create: `test/features/profile_and_stats/data/repositories/onboarding_repository_impl_test.dart`
- Create: `test/features/profile_and_stats/presentation/controllers/create_profile_controller_test.dart`
- Create: `test/features/profile_and_stats/presentation/screens/create_profile_screen_test.dart`
- Create: `test/features/profile_and_stats/presentation/widgets/create_profile_widgets_test.dart`

**Interfaces:**
- Consumes: `ProfileNotifier.createProfile(UserProfile)`, injected `DateTime Function()`, injected ID factory, and `IOnboardingRepository.completeOnboarding()`.
- Produces: immutable `CreateProfileState`, `CreateProfileController` selection/name actions plus `Future<UserProfile> submit()`, and `createProfileProvider` as an auto-dispose state-notifier provider.

- [ ] **Step 1: Write failing repository tests** proving `completeOnboarding()` writes `has_seen_onboarding = true` only through the data implementation.
- [ ] **Step 2: Implement the repository interface, Hive implementation, and data-layer provider; run repository tests GREEN.**
- [ ] **Step 3: Write failing controller tests** for defaults, avatar/grade/name changes, blank-name fallback, exact starter profile/mastery data, deterministic ID/date, immutable options, duplicate-submit coalescing, and retry after persistence failure.
- [ ] **Step 4: Implement state/controller/provider composition** with profile creation before onboarding completion and original-error propagation.
- [ ] **Step 5: Run controller tests GREEN.**
- [ ] **Step 6: Write failing widget/screen tests** for rendering, selection callbacks, disabled submitting state, settings-origin pop/snackbar, onboarding-origin replacement navigation, failure snackbar, and 390×844 overflow safety.
- [ ] **Step 7: Extract provider-free form widgets and reduce the screen to state binding and navigation/feedback.**
- [ ] **Step 8: Run all Create Profile tests and focused analysis.**

### Task 3: Onboarding State Machine and Provider-Free Slides

**Files:**
- Create: `lib/features/profile_and_stats/presentation/models/onboarding_state.dart`
- Create: `lib/features/profile_and_stats/presentation/controllers/onboarding_controller.dart`
- Create: `lib/features/profile_and_stats/presentation/providers/onboarding_provider.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/onboarding_widgets.dart`
- Modify: `lib/features/profile_and_stats/presentation/screens/onboarding_screen.dart`
- Create: `test/features/profile_and_stats/presentation/controllers/onboarding_controller_test.dart`
- Create: `test/features/profile_and_stats/presentation/screens/onboarding_screen_test.dart`
- Create: `test/features/profile_and_stats/presentation/widgets/onboarding_widgets_test.dart`

**Interfaces:**
- Consumes: fixed existing slide copy/colors and `AppRoutes.createProfile`.
- Produces: `OnboardingSlideViewData`, immutable `OnboardingState`, `OnboardingAdvanceResult`, `OnboardingController.selectPage(int)`, `OnboardingController.advance()`, and an auto-dispose provider.

- [ ] **Step 1: Write failing controller tests** for immutable slides, drag selection, advance through pages, finish result on the last page, and invalid indexes.
- [ ] **Step 2: Run controller tests RED; implement model/controller/provider; rerun GREEN.**
- [ ] **Step 3: Write failing widget/screen tests** for slide rendering, typewriter key/content, dots/button copy, swipe synchronization, Next animation, Skip/finish replacement navigation, controller disposal, and 390×844 overflow safety.
- [ ] **Step 4: Extract provider-free top bar, slide, and footer widgets; retain only `PageController` lifecycle and navigation in the screen.**
- [ ] **Step 5: Run all Onboarding tests and focused analysis.**

### Task 4: Parent Diagnostic Derived State and Report Widgets

**Files:**
- Create: `lib/features/profile_and_stats/presentation/models/parent_diagnostic_state.dart`
- Create: `lib/features/profile_and_stats/presentation/providers/parent_diagnostic_provider.dart`
- Create: `lib/features/profile_and_stats/presentation/widgets/parent_diagnostic_widgets.dart`
- Modify: `lib/features/profile_and_stats/presentation/screens/parent_diagnostic_screen.dart`
- Create: `test/features/profile_and_stats/presentation/providers/parent_diagnostic_provider_test.dart`
- Create: `test/features/profile_and_stats/presentation/screens/parent_diagnostic_screen_test.dart`
- Create: `test/features/profile_and_stats/presentation/widgets/parent_diagnostic_widgets_test.dart`

**Interfaces:**
- Consumes: `UserProfile?`, `MasteryTrack`, `profileNotifierProvider`, and an overridable `DateTime` provider.
- Produces: `DiagnosticOperationStatus`, `OperationDiagnosticViewData`, `ParentDiagnosticState.fromProfile(...)`, and `parentDiagnosticProvider`.

- [ ] **Step 1: Write failing mapping tests** for missing profile defaults, injected report date, total solved, active-track average, finite/clamped progress, readiness copy, and pending/needs-practice/on-track/mastered thresholds.
- [ ] **Step 2: Run provider/model tests RED; implement state mapping and pure provider; rerun GREEN.**
- [ ] **Step 3: Write failing widget/screen tests** for summary/readiness/operation rendering, back navigation, share and worksheet snackbars, empty operations, long names, and 390×844 overflow safety.
- [ ] **Step 4: Extract provider-free report-section widgets and reduce the screen to provider binding plus navigation/feedback actions.**
- [ ] **Step 5: Run all Parent Diagnostic tests and focused analysis.**

### Task 5: Cross-Flow Architecture and Regression Verification

**Files:**
- Modify: changed files above only as required by verification.
- Create: `.superpowers/sdd/2026-10-23-profile-flow-screens-mvvm/progress.md`

**Interfaces:**
- Consumes: completed Tasks 1–4.
- Produces: verified profile-flow refactor with documented evidence.

- [ ] **Step 1: Run `dart format` across all changed Dart files.**
- [ ] **Step 2: Scan screens/widgets for `Hive`, repository implementations/providers, data models, and `setState`; scan extracted widgets for Riverpod.**
- [ ] **Step 3: Run focused profile-flow tests and focused `flutter analyze` over every changed production/test path.**
- [ ] **Step 4: Run full `flutter test` and record the exact pass count.**
- [ ] **Step 5: Run full `flutter analyze`; separate new diagnostics from pre-existing project diagnostics.**
- [ ] **Step 6: Request an independent whole-change review focused on SOLID/MVVM boundaries, async lifecycle, persistence ordering, source refreshes, navigation, and accessibility; fix Critical/Important findings with RED→GREEN regressions.**
- [ ] **Step 7: Repeat fresh focused and full verification, then record final evidence in the SDD ledger.**
