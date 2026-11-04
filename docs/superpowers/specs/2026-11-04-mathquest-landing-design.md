# MathQuest promotional landing page

## Intent and final architecture

Promote MathQuest to parents and educators using the supplied DESIGN.md, HTML reference and screenshots. The user’s final instruction is to share the existing Flutter app `lib` and use `/Users/alfamedic/Developer/apps/math_quest/math_quest/web` as the web host.

The feature lives in `lib/features/landing`. The existing `main.dart` selects `LandingApp` on web before Hive/gameplay initialization. Native targets retain the original startup. The standard `flutter run -d chrome` and `flutter build web --release` commands use the landing page.

## Approaches considered

An app route, a separate HTML site, and a standalone Flutter site were considered. The user initially selected a standalone Flutter site, then clarified that lib should be shared and the existing web directory should be the base. The implementation follows that final correction. No nested Flutter project remains in web.

## Structure and SOLID responsibilities

- LandingApp owns website locale and theme.
- LandingPage composes sections and owns section navigation/action feedback.
- Focused section widgets share layout and visual primitives.
- Screenshot metadata maps original image assets to localized captions.
- LandingActions abstracts external actions; EmailLandingActions implements the approved availability flow.
- Theme tokens live inside the feature; strings use landing-prefixed keys in shared ARB resources.

## Presentation

Soft lavender canvas, dark navy headings, orange tactile buttons, sky blue and mint accents, rounded white panels, Plus Jakarta Sans bundled with its SIL Open Font License, and a centered 1080px content area. Narrow layouts stack sections and preserve text scaling.

Sections include navigation/language selection, a two-phone hero, operation statistics, visual Base-10 teaching, four game-mode cards, rewards/progress, parent reports/controls, a screenshot gallery, an availability panel and footer. Navigation scrolls to sections; gallery arrows respect boundaries and reduced-motion preferences.

Use original screenshots from assets/screens and the original icon from assets/images/branding. Screenshots retain their original proportions and in-image language when website copy is translated.

## Localization

All 91 landing messages are present in English, Spanish and Portuguese ARB files. Generated AppLocalizations serves both app and website. The browser selects the initial locale; the header changes it for the current session. Labels, image descriptions and error feedback are localized.

## Actions and content

The user supplied the App Store listing: https://apps.apple.com/us/app/mathquest-kids-math-games/id6830852181. Header, hero and closing download controls open that URL directly. Contact/support composes a localized email to me@christhoval.dev. Download and email failures receive distinct localized feedback. LandingLinks owns the destinations; LandingActions abstracts URL launching.

Use supported app features; do not add unverified ratings, download counts, testimonials, certifications, or QR codes.

## Validation

Generated shared localizations successfully. All seven landing tests pass, covering language switching, three narrow layouts at 1.5x text scaling, App Store destinations and localized support-email failure feedback, and gallery boundaries. All 446 project tests pass. Scoped analysis of the feature, main.dart and landing tests reports no issues. Release web build succeeds. A Chrome screenshot confirms the Spanish gallery, closing panel and footer render; browser automation failures limited further manual viewport inspection.

## Boundaries

No deployment, domain setup, backend, analytics, accounts, or app-store publishing. Native gameplay remains available through its existing startup. Web README documents run/build commands and the availability action.
