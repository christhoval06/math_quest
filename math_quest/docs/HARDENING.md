# Production Hardening & Release Roadmap

**App:** MathQuest (Ages 4–10)  
**Architecture:** Clean Architecture  
**Scope:** Audio Engine, Offline Persistence, Internationalization (l10n), and Store Deployment

---

## Roadmap Overview

```
┌────────────────────────────────────────────────────────────────────────┐
│                      PRODUCTION ROADMAP PHASES                         │
├─────────────────────┬──────────────────────────┬───────────────────────┤
│ Phase               │ Focus Area               │ Key Deliverables      │
├─────────────────────┼──────────────────────────┼───────────────────────┤
│ 🎵 Milestone 1      │ Audio & SFX Engine       │ SoundService, audio   │
│                     │                          │ cues for kids         │
│ 💾 Milestone 2      │ Local Data Persistence   │ Hive Adapters, disk   │
│                     │                          │ saving, streak engine │
│ 🌐 Milestone 3      │ Full Internationalization│ l10n wiring, Spanish/ │
│                     │                          │ English toggle        │
│ 🚀 Milestone 4      │ Branding & Store Release │ App icons, splash,    │
│                     │                          │ release builds (AAB)  │
└─────────────────────┴──────────────────────────┴───────────────────────┘
```

---

## 🎵 Milestone 1: Audio & Sound Effects Engine

### 1.1 Objective
Bring tactile life to the interface. For ages 4–10, auditory feedback signals success, encourages persistence after errors, and rewards completion without requiring reading skills.

### 1.2 Technical Architecture
* **Package:** `audioplayers`
* **Architecture Pattern:** Inverted Dependency (Domain Port $\rightarrow$ Data Service).
* **Memory Management:** Preload short sound effects into a sound pool cache to eliminate latency when buttons are tapped.

### 1.3 Step-by-Step Implementation Plan
1. **Asset Staging:**
   * Place short `.mp3` files in `assets/audio/sfx/`:
     * `tap_bubble.mp3` (UI taps)
     * `answer_correct.mp3` (Positive bell chime)
     * `answer_wrong.mp3` (Gentle cartoon boing)
     * `star_award.mp3` (Arpeggio notes for 1st, 2nd, and 3rd stars)
     * `victory_fanfare.mp3` (Quest complete)
2. **Domain Port (`lib/core/audio/i_sound_service.dart`):**
   * Define interface methods:
     * `Future<void> playTap()`
     * `Future<void> playCorrect()`
     * `Future<void> playWrong()`
     * `Future<void> playStar(int starIndex)`
     * `Future<void> playVictory()`
     * `void setSoundVolume(double volume)`
     * `void setMusicVolume(double volume)`
3. **Infrastructure Service (`lib/core/audio/sound_service_impl.dart`):**
   * Implement with `AudioPlayer` using `Source` caching (`AssetSource`).
   * Bind to Settings Screen volume sliders (`_sfxVolume`).
4. **Presentation Wiring:**
   * Wire `playTap()` to `OptionCard`.
   * Wire `playCorrect()` and `playWrong()` inside `ActiveGameScreen.checkAnswer()`.
   * Wire `playStar(i)` sequentially in `StarRatingWidget`.
   * Wire `playVictory()` upon opening `QuestCompleteScreen`.

---

## 💾 Milestone 2: Offline Local Persistence (Hive)

### 2.1 Objective
Persist child progress, streak counters, earned Star Coins, XP, unlocked badges, and completed mission history across app restarts without requiring internet access or account creation.

### 2.2 Technical Architecture
* **Package:** `hive` + `hive_flutter`
* **Partitioned Boxes:**
  * `settings_box` (Global app configuration, active profile ID)
  * `profiles_box` (Child profiles: Leo, Mia)
  * `history_box` (Historical session records for the weekly chart)

### 2.3 Step-by-Step Implementation Plan
1. **TypeAdapter Generation:**
   * Annotate models created in `DATA_PERSISTENCE.md`:
     * `UserProfileModel` (`typeId: 0`)
     * `MasteryTrackModel` (`typeId: 1`)
     * `SessionRecordModel` (`typeId: 2`)
   * Run the generator:
     ```bash
     flutter pub run build_runner build --delete-conflicting-outputs
     ```
2. **Bootstrapper Setup (`lib/core/storage/database_bootstrapper.dart`):**
   * Initialize Hive in `main()` before `runApp()`.
   * Register generated adapters.
   * Open boxes and seed default initial profiles (*Leo* and *Mia*) if the database is empty.
3. **Repository Wiring:**
   * Implement `ProfileRepositoryImpl` matching `IProfileRepository`.
   * Connect `StreakEngine` to evaluate midnight boundary crossovers upon launch.
4. **Riverpod State Binding:**
   * Create `ActiveProfileNotifier`:
     * Reads and writes real coins and stars to Hive.
     * Decrements and awards currency when unlocking themes or completing quests.
   * Bind `fl_chart` in Screen 6 to read real data from `history_box`.

---

## 🌐 Milestone 3: Full Internationalization (l10n Wiring)

### 3.1 Objective
Allow families worldwide to play in their native language with an instant language toggle (English $\leftrightarrow$ Spanish $\leftrightarrow$ Portuguese).

### 3.2 Technical Architecture
* **Package:** `flutter_localizations`
* **Translation Files:** `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb`, `lib/l10n/app_pt.arb`
* **State Management:** `LocaleNotifier` (Riverpod) persisting the user's language selection to `settings_box`.

### 3.3 Step-by-Step Implementation Plan
1. **Complete Dictionary Expansion:**
   * Extract all hardcoded strings across all 7 screens into `app_en.arb`:
     * Screen 1: Welcome titles, superpowers subtitle, "Playing as".
     * Screen 2: Game mode names, daily mission descriptions, superpower secret tips.
     * Screen 3: Operation sublabels (*"Apple counters"*, *"Balloon pops"*), difficulty subtitles.
     * Screen 4: Coach Stella quotes, stats labels (*"Round Stats"*, *"Average Speed"*).
     * Screen 5: "Pick your answer", "Skip", "Check Answer!".
     * Screen 6: Mastery ranks (*"Master!"*, *"Superhero"*, *"Rising Star"*).
     * Screen 7: Setting titles, theme names, and worded Parent Gate math challenges.
2. **Synchronize Translations:**
   * Generate matching keys in `app_es.arb` and `app_pt.arb`.
3. **Locale State Provider (`lib/core/localization/locale_provider.dart`):**
   * Manage dynamic locale switching without restarting the app.
4. **Presentation Replacement:**
   * Replace all hardcoded strings with `AppLocalizations.of(context)!.keyName`.
5. **Add Language Selector in Settings (Screen 7):**
   * Add a language dropdown/segmented control to toggle between English, Spanish, and Portuguese.

---

## 🚀 Milestone 4: App Branding, Store Assets & Release Preparation

### 4.1 Objective
Produce release-ready, platform-compliant binaries ready for submission to the Apple App Store and Google Play Store.

### 4.2 Step-by-Step Implementation Plan

#### 1. App Icon Generation
* **Package:** `flutter_launcher_icons`
* Add configuration to `pubspec.yaml`:
  ```yaml
  flutter_launcher_icons:
    android: "launcher_icon"
    ios: true
    image_path: "assets/images/branding/app_icon.png"
    adaptive_icon_background: "#1CB0F6"
    adaptive_icon_foreground: "assets/images/branding/app_icon_foreground.png"
  ```
* Run generation command:
  ```bash
  flutter pub run flutter_launcher_icons
  ```

#### 2. Native Splash Screen Setup
* **Package:** `flutter_native_splash`
* Add configuration to `pubspec.yaml`:
  ```yaml
  flutter_native_splash:
    color: "#F7F9FC"
    image: "assets/images/branding/splash_logo.png"
    android_12:
      image: "assets/images/branding/splash_logo.png"
      icon_background_color: "#F7F9FC"
  ```
* Run generation command:
  ```bash
  flutter pub run flutter_native_splash:create
  ```

#### 3. Android Release Configuration
* Create signing key (`upload-keystore.jks`).
* Configure `android/key.properties` and update `android/app/build.gradle`.
* Add ProGuard rules (`android/app/proguard-rules.pro`) to protect against code shrinking issues:
  ```proguard
  -keep class io.flutter.app.** { *; }
  -keep class com.ryanheise.audioservice.** { *; }
  ```
* Generate Google Play Bundle:
  ```bash
  flutter build appbundle --release
  ```

#### 4. iOS Release Configuration
* Configure `Runner.xcworkspace` in Xcode:
  * Set Bundle Identifier: `com.yourcompany.mathquest`
  * Set Target iOS Version: `iOS 13.0`
  * Set Orientation: Support Portrait and Landscape (for iPad optimization).
* Set Privacy Declarations in `Info.plist`:
  * Ensure zero unnecessary permission strings (no Camera, no Location).
* Generate iOS Archive:
  ```bash
  flutter build ipa --release
  ```

---

## Recommended Execution Order

To build systematically with immediate visual and auditory results:

1. **Start with Milestone 1 (Audio & SFX):** Quick implementation, high delight factor.
2. **Move to Milestone 2 (Hive Persistence):** Ensures coins, streaks, and progress survive app restarts.
3. **Execute Milestone 3 (l10n):** Replaces static copy with localized multi-language text.
4. **Finalize with Milestone 4 (Store Deployment):** Generates release icons, splash screens, and binaries.

---

### Ready to build?
Reply with the milestone number you'd like to start with:
* **"1"** for **Audio & Sound Effects**
* **"2"** for **Hive Local Persistence**
* **"3"** for **Full Internationalization (l10n)**
* **"4"** for **App Icons & Release Builds**
