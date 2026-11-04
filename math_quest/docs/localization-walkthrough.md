# Localization walkthrough — 2026-11-04

Manual visual checks used the iPhone 17 Pro simulator on iOS 26.1. English, Spanish, and Portuguese were selected through the app's language control. The app was rebuilt and relaunched to inspect the fixes and confirm settings persistence. Automated layout checks additionally exercise the game-mode descriptions at 320 × 568 pixels.

## Observed flows

- English onboarding, profile creation, welcome, dashboard, and settings: created the simulator test profile Maria Alejandra and checked the name in the welcome and dashboard screens.
- Spanish dashboard, mission setup, practice, results, and trophy statistics: completed ten untimed addition questions. Personalized praise used Maria's name; the trophy screen showed ten answered questions, 100% accuracy, and `+10 hoy`.
- Profile switching: Leo's trophy screen showed `+0 hoy` rather than inheriting Maria's daily count.
- Portuguese settings, dashboard, mission setup, trophies, mastery cards, and parent diagnostic report: reviewed wrapping, operation labels, chart weekdays, dates, and observations. The report identified addition at 98% across 520 questions and recommended division at 62%, matching the saved sample profile.
- Portuguese screen-time limit and adult verification: the rest dialog and verification screen were translated and the normal unlock flow completed successfully.

## Fixes made

- Removed the two-line cap on game-mode descriptions so longer translations remain readable on narrow screens.
- Set dark status-bar content for the app's pale theme headers, including transparent app bars. Confirmed readable time and system icons in the simulator.
- Used the short translated Trophies navigation label in the trophy app bar. The full descriptive page title remains in the page banner.
- Translated the category ribbon in ProfessionalBadgeWidget, which previously displayed raw storage IDs such as SPEED and ACCURACY in every language. Stored category IDs remain unchanged.

Regression tests reproduce description clipping, incorrect status-bar brightness, truncated trophy headers, and untranslated category ribbons before each fix. See `test/core/localization/phone_visual_regression_test.dart` and `stats_screens_localization_test.dart`.

This walkthrough used simulator sample/test profiles. It does not substitute for a physical-device release check or native-speaker review of every catalog entry.

Final verification: all 419 Flutter tests passed. Analysis reported no errors and the same 18 existing warnings/information messages. The iOS simulator debug build succeeded. The final Portuguese trophy header and category ribbons were checked on the rebuilt app; English and the Leo profile were restored after the walkthrough.
