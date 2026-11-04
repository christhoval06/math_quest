# Localization audit — 2026-11-03

The Flutter runtime screens, widgets, and built-in display catalogs were reviewed for English-only copy. Supported languages are English (`en`), Spanish (`es`), and Portuguese (`pt`).

Completed coverage includes welcome and onboarding, profiles, navigation, settings, mission setup, gameplay and results, adventure names, badge catalogs, trophies, mastery ranks, weekly chart labels, diagnostic reports, adult verification, and screen-time dialogs.

Display messages live in `lib/l10n/app_*.arb`. Generated localization classes are regenerated with `flutter gen-l10n`. Diagnostic report dates use locale-aware formatting. Badge categories, grade choices, world names, theme identifiers, and weekday lookup keys retain their existing stored values; their visible labels are translated when rendered.

The remaining literal strings in screen/widget code are names and branding, language autonyms, numeric/math notation, internal keys, or stored identifiers. English catalog/model fields remain as compatibility copy for custom or previously supplied presentation data. User names and unknown custom content are preserved.

Phone-width regression checks cover populated and empty statistics, every mastery rank, badge filtering and details, diagnostic dates, parent verification, and screen-time unlock callbacks in the supported languages. Existing validation rules and protected-action authorization remain unchanged.

Verification: localization generation succeeded; the full Flutter suite passed all 420 tests. Analysis reported no errors and 18 existing warnings/information messages.

## Profile data and coach observations

The trophy summary now displays the actual count recorded for the active child on the current local calendar date. Counts are persisted separately per profile and reset when the date changes. An open Trophy Room refreshes at local midnight and when the app resumes. Tracking starts with this update: legacy weekday totals cannot reliably identify a child or calendar date and are not used to backfill daily counts. The existing weekly chart storage remains unchanged.

The unsupported “Top 5% Learner” claim has been replaced with a description of the accuracy measure across practiced operations. Profiles without answered questions show `--%`.

Coach observations use measured operation results: the strongest practiced operation with at least 70% accuracy, and the weakest practiced operation below 90% as the recommended focus. If practiced operations are mastered, an unassessed operation is suggested; otherwise the coach recommends maintaining practice. Empty reports request a practice session without claiming specific skills.

The explorer banner and high-score coach praise use the active child's name. Names are preserved in every language; missing names use a localized Explorer label.

Regression coverage includes profile switching, local-date rollover, overnight refresh, app resume, zero-length sessions, translated personal names, measured coach observations, and empty states. The full suite passes 420 tests; analysis has no errors and the same 18 existing warnings/information messages.

The [2026-11-04 simulator walkthrough](localization-walkthrough.md) records manual checks and the follow-up fixes for narrow-screen descriptions, status-bar contrast, trophy headers, and badge category ribbons.

Badge layout follow-up: the recent-badges heading and action span the section, titles wrap across each card, and both badge views share a scrollable detail bottom sheet. Regression coverage includes English, Spanish, Portuguese, narrow screens, long descriptions, swipe dismissal, and enlarged text. The full suite passes 428 tests; analysis reports no errors and the same 18 existing warnings/information messages.

Nunito is now bundled locally in weights 400–900 with its SIL Open Font License. Theme and typography styles use the local Nunito family; the google_fonts dependency and runtime font downloads have been removed. The asset-loading regression verifies every bundled font file. See assets/fonts/nunito/README.md for sources and SHA-256 checksums.
