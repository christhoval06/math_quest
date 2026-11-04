# Engineering Plan: Math & Game Engine

**Target Audience:** Ages 4–10 (Preschool to 5th Grade)  
**Architecture:** Clean Architecture (Domain-Driven, Decoupled, Pure Dart Core)  
**Scope:** 4 Operations ($+$, $-$, $\times$, $\div$), 3 Difficulties, Dual Modes (Practice vs. Exam)

---

## 1. System Architecture Overview

The Math & Game Engine is strictly separated into **Domain Logic** (pure algorithmic Dart, zero Flutter dependencies), **Data Contracts** (persistence interfaces), and **Application State** (state machines for Practice and Exam flows).

```
┌────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER                            │
│  ┌──────────────────────────────┐    ┌──────────────────────────────┐  │
│  │    PracticeSessionNotifier   │    │      ExamSessionNotifier     │  │
│  └──────────────┬───────────────┘    └──────────────┬───────────────┘  │
└─────────────────┼───────────────────────────────────┼──────────────────┘
                  │ calls                             │ calls
┌─────────────────▼───────────────────────────────────▼──────────────────┐
│                         DOMAIN LAYER (Pure Dart)                       │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ Use Cases:                                                       │  │
│  │  • GenerateProblemUseCase        • EvaluateAnswerUseCase         │  │
│  │  • GenerateDistractorsUseCase    • CalculateExamReportUseCase    │  │
│  │  • DecomposeBase10UseCase                                        │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ Entities & Value Objects:                                        │  │
│  │  • MathProblem     • MathOperation     • DifficultyLevel         │  │
│  │  • Base10Model     • ExamSession       • ExamReport              │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │ Ports / Contracts:                                               │  │
│  │  • ISoundService   • IHapticService    • ISessionRepository      │  │
│  └──────────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Directory Structure

```
lib/features/math_engine/
├── domain/
│   ├── entities/
│   │   ├── math_operation.dart          # Enum: +, -, ×, ÷
│   │   ├── difficulty_level.dart        # Enum: easy, medium, hard
│   │   ├── math_problem.dart            # Value object for a single challenge
│   │   ├── base10_decomposition.dart    # Hundreds, tens, and ones data
│   │   ├── answer_submission.dart       # User input, timestamp, correctness
│   │   └── exam_report.dart             # Accuracy, speed, stars, mistakes
│   ├── ports/
│   │   ├── i_sound_service.dart         # Audio feedback contract
│   │   ├── i_haptic_service.dart        # Vibration feedback contract
│   │   └── i_session_repository.dart    # History saving contract
│   └── usecases/
│       ├── generate_problem_usecase.dart
│       ├── generate_distractors_usecase.dart
│       ├── decompose_base10_usecase.dart
│       ├── evaluate_answer_usecase.dart
│       └── calculate_exam_report_usecase.dart
│
└── presentation/
    ├── state/
    │   ├── practice_state.dart          # State model for Practice Mode
    │   ├── practice_notifier.dart       # Controller for Practice Mode
    │   ├── exam_state.dart              # State model for Exam Mode
    │   └── exam_notifier.dart           # Controller for Exam Mode (Timer/Queue)
    └── contracts/
        └── math_ui_event.dart           # UI events: onAnswerPicked, onTimeUp
```

---

## 3. Mathematical Specifications Matrix

The problem generator adheres to strict pedagogical rules to prevent negative outputs, non-integer division, or cognitive overload per age category.

| Operation | 🟢 Easy (Ages 4–6) | 🟡 Medium (Ages 7–8) | 🔴 Hard (Ages 9–10) |
| :--- | :--- | :--- | :--- |
| **Addition ($+$)** | $A, B \in [1, 5]$<br>$\text{Sum} \le 10$ | $A, B \in [10, 49]$<br>$\text{Sum} \le 99$<br>*(Introduces carry)* | $A, B \in [50, 499]$<br>$\text{Sum} \le 999$<br>*(Multi-digit carry)* |
| **Subtraction ($-$)** | $A \in [2, 9]$, $B < A$<br>$\text{Result} \ge 1$<br>*(No negatives)* | $A \in [20, 89]$, $B < A$<br>$\text{Result} \ge 0$<br>*(Single borrowing)* | $A \in [100, 999]$, $B < A$<br>$\text{Result} \ge 0$<br>*(Double borrowing)* |
| **Multiplication ($\times$)** | $A \in [1, 5]$, $B \in [1, 3]$<br>$\text{Product} \le 15$<br>*(Repeated addition)* | $A, B \in [2, 9]$<br>$\text{Product} \le 81$<br>*(Core times tables)* | $A \in [9, 12], B \in [9, 12]$<br>OR $A \in [11, 25], B \in [2, 7]$<br>*(Extended tables)* |
| **Division ($\div$)** | $\text{Quotient} \in [1, 4]$<br>$B \in \{2, 3\}$<br>$A = B \times \text{Quotient}$<br>*(No remainder)* | $\text{Quotient} \in [2, 9]$<br>$B \in [2, 8]$<br>$A = B \times \text{Quotient}$<br>*(No remainder, $A \le 50$)* | $\text{Quotient} \in [3, 12]$<br>$B \in [3, 10]$<br>$A = B \times \text{Quotient}$<br>*(No remainder, $A \le 144$)* |

---

## 4. Algorithmic Modules

### Module 4.1: Problem Generator Algorithm (`GenerateProblemUseCase`)
* **Inverse Generation for Division:** 
  $$\text{Divisor } (B) \text{ and Answer } (Q) \text{ are randomized first} \implies \text{Dividend } (A) = B \times Q$$
  Guarantees whole integers ($A \pmod B = 0$) and eliminates divide-by-zero errors.
* **Non-Negative Guard for Subtraction:**
  Ensure $A \ge B$ by swap logic:
  $$\text{if } A < B \implies \text{swap}(A, B)$$

### Module 4.2: Distractor Algorithm (`GenerateDistractorsUseCase`)
Kids guess answers using predictable arithmetic patterns. The engine builds 3 smart distractors rather than pure random numbers:
1. **Off-by-One:** $\text{Answer} \pm 1$ (tests precision).
2. **Tens/Regrouping Slip:** $\text{Answer} \pm 10$ (tests borrowing/carrying).
3. **Operational Confusion:** e.g., if problem is $4 \times 3$, generate $4 + 3 = 7$ as a distractor.
4. **Sanitization:** Distractors must be $> 0$, non-duplicate, and strictly distinct from the real answer.

### Module 4.3: Visual Base-10 Decomposition (`DecomposeBase10UseCase`)
For pedagogical visualization (Screen 5 in UI):
* Any number $N \in [1, 999]$ is decomposed into:
  $$\text{Hundreds} = \lfloor N / 100 \rfloor, \quad \text{Tens} = \lfloor (N \pmod{100}) / 10 \rfloor, \quad \text{Ones} = N \pmod{10}$$
* The presentation layer uses this entity to draw rods (tens) and dots (ones).

---

## 5. Dual Game Modes Architecture

```
                          ┌─────────────────────┐
                          │   Session Starter   │
                          └──────────┬──────────┘
                                     │
                 ┌───────────────────┴───────────────────┐
                 ▼                                       ▼
      ┌──────────────────────┐               ┌──────────────────────┐
      │    PRACTICE MODE     │               │      EXAM MODE       │
      ├──────────────────────┤               ├──────────────────────┤
      │ • Single Operation   │               │ • Mixed Operations   │
      │ • Base-10 Aids: ON   │               │ • Base-10 Aids: OFF  │
      │ • Immediate Feedback │               │ • Silent Progression │
      │ • Audio on every tap │               │ • Global Timer (120s)│
      │ • Infinite retries   │               │ • Single Submission  │
      └──────────┬───────────┘               └──────────┬───────────┘
                 │                                       │
                 ▼                                       ▼
      ┌──────────────────────┐               ┌──────────────────────┐
      │ Continuous Learning  │               │ ExamReport Generated │
      │ (XP & Coins awarded) │               │ (Stars, Stats, Revs) │
      └──────────────────────┘               └──────────────────────┘
```

### Module 5.1: Practice State Machine
* **States:** `Idle` $\rightarrow$ `QuestionActive` $\rightarrow$ `AnswerEvaluated(isCorrect)` $\rightarrow$ `NextQuestion`.
* **Behavior:** When an answer is tapped:
  1. Trigger immediate `evaluateAnswer(input)`.
  2. If correct: Trigger `ISoundService.playSuccess()`, award streak, show green confirmation.
  3. If wrong: Trigger `ISoundService.playSoftThud()`, show hint/secret trick, allow retry.

### Module 5.2: Exam State Machine
* **States:** `Idle` $\rightarrow$ `Running(timeLeft, currentIndex)` $\rightarrow$ `Completed(ExamReport)`.
* **Behavior:**
  1. Pre-generates an array of $N$ questions (typically 10) mixed across chosen operations.
  2. Runs a continuous ticker (`Stream.periodic` or `Timer.periodic`).
  3. On user tap: Silently record `AnswerSubmission(selected, timeSpent)`.
  4. Immediately render question $i+1$ without revealing correctness.
  5. If `timer == 0` or `currentIndex == N - 1`: Call `CalculateExamReportUseCase`.

---

## 6. Scoring, Diagnostics & Metrics (`ExamReport`)

The calculation service evaluates performance across three dimensions:

### 1. Star Rating Formula
$$\text{Accuracy \%} = \left(\frac{\text{Correct Answers}}{\text{Total Questions}}\right) \times 100$$
* **3 Stars (Gold):** Accuracy $\ge 90\%$
* **2 Stars (Silver):** $70\% \le \text{Accuracy} < 90\%$
* **1 Star (Bronze):** $50\% \le \text{Accuracy} < 70\%$
* **0 Stars (Try Again):** Accuracy $< 50\%$

### 2. Speed Metric
$$\text{Average Speed} = \frac{\text{Total Time Elapsed}}{\text{Total Questions Answered}}$$

### 3. Mistake Taxonomy (Feeds "Review Mistake" Button)
For each incorrect item, serialize:
* The original problem ($A \text{ op } B$).
* The child's chosen answer.
* The correct answer.
* The suggested hint (e.g., *"Hint: $8 + 7 = 15$! Don't forget to carry over the 1 ten to the next column"*).

---

## 7. Implementation & Testing Roadmap

### Step 1: Pure Domain Modeling
- [ ] Create `math_operation.dart`, `difficulty_level.dart`, `math_problem.dart`.
- [ ] Create `base10_decomposition.dart`.
- [ ] Implement `DecomposeBase10UseCase`.

### Step 2: Algorithmic Problem Generation
- [ ] Implement `GenerateProblemUseCase` covering all 12 operational matrix cases.
- [ ] Implement `GenerateDistractorsUseCase` with sanitation guards.
- [ ] **Unit Tests:**
  - Verify zero division remainders over 1,000 randomized iterations.
  - Verify zero negative answers in subtraction over 1,000 randomized iterations.
  - Verify distractors never equal the correct answer and contain no duplicates.

### Step 3: Game Session Engines
- [ ] Implement `PracticeSessionNotifier` (Immediate feedback loop).
- [ ] Implement `ExamSessionNotifier` (Timer management, queue management, silent submission).
- [ ] Implement `CalculateExamReportUseCase`.
- [ ] **Unit Tests:**
  - Verify timeout automatically finalizes the exam.
  - Verify accuracy and star distribution boundaries ($90\%, 70\%, 50\%$).

### Step 4: Presentation & UI Binding
- [ ] Bind `Base10Decomposition` to the `Base10CountingHelper` widget.
- [ ] Bind `ExamSessionNotifier` to Screen 5 (Active Game Screen) and Screen 4 (Quest Complete Screen).
