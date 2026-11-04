# Asset Manifest & Media Specification

**App:** MathQuest (Ages 4–10)  
**Target Formats:** Vector Graphics (`.svg`), Animations (`.riv` / `.json`), Audio (`.mp3` / `.ogg`)  
**Package Dependencies:** `flutter_svg`, `audioplayers`, `rive` (or `lottie`)

---

## 1. Directory Structure

Place all assets under the root `assets/` directory and declare them in `pubspec.yaml`:

```
assets/
├── audio/
│   ├── bgm/                         # Looping background music
│   └── sfx/                         # Interactive sound effects
├── animations/
│   ├── mascot/                      # Starry mascot states
│   └── rewards/                     # Confetti, stars, celebration
├── icons/
│   ├── navigation/                  # Bottom bar icons
│   ├── operations/                  # +, -, ×, ÷ badges
│   ├── difficulties/                # Easy, Medium, Hard icons
│   └── badges/                      # Trophy room badges
└── images/
    ├── avatars/                     # Child profile avatars
    └── themes/                      # Adventure world thumbnails
```

---

## 2. Audio Manifest (Sound Effects & Music)

Kids learn best with immediate auditory feedback. All audio files must be sampled at **44.1 kHz, 16-bit, compressed MP3/OGG (128 kbps)** to keep total app bundle size under 30 MB.

### 2.1 Interactive Sound Effects (`assets/audio/sfx/`)
| Filename | Key / Event | Duration | Tone & Description |
| :--- | :--- | :--- | :--- |
| `tap_bubble.mp3` | UI Button tap | 0.15s | Soft water bubble pop; tactile feedback |
| `answer_correct.mp3` | Correct answer selected | 0.8s | Bright, joyful bell chime in C-Major |
| `answer_wrong.mp3` | Incorrect answer selected | 0.5s | Gentle cartoon "boing" (no harsh buzzer) |
| `star_pop_1.mp3` | 1st Star appears | 0.3s | Musical pitch note (Do) |
| `star_pop_2.mp3` | 2nd Star appears | 0.3s | Higher pitch note (Mi) |
| `star_pop_3.mp3` | 3rd Star appears | 0.4s | Highest pitch note (Sol) with shimmer |
| `badge_unlocked.mp3`| Trophy earned | 1.2s | Sparkle sweep with trumpet flourish |
| `timer_tick.mp3` | Last 5 seconds of exam | 0.2s | Soft wooden clock tick |
| `quest_victory.mp3` | Screen 4 complete | 2.5s | Uplifting orchestral victory fanfare |
| `whoosh.mp3` | Sheet / modal transitions| 0.25s| Soft airy whoosh |

### 2.2 Background Music (`assets/audio/bgm/`)
| Filename | Placement | Mode | Style |
| :--- | :--- | :--- | :--- |
| `bgm_hub.mp3` | Home & Trophy screens | Loop | Calm, playful acoustic ukulele & marimba (45 dB) |
| `bgm_exam.mp3`| Active game & Exam | Loop | Upbeat, focused tempo with soft bassline (35 dB) |

---

## 3. Vector Icons Manifest (`assets/icons/`)

All icons must be clean, single-layer or multi-color SVGs loaded via `flutter_svg`.

### 3.1 Mathematical Operations (`assets/icons/operations/`)
| Filename | Symbol | Context in UI | Color Accent |
| :--- | :---: | :--- | :--- |
| `op_addition.svg` | `+` | Screen 3 & 6 (Addition Master) | `#0EA5E9` (Sky Blue) |
| `op_subtraction.svg`| `−` | Screen 3 & 6 (Subtraction Superhero) | `#F43F5E` (Rose Coral) |
| `op_multiplication.svg`| `×` | Screen 3 & 6 (Times Master) | `#8B5CF6` (Violet) |
| `op_division.svg` | `÷` | Screen 3 & 6 (Division Explorer) | `#F59E0B` (Amber) |
| `op_mystery.svg` | `?` | Screen 3 (Random Mystery Mix) | Gradient Rainbow |

### 3.2 Trophy Badges (`assets/icons/badges/`)
Matches the badges defined in `GAMIFICATION_SPEC.md`:
| Filename | Badge Title | Associated Visual |
| :--- | :--- | :--- |
| `badge_speed_counter.svg` | Speed Counter | Lightning stopwatch with green wings |
| `badge_century_club.svg` | Century Club | Golden "100" encircled with laurel leaves |
| `badge_lightning_math.svg` | Lightning Math | Cosmic cloud throwing a golden lightning bolt |
| `badge_week_warrior.svg` | Week Warrior | Viking/Knight shield with a 7-day flame |
| `badge_times_master.svg` | Times Master | Multiplication glyph wearing a wizard hat |
| `badge_space_detective.svg`| Space Detective | Magnifying glass observing a constellation |
| `badge_locked_placeholder.svg`| Locked State | Neutral grey padlocked silhouette |

### 3.3 Difficulty & Settings Icons
* `ic_diff_easy.svg`: Cute green seedling sprout (Gentle warm-up)
* `ic_diff_medium.svg`: Glowing lightbulb / playful brain (Elementary challenge)
* `ic_diff_hard.svg`: Golden crown / superhero mask (Math superhero)
* `ic_parent_lock.svg`: Shield with keyhole (Parent Gate protection)

---

## 4. Animations Manifest (Rive / Lottie)

Animations bring the app to life. Vector animations via **Rive (`.riv`)** or **Lottie (`.json`)** preserve 60/120 FPS performance on iPads and phones alike.

### 4.1 Mascot: "Starry" (`assets/animations/mascot/`)
* **File:** `starry_mascot.riv` (Single state-machine asset with multi-triggers):
  * `idle`: Gentle breathing, blinking eyes (Used in Screen 1 & 2).
  * `thinking`: Eyes look upward tapping chin (Shown during active game problem solving).
  * `celebrate`: Jumps with arms up, star sparkles explode (Triggered on correct answer).
  * `encouraging`: Smiles and waves gently (Triggered on mistakes with hints).

### 4.2 UI Reward Animations (`assets/animations/rewards/`)
* `confetti_blast.json`: Full-screen celebratory burst of ribbons and stars on Screen 4.
* `star_earn.riv`: Sequence of 1, 2, or 3 golden stars popping into place with bouncing ease.
* `streak_flame.riv`: Animated flickering fire loop for the streak counter.

---

## 5. Raster Themes & Avatars (`assets/images/`)

Export at `@2x` and `@3x` resolutions for high-density Retina displays.

### 5.1 Profile Avatars (`assets/images/avatars/`)
* `avatar_leo.png`: Boy astronaut with Starry badge (Screen 1 & 7).
* `avatar_mia.png`: Girl explorer with cosmic goggles.
* `avatar_add_new.png`: Dotted outline circle with a plus icon.

### 5.2 World Themes Thumbnails (`assets/images/themes/`)
Matches the Visual Themes carousel in **Screen 7**:
* `theme_galaxy_quest.png`: Deep space with planets and stars.
* `theme_candy_land.png`: Pastel sweet hills with lollipop trees.
* `theme_dino_math.png`: Prehistoric jungle with friendly cartoon brontosaurus.
* `theme_underwater.png`: Coral reef with smiling bubbles and fish.

---

## 6. Type-Safe Dart Asset Registry (`app_assets.dart`)

Save this file in `lib/core/constants/app_assets.dart` to prevent broken string paths:

```dart
class AppAssets {
  // Sound Effects
  static const String sfxTapBubble = 'assets/audio/sfx/tap_bubble.mp3';
  static const String sfxCorrect = 'assets/audio/sfx/answer_correct.mp3';
  static const String sfxWrong = 'assets/audio/sfx/answer_wrong.mp3';
  static const String sfxStar1 = 'assets/audio/sfx/star_pop_1.mp3';
  static const String sfxStar2 = 'assets/audio/sfx/star_pop_2.mp3';
  static const String sfxStar3 = 'assets/audio/sfx/star_pop_3.mp3';
  static const String sfxBadgeUnlock = 'assets/audio/sfx/badge_unlocked.mp3';
  static const String sfxVictory = 'assets/audio/sfx/quest_victory.mp3';
  static const String sfxTick = 'assets/audio/sfx/timer_tick.mp3';

  // Background Music
  static const String bgmHub = 'assets/audio/bgm/bgm_hub.mp3';
  static const String bgmExam = 'assets/audio/bgm/bgm_exam.mp3';

  // Operation Icons
  static const String icAddition = 'assets/icons/operations/op_addition.svg';
  static const String icSubtraction = 'assets/icons/operations/op_subtraction.svg';
  static const String icMultiplication = 'assets/icons/operations/op_multiplication.svg';
  static const String icDivision = 'assets/icons/operations/op_division.svg';
  static const String icMystery = 'assets/icons/operations/op_mystery.svg';

  // Badges
  static const String badgeSpeedCounter = 'assets/icons/badges/badge_speed_counter.svg';
  static const String badgeCenturyClub = 'assets/icons/badges/badge_century_club.svg';
  static const String badgeLightningMath = 'assets/icons/badges/badge_lightning_math.svg';
  static const String badgeWeekWarrior = 'assets/icons/badges/badge_week_warrior.svg';
  static const String badgeTimesMaster = 'assets/icons/badges/badge_times_master.svg';
  static const String badgeSpaceDetective = 'assets/icons/badges/badge_space_detective.svg';
  static const String badgeLocked = 'assets/icons/badges/badge_locked_placeholder.svg';

  // Animations
  static const String animMascot = 'assets/animations/mascot/starry_mascot.riv';
  static const String animConfetti = 'assets/animations/rewards/confetti_blast.json';
  static const String animStars = 'assets/animations/rewards/star_earn.riv';
  static const String animStreakFlame = 'assets/animations/rewards/streak_flame.riv';

  // Avatars
  static const String avatarLeo = 'assets/images/avatars/avatar_leo.png';
  static const String avatarMia = 'assets/images/avatars/avatar_mia.png';

  // Themes
  static const String themeGalaxy = 'assets/images/themes/theme_galaxy_quest.png';
  static const String themeCandy = 'assets/images/themes/theme_candy_land.png';
  static const String themeDino = 'assets/images/themes/theme_dino_math.png';
  static const String themeUnderwater = 'assets/images/themes/theme_underwater.png';
}
```

---

## 7. `pubspec.yaml` Asset Declaration Block

Ensure these asset blocks are registered in your Flutter project's `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/audio/sfx/
    - assets/audio/bgm/
    - assets/icons/operations/
    - assets/icons/badges/
    - assets/icons/difficulties/
    - assets/animations/mascot/
    - assets/animations/rewards/
    - assets/images/avatars/
    - assets/images/themes/
```
