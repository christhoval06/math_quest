# MathQuest Landing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the approved standalone Flutter promotional website in `/web`.

**Architecture:** Separate Flutter project with generated ARB localization and a focused landing feature. Compose section widgets using shared theme/layout primitives; inject an external-action service.

**Tech Stack:** Flutter, Dart, flutter_localizations, url_launcher.

**Spec:** docs/superpowers/specs/2026-11-04-mathquest-landing-design.md

## Global Constraints
- Existing mobile app remains unchanged.
- English, Spanish, Portuguese; local assets; no unverified social proof.
- Real screenshot proportions, responsive 1080px content, accessible controls.
- No deployment or store publishing.

## Review Focus
- Narrow screens and enlarged text must not overflow.
- Locale changes must update navigation, content and accessible labels.
- Navigation must reach sections even with reduced motion enabled.
- Gallery controls must move screenshots and respect both boundaries.
- Failed external actions must give localized feedback.

### Task 1: Independent project and localized shell
**Files:** web/pubspec.yaml, web/l10n.yaml, web/lib/main.dart, web/lib/app.dart, web/lib/l10n/app_{en,es,pt}.arb, web/lib/theme/landing_theme.dart, web/test/landing_test.dart.
**Interfaces:** `LandingApp({LandingActions? actions, Locale? initialLocale})` owns locale. `LandingPage({required ValueChanged<Locale> onLocaleChanged, required LandingActions actions})` composes the site. `LandingActions.requestAvailability()` returns `Future<bool>`.
- [ ] Configure a web-only Flutter project and local assets; inspect source screenshots.
- [ ] Write widget tests for the localized shell, narrow layouts with large text and changing language; run red.
- [ ] Implement shell, theme, localized resources and header.

### Task 2: Composed landing sections and interactions
**Files:** web/lib/features/landing/{landing_page.dart,models/landing_screenshot.dart,services/landing_actions.dart,widgets/*.dart}, web/test/landing_test.dart.
**Interfaces:** `LandingSection` constrains section widths; `PhonePreview` displays bundled screenshots; `ScreenshotGallery` owns its scroll controller. Section scroll keys belong to LandingPage. Shared components consume generated AppLocalizations via BuildContext.
- [ ] Add tests for section navigation, gallery boundaries, email success/failure and translated section labels; run red.
- [ ] Implement hero, facts, pedagogy, game modes, rewards, parent panel, gallery, availability panel and footer.
- [ ] Implement reduced-motion-aware scrolling, localized image labels, focus affordances and failed-action feedback.
- [ ] Run all widget tests; fix problems at their source.

### Task 3: Release validation and delivery
**Files:** web/web/index.html, web/web/manifest.json, web/README.md.
- [ ] Add meaningful title/description and branding, run/build instructions, action configuration and limitations.
- [ ] Run flutter gen-l10n, dart format, flutter analyze, flutter test and flutter build web --release.
- [ ] Inspect desktop and mobile browser renders; fix any visible issues and rerun affected verification.
- [ ] Get an independent review and resolve actionable findings.

## Execution ledger
- Approval: user selected standalone Flutter and approved the design with “Approve and build”. Continue inline.
- Ruling: workspace has no .git repository; work directly in the authorized new `/web` directory. Git worktree/commit scripts cannot apply and are omitted.

- Ruling: user corrected the destination to `math_quest/math_quest/web`; moved the standalone project there without replacing existing bootstrap files. Its own Flutter bootstrap is `web/web/index.html` relative to the mobile project.

- Ruling: latest user instruction supersedes standalone architecture: share existing `lib`, localization, assets and pubspec; use existing `web` host. Feature now lives in `math_quest/lib/features/landing`. Web startup branches via kIsWeb before Hive initialization. Preserved user-edited web manifest/icons.
- Task 1: shared shell and ARB resources implemented; localization generation succeeded.
- Task 2: all sections and interactions implemented; verification in progress.
- Task 3: updated shared host shell and README; build and browser inspection pending.

## Final verification
- Shared ARB localization generation: passed.
- Landing widget tests: 6 passed.
- Full project tests: 445 passed.
- Scoped Flutter analysis (feature, main.dart, landing tests): no issues.
- Release web build: passed; output math_quest/build/web.
- Independent read-only code review: no actionable findings.
- Browser: release preview loads in Chrome with Spanish browser locale; gallery/closing panel/footer screenshot inspected. Further automated viewport inspection limited by browser-control failures.
- Task 1: complete under final shared-project architecture.
- Task 2: complete.
- Task 3: build, checks, documentation and independent review complete; full manual mobile browser inspection remains limited as above.
