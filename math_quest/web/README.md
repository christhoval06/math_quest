# MathQuest web landing

The web target uses the existing Flutter project. There is no separate Flutter project inside `web/`.

## Run and build

From the app root:

```sh
cd /Users/alfamedic/Developer/apps/math_quest/math_quest
flutter pub get
flutter gen-l10n
flutter run -d chrome
flutter build web --release
```

Web startup selects `LandingApp` before initializing gameplay storage. Android/iOS/desktop retain the original `MathQuestApp` startup. The marketing site does not initialize Hive or mobile runtime settings.

`web/index.html` is the host shell. Flutter outputs the deployable website to `build/web/`. For hosting at a subpath, build with `--base-href /your-path/`.

## Shared structure

- `lib/features/landing/landing_app.dart` owns the website theme and selected language.
- `lib/features/landing/landing_page.dart` composes the page and section navigation.
- `lib/features/landing/widgets/` contains focused visual sections and shared layout components.
- `lib/features/landing/models/` maps the app screenshots to localized captions.
- `lib/features/landing/services/landing_actions.dart` defines the injected URL launcher and the App Store/support destinations.
- `lib/features/landing/theme/` defines the supplied design's tokens.
- `lib/l10n/app_{en,es,pt}.arb` contains shared localization, with `landing` prefixes for website strings.
- `assets/screens/` and `assets/images/branding/` supply the original app screenshots and icon.
- `assets/fonts/plus_jakarta_sans/` bundles the website font and SIL Open Font License.

The browser locale determines the initial language; the header selector changes it for the current session. Screenshots retain the app language shown in the original image.

## Download and support links

Header, hero and closing download buttons open [MathQuest on the App Store](https://apps.apple.com/us/app/mathquest-kids-math-games/id6830852181). The footer contact/support action composes an email to `me@christhoval.dev` with localized subject/body. Failed launches show localized feedback; email feedback includes the support address.

Destinations live in `LandingLinks`; the injected `LandingActions` interface opens them through `UrlLandingActions`.

## Verification

```sh
flutter analyze lib/features/landing lib/main.dart
flutter test test/features/landing
flutter test
flutter build web --release
```

Flutter renders the page in its web engine. The HTML shell provides baseline metadata; content indexing is more limited than server-rendered HTML. Add canonical and social-preview URLs when the final public domain is known.

## Verified in this change

Shared localization generation, all 445 project tests (including six landing tests) for the initial landing implementation, scoped static analysis, and the release web build passed. The landing tests exercise 360px layouts with 1.5x text in all three languages. The release preview loaded in Chrome; browser-control failures limited further manual viewport inspection.

App Store/support update: seven landing widget tests pass and scoped analysis is clean. The full suite passes with 446 tests.
