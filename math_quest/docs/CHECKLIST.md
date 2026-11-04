# Features, Checklist & Internationalization (l10n) Specification

**App:** MathQuest (Ages 4–10)  
**Architecture:** Clean Architecture (Domain, Data, Presentation)  
**Target Languages (Initial Tier):** English (`en`), Spanish (`es`), Portuguese (`pt`), French (`fr`)

---

## 1. Complete Feature Matrix

### 1.1 Core Mathematical Engine
* [x] **4 Operations:** Addition ($+$), Subtraction ($-$), Multiplication ($\times$), Division ($\div$).
* [x] **3 Adaptive Difficulty Levels:**
  * **🟢 Easy (Ages 4–6 / Pre-K & K):** Single digits ($1–9$), non-negative results, sums $\le 10$, clean division with dividends $\le 10$.
  * **🟡 Medium (Ages 7–8 / Grades 1–2):** 2-digit arithmetic ($10–99$), core times tables ($2–9$), clean division $\le 50$.
  * **🔴 Hard (Ages 9–10 / Grades 3–5):** 2-to-3-digit arithmetic ($50–999$) with regrouping/borrowing, extended tables up to $12 \times 12$, division $\le 144$.
* [x] **Pedagogical Base-10 Visualizer:** Decomposes active problems into graphical tens-rods and ones-dots dynamically.
* [x] **Smart Distractor Algorithm:** Generates 3 believable wrong answers per problem (Off-by-1, Tens-slip $\pm 10$, Inverted operations) avoiding duplicates or negatives.

### 1.2 Game Modes
* [x] **Practice Arena (Screen 5):** Immediate feedback, green/red feedback cards, Base-10 counting aids, Mascot hints ("Secret Tricks"), unlimited retries.
* [x] **Exam Challenge Mode:** Timed (e.g., 2 minutes / 10 questions), visual counting aids disabled, silent progression without immediate answers, complete diagnostic report at the end.
* [x] **Mistake Review Engine (Screen 4):** Automatically captures missed questions in exam mode for guided retry with hints.

### 1.3 Gamification & Habits
* [x] **Starry Mascot:** Interactive mascot providing contextual praise, encouragement, and thinking states.
* [x] **Currencies:** Math XP (Lifetime rank progression) and Star Coins (Unlockable cosmetic themes).
* [x] **Habit Streaks:** Flame counter with calendar-aware reset and 1-day weekly automatic **Streak Shield**.
* [x] **Trophy Room & Badges (Screen 6):** 24 collectible badges (e.g., *Speed Counter*, *Century Club*, *Lightning Math*).
* [x] **Mastery Tracks:** 5 progression tiers per operation (*Novice*, *Adventurer*, *Rising Star*, *Superhero*, *Master!*).
* [x] **Visual Themes:** 4 unlockable environments (*Galaxy Quest*, *Candy Land*, *Dino Math*, *Underwater Coral Reef*).

### 1.4 Parent Zone & Kids Safety
* [x] **Multi-Profile Switching:** Manage up to 3 individual child profiles on one device (e.g., *Leo - Grade 2*, *Mia - Kindergarten*).
* [x] **Parental Gate Interceptor:** Anti-brute-force multiplication challenge spelled out in words to guard Settings, reset tools, and outbound links.
* [x] **Daily Screen-Time Limiter:** Configurable timers ($15\text{m}$, $30\text{m}$, $45\text{m}$, $\infty$) that pause the game.
* [x] **COPPA/GDPR-K Compliance:** 100% offline-ready, 0 ads, 0 analytics tracking, encrypted local storage.

---

## 2. Internationalization (l10n / i18n) Architecture

The app uses Flutter’s official `flutter_localizations` package driven by `.arb` (Application Resource Bundle) files.

### 2.1 Configuration File (`l10n.yaml`)
Create this in the root directory:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
```

### 2.2 Adding Dependencies (`pubspec.yaml`)
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
```

---

### 2.3 English Source File (`lib/l10n/app_en.arb`)

```json
{
  "@@locale": "en",
  "appTitle": "MathQuest",
  "@appTitle": { "description": "Main application title" },

  "tapToStart": "Tap to Start Adventure!",
  "playingAs": "Playing as: {name} ({grade})",
  "@playingAs": {
    "placeholders": {
      "name": { "type": "String" },
      "grade": { "type": "String" }
    }
  },

  "dayStreak": "{count} Day Streak!",
  "@dayStreak": {
    "placeholders": {
      "count": { "type": "int" }
    }
  },

  "opAddition": "Addition",
  "opSubtraction": "Subtraction",
  "opMultiplication": "Multiplication",
  "opDivision": "Division",

  "diffEasy": "Easy",
  "diffEasySub": "Gentle warm-up for beginners",
  "diffMedium": "Medium",
  "diffMediumSub": "Elementary challenge & brain workout",
  "diffHard": "Hard",
  "diffHardSub": "Math superhero level!",

  "checkAnswer": "Check Answer!",
  "correctTitle": "Awesome Job! 🌟",
  "wrongTitle": "Not quite right!",
  "continueButton": "Continue",

  "questComplete": "Quest Complete!",
  "accuracy": "Accuracy",
  "roundStats": "Round Stats",
  "playAnotherRound": "Play Another Round",
  "reviewMistakes": "Review {count, plural, =1{1 Mistake} other{{count} Mistakes}}",
  "@reviewMistakes": {
    "placeholders": {
      "count": { "type": "int" }
    }
  },

  "parentGateTitle": "Grown-Ups Zone",
  "parentGatePrompt": "Please ask a grown-up: What is {word1} multiplied by {word2}?",
  "@parentGatePrompt": {
    "placeholders": {
      "word1": { "type": "String" },
      "word2": { "type": "String" }
    }
  }
}
```

---

### 2.4 Spanish Translation (`lib/l10n/app_es.arb`)

```json
{
  "@@locale": "es",
  "appTitle": "MathQuest",
  "tapToStart": "¡Toca para Iniciar la Aventura!",
  "playingAs": "Jugando como: {name} ({grade})",
  "dayStreak": "¡Racha de {count} Días!",

  "opAddition": "Suma",
  "opSubtraction": "Resta",
  "opMultiplication": "Multiplicación",
  "opDivision": "División",

  "diffEasy": "Fácil",
  "diffEasySub": "Calentamiento suave para principiantes",
  "diffMedium": "Medio",
  "diffMediumSub": "Desafío escolar y ejercicio mental",
  "diffHard": "Difícil",
  "diffHardSub": "¡Nivel superhéroe de las matemáticas!",

  "checkAnswer": "¡Comprobar!",
  "correctTitle": "¡Trabajo Increíble! 🌟",
  "wrongTitle": "¡Casi, pero no!",
  "continueButton": "Continuar",

  "questComplete": "¡Misión Cumplida!",
  "accuracy": "Precisión",
  "roundStats": "Estadísticas",
  "playAnotherRound": "Jugar Otra Ronda",
  "reviewMistakes": "Revisar {count, plural, =1{1 Error} other{{count} Errores}}",

  "parentGateTitle": "Zona de Adultos",
  "parentGatePrompt": "Para adultos: ¿Cuánto es {word1} multiplicado por {word2}?"
}
```

---

### 2.5 Portuguese Translation (`lib/l10n/app_pt.arb`)

```json
{
  "@@locale": "pt",
  "appTitle": "MathQuest",
  "tapToStart": "Toque para Começar!",
  "playingAs": "Jogando como: {name} ({grade})",
  "dayStreak": "Sequência de {count} Dias!",

  "opAddition": "Adição",
  "opSubtraction": "Subtração",
  "opMultiplication": "Multiplicação",
  "opDivision": "Divisão",

  "diffEasy": "Fácil",
  "diffEasySub": "Aquecimento suave para iniciantes",
  "diffMedium": "Médio",
  "diffMediumSub": "Desafio escolar e treino mental",
  "diffHard": "Difícil",
  "diffHardSub": "Nível super-herói da matemática!",

  "checkAnswer": "Verificar Resposta!",
  "correctTitle": "Trabalho Incrível! 🌟",
  "wrongTitle": "Quase lá!",
  "continueButton": "Continuar",

  "questComplete": "Missão Concluída!",
  "accuracy": "Precisão",
  "roundStats": "Estatísticas da Rodada",
  "playAnotherRound": "Jogar Outra Rodada",
  "reviewMistakes": "Revisar {count, plural, =1{1 Erro} other{{count} Erros}}",

  "parentGateTitle": "Área dos Pais",
  "parentGatePrompt": "Exclusivo para adultos: Quanto é {word1} multiplicado por {word2}?"
}
```

---

## 3. Master Engineering Checklist

### Phase 1: Foundation & Domain Layer
- [ ] Initialize Flutter project targeting min SDK iOS 13 / Android API 24.
- [ ] Configure `l10n.yaml` and verify auto-generated `AppLocalizations`.
- [ ] Create Domain Entities: `MathProblem`, `MathOperation`, `DifficultyLevel`, `UserProfile`, `ExamReport`.
- [ ] Implement `GenerateProblemUseCase` (enforcing zero-remainders and non-negative logic).
- [ ] Implement `GenerateDistractorsUseCase` (sanitized $\pm 1$, $\pm 10$ options).
- [ ] Implement `DecomposeBase10UseCase` (extracts hundreds, tens, and ones).
- [ ] Write 100% unit test coverage for math problem generation across all 12 operational permutations.

### Phase 2: Data Layer & Persistence
- [ ] Integrate Hive & Hive Flutter (`hive_flutter`, `hive_generator`, `build_runner`).
- [ ] Define and generate Hive Adapters: `UserProfileModel`, `MasteryTrackModel`, `SessionRecordModel`.
- [ ] Implement `IProfileRepository` and `ProfileRepositoryImpl`.
- [ ] Build `StreakEngine` with midnight-safe calendar calculation and streak shield protection.
- [ ] Build initial database bootstrapper with seed data (Leo & Mia profiles).

### Phase 3: Core Game State & Logic
- [ ] Implement `PracticeSessionNotifier` (manages active problem, immediate feedback, Base-10 toggle).
- [ ] Implement `ExamSessionNotifier` (manages question queue, silent submission, countdown timer).
- [ ] Implement `GamificationEngine` (XP accumulation, Star Coins calculation, badge unlocks).
- [ ] Create Audio Service with `audioplayers` behind `ISoundService` interface.

### Phase 4: UI & Design System (Matching Mockups)
- [ ] Implement `AppTheme` with custom color palette, typography (`Nunito`), and shadows.
- [ ] Build `ResponsiveContainer` (centered layout with `max-width: 520px` for iPad/tablets).
- [ ] Build reusable widgets:
  - [ ] `Base10CountingHelper` (tens rods & ones dots).
  - [ ] `OptionChoiceCard` (2x2 animated grid buttons).
  - [ ] `ParentGateDialog` (worded math prompt).
  - [ ] `StreakFlameBadge` (animated flame header).
- [ ] Assemble **Screen 1**: Welcome / Splash Screen with profile badge.
- [ ] Assemble **Screen 2**: Home Hub (Daily Mission, Game Modes grid).
- [ ] Assemble **Screen 3**: Custom Mission Setup (Operation chips, difficulty selector, timer pills).
- [ ] Assemble **Screen 4**: Quest Complete Screen (Star rating, stats, mistake review sheet).
- [ ] Assemble **Screen 5**: Active Gameplay Screen (Problem card, Base-10 blocks, answer choices).
- [ ] Assemble **Screen 6**: Trophy Room & Stats (Weekly practice bar chart via `fl_chart`, mastery tracks).
- [ ] Assemble **Screen 7**: Settings & Parent Zone (Daily screen limits, profile manager, theme switcher).

### Phase 5: Internationalization & Accessibility
- [ ] Replace all hardcoded strings with `AppLocalizations.of(context)`.
- [ ] Implement number-to-words localization service for the Parent Gate (`one` $\to$ `uno` $\to$ `um`).
- [ ] Ensure high-contrast ratio ($\ge 4.5:1$) for all text on light backgrounds.
- [ ] Configure dynamic layout padding so expanded translated words (e.g., German/Spanish) never overflow buttons.

### Phase 6: Compliance & Store Publishing
- [ ] Perform Apple Guideline 1.3 audit (zero ads, zero tracking SDKs, parental gate on all external triggers).
- [ ] Complete Google Play Families Policy declaration.
- [ ] Test on physical iPad / Android Tablet for layout responsiveness.
- [ ] Build release binaries (`.ipa` and `.aab`) with ProGuard/R8 obfuscation.
