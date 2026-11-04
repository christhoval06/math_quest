# MathQuest: Clean Architecture Implementation Plan

This plan establishes a production-grade, testable, and decoupled architecture for **MathQuest** across phones and tablets (Ages 4–10).

---

## 1. Clean Architecture Layer Overview

```
                      ┌────────────────────────────────────────┐
                      │           Presentation Layer           │
                      │  (Widgets, Screens, State / Riverpod)  │
                      └───────────────────┬────────────────────┘
                                          │ calls
                                          ▼
                      ┌────────────────────────────────────────┐
                      │              Domain Layer              │
                      │   (Entities, Use Cases, Repositories)   │
                      │         * Pure Dart (No Flutter)       │
                      └───────────────────▲────────────────────┘
                                          │ implements
                                          │
                      ┌───────────────────┴────────────────────┐
                      │               Data Layer               │
                      │ (DTOs, Data Sources, Repo Impls, DB)   │
                      └────────────────────────────────────────┘
```

---

## 2. Directory & Package Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_typography.dart
│   ├── errors/
│   │   └── failures.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       ├── responsive_layout.dart
│       └── sound_player.dart
│
├── features/
│   ├── math_engine/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── math_operation.dart
│   │   │   │   ├── difficulty_level.dart
│   │   │   │   ├── math_problem.dart
│   │   │   │   └── exam_session.dart
│   │   │   └── usecases/
│   │   │       ├── generate_problem_usecase.dart
│   │   │       ├── evaluate_exam_usecase.dart
│   │   │       └── get_pedagogical_hint_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── game_session_provider.dart
│   │       │   └── exam_provider.dart
│   │       └── widgets/
│   │           ├── base10_helper_widget.dart
│   │           ├── option_button_widget.dart
│   │           └── problem_card_widget.dart
│   │
│   ├── gameplay/
│   │   └── presentation/
│   │       └── screens/
│   │           ├── practice_screen.dart       # Screen 5 (Practice Mode)
│   │           ├── exam_screen.dart           # Screen 5 (Exam Mode variant)
│   │           └── quest_complete_screen.dart # Screen 4 (Results & Feedback)
│   │
│   ├── mission_setup/
│   │   └── presentation/
│   │       └── screens/
│   │           └── custom_mission_screen.dart # Screen 3 (Mission config)
│   │
│   ├── profile_and_stats/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── user_profile.dart
│   │   │   │   ├── user_stats.dart
│   │   │   │   └── badge.dart
│   │   │   ├── repositories/
│   │   │   │   └── i_profile_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_current_profile_usecase.dart
│   │   │       ├── update_streak_usecase.dart
│   │   │       └── record_exam_result_usecase.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── local_profile_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── user_profile_model.dart
│   │   │   │   └── user_stats_model.dart
│   │   │   └── repositories/
│   │   │       └── profile_repository_impl.dart
│   │   └── presentation/
│   │       └── screens/
│   │           ├── home_dashboard_screen.dart # Screen 2 (Play Hub)
│   │           ├── trophy_room_screen.dart    # Screen 6 (Stats & Badges)
│   │           └── welcome_splash_screen.dart # Screen 1 (Entry screen)
│   │
│   └── settings_and_parent_gate/
│       ├── domain/
│       │   └── usecases/
│       │       └── verify_parent_pin_usecase.dart
│       └── presentation/
│           ├── screens/
│           │   └── settings_screen.dart       # Screen 7 (Settings & Gate)
│           └── widgets/
│               └── parent_gate_dialog.dart
│
└── main.dart
```

---

## 3. Step-by-Step Implementation Roadmap

### Phase 1: Core Foundation & Domain Math Engine (Pure Dart)
* **Goal**: Build and test the mathematical rules with zero UI dependencies.
* **Tasks**:
  1. Define domain entities:
     * `MathOperation` (`addition`, `subtraction`, `multiplication`, `division`).
     * `DifficultyLevel` (`easy` [4–6], `medium` [7–8], `hard` [9–10]).
     * `MathProblem` and `ExamSession`.
  2. Implement `GenerateProblemUseCase`:
     * Enforce division without remainders.
     * Enforce subtraction without negative answers.
     * Generate 3 reasonable distractors for multiple-choice options.
  3. Implement `EvaluateExamUseCase`:
     * Calculate accuracy %, speed/time per item, stars earned (1–3), and identify mistakes.
  4. Write comprehensive Unit Tests covering all 12 combinations ($4 \text{ operations} \times 3 \text{ difficulties}$).

---

### Phase 2: Data Layer & Offline Persistence
* **Goal**: Store profiles, streaks, high scores, and exam logs locally.
* **Tasks**:
  1. Select local storage solution: **Hive** or **Isar** (zero native crashes, fast initialization on cold boot).
  2. Create Data Models (`UserProfileModel`, `UserStatsModel`) with serialization/deserialization.
  3. Implement `IProfileRepository` in `ProfileRepositoryImpl`.
  4. Create mock/seed data for multi-profile support (`Leo - Grade 2`, `Mia - Kindergarten`).

---

### Phase 3: Application State Layer (Riverpod)
* **Goal**: Create clean state controllers to isolate game logic from UI rendering.
* **Tasks**:
  1. **`GameSessionNotifier` (Practice Mode)**:
     * Manages current question, immediate answer verification, Base-10 block states, audio triggers.
  2. **`ExamNotifier` (Exam Mode)**:
     * Manages question queue, silent progression (no immediate alerts), overall countdown timer, and exam completion transitions.
  3. **`ProfileNotifier`**:
     * Tracks selected active child, streak progression, and star/XP balances.

---

### Phase 4: Reusable Design System & Tablet Layout
* **Goal**: Build standard widgets matching your mockups with phone/tablet compatibility.
* **Tasks**:
  1. Implement `ResponsiveContainer`:
     * Centers content with a `max-width: 520px` on iPads/tablets; fills width on phones.
  2. Build shared visual components:
     * `Base10CountingHelper`: Renders tens rods and ones dots dynamically.
     * `OptionChoiceButton`: Rounded card with selection, success, and error states.
     * `StarScoreDisplay`: Animated star rating bar.
     * `StreakBanner`: Flame icon + count indicator.

---

### Phase 5: Screen Construction (Matching UI Proposal)
* **Goal**: Assemble the views using state providers and responsive widgets.
* **Sequence**:
  1. **Gameplay & Exam Screens (Screens 4 & 5)**:
     * Active problem solving, options grid, and "Quest Complete" summary with mistake review.
  2. **Mission Configuration (Screen 3)**:
     * Operation chips selection, difficulty selector, timer choices, and toggles for aids.
  3. **Main Dashboard & Splash (Screens 1 & 2)**:
     * Daily mission card, game mode launcher, progress bar, streak count.
  4. **Trophy & Stats Room (Screen 6)**:
     * Integration of `fl_chart` for weekly practice bars, mastery progress tracks.
  5. **Settings & Parent Gate (Screen 7)**:
     * Audio/haptic toggles, profile switcher, and COPPA-compliant parent challenge gate.

---

### Phase 6: Sound Effects & Delight
* **Goal**: Add audio and motion feedback without cluttering business logic.
* **Tasks**:
  1. Wire `audioplayers` behind an `ISoundService` interface:
     * Play bubbly pop sound on button tap.
     * Play positive chime on correct answer / victory fanfare on quest completion.
  2. Integrate `confetti` overlay on the Quest Complete screen.
  3. Add entry and bounce animations to the star mascot.

---

## 4. Immediate Next Step

To begin **Phase 1 (Domain Layer)**, should we generate:
1. The **Domain Entities & Generator UseCase** (`math_problem.dart`, `generate_problem_usecase.dart`) along with their **Unit Tests**?
2. Or the **Folder/Project Scaffolding** script with all required `pubspec.yaml` dependencies?
