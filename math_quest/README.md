# MathQuest

A Flutter app for children to practice addition, subtraction, multiplication, and division through short challenges and adventures.

I created MathQuest to help my son Dion study math. We don’t always have a pencil and paper at hand, so I wanted a simple way to turn a spare moment into an opportunity to learn together.

## Features

- **Child profiles:** create a profile after onboarding, choose from 10 avatars, select a grade, and switch between saved children. New installations start without a demo profile or a prefilled name.
- **Math practice:** adventure levels, custom missions, timed challenges, and a local Buddy Challenge mode.
- **Learning progress:** XP, coins, streaks, operation mastery, weekly activity, trophies, and achievement badges with detail bottom sheets.
- **Parent tools:** diagnostic reports, learning goals, daily screen-time limits, and adult verification for protected actions.
- **Personalization:** visual themes, sound and music controls, read-aloud preferences, haptics, and response modes.
- **Settings:** app branding and installed version, the story behind MathQuest, a developer bio, and email support.

## Website

The web target opens the promotional landing page from `lib/features/landing`, using the shared localization and assets. Run `flutter run -d chrome` to preview it, or `flutter build web --release` to generate `build/web/`. Native targets keep the game startup. See [web setup](web/README.md) for details.

## Languages

Choose English, Spanish, or Portuguese in Settings. The Spanish navigation label is **Ajustes**.

Translations live in `lib/l10n/app_en.arb`, `app_es.arb`, and `app_pt.arb`. After editing them, regenerate the localization classes:

```sh
flutter gen-l10n
```

Keep new interface text in the ARB files and preserve user-entered names across languages. See the [localization audit](docs/localization-audit.md) and [simulator walkthrough](docs/localization-walkthrough.md) for earlier checks.

## Run locally

Install Flutter with a bundled Dart SDK that satisfies `^3.13.5`, as specified in `pubspec.yaml`. Development currently uses Flutter 3.47.8 with Dart 3.13.7. For a native build, also set up the target platform’s tools: Xcode and CocoaPods for iOS, or the Android SDK for Android.

From the directory containing `pubspec.yaml`:

```sh
flutter pub get
flutter gen-l10n
flutter run
```

To choose a device:

```sh
flutter devices
flutter run -d <device-id>
```

## Checks and builds

```sh
flutter test
flutter analyze lib test
flutter build ios --simulator --debug --no-codesign
flutter build appbundle --release
```

For a physical iOS device or distribution, configure signing in Xcode. Android release distribution also requires signing configuration.

The latest verification on November 4, 2026 passed all **439 tests** and the iOS simulator build. Analysis reported no errors and 17 existing warnings/information messages. The Android release command above is provided for development; it was not part of that verification.

## Storage and assets

See the [Privacy Policy](docs/privacy-policy.md) for details about local data, children's privacy, support emails, and data removal.

Profiles, progress, and preferences use local Hive storage. Existing saved profiles remain intact when the app starts; startup no longer creates the demo Leo profile.

Nunito fonts, branding images, and sound effects are bundled with the app. The app loads its fonts from assets without runtime downloads. Font sources, checksums, and the SIL Open Font License are documented in the [Nunito assets directory](assets/fonts/nunito/README.md).

Contact / Support opens a draft in the device’s email app. If no email app is available, MathQuest shows the support address with a copy option. The user reviews and sends the message from their email app.

## Project layout

```text
lib/
  core/        Shared theme, navigation, storage, audio, and services
  features/    Gameplay, math engine, missions, profiles, and settings
  l10n/        Translation files and generated localization classes
assets/        Bundled fonts, branding, and sound effects
test/          Unit, widget, localization, and layout regression tests
docs/          Audits, walkthroughs, and implementation notes
```

The app uses Riverpod for state management, Hive for persistence, and Flutter’s localization generation. Feature code separates domain models, data access, and presentation.

## Developer and support

Created by **@christhoval**, a full-stack engineer and Front-End Tech Lead in Panama.

For bug reports, questions, or ideas, email [me@christhoval.dev](mailto:me@christhoval.dev). Include the app version, your device, and the steps to reproduce a problem. You can also start a message from **Settings → Contact / Support**.
