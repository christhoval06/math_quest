# Gamification, Progression & Economy Specification

**App:** MathQuest  
**Target Audience:** Ages 4–10  
**Pedagogical Goal:** Foster intrinsic motivation, resilience against mistakes, and daily micro-habits without predatory engagement loops (No loot boxes, no real-money gambling, zero dark patterns).

---

## 1. Core Mechanics & Economy Overview

The game economy operates on three non-monetary reward systems:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        MATHQUEST REWARD ENGINE                         │
├─────────────────────┬──────────────────────────┬───────────────────────┤
│  Currencies / Stats │ Mechanism                │ Primary Use           │
├─────────────────────┼──────────────────────────┼───────────────────────┤
│  ⚡ Math XP         │ Cumulative lifetime gain │ Unlocks Level & Ranks │
│  🪙 Star Coins      │ Spendable currency       │ Visual Themes/Avatars │
│  ⭐ Stars           │ Quest performance rating │ Unlocks Trophy Badges │
│  🔥 Streaks         │ Daily habit counter      │ Retention & Milestones│
└─────────────────────┴──────────────────────────┴───────────────────────┘
```

---

## 2. Economy & Currency Rules

### 2.1 Math XP (Experience Points)
* **Purpose:** Measures long-term effort and perseverance. XP is **never deducted**.
* **Earning Formula:**
  $$\text{Base XP per correct answer} = 10 \text{ XP}$$
  $$\text{First-time mistake corrected} = +5 \text{ XP (Rewards resilience)}$$
  $$\text{Quest Completion Bonus} = +20 \text{ XP}$$
  $$\text{Perfect Round (10/10)} = +50 \text{ XP}$$

### 2.2 Star Coins (🪙)
* **Purpose:** Collectible currency displayed in the top bar (e.g., `1,420` in UI). Used to unlock visual world themes (Screen 7: *Galaxy Quest*, *Candy Land*, *Dino Math*, *Underwater*).
* **Earning Formula:**
  $$\text{Base Coins per correct question} = 2 \text{ coins}$$
  $$\text{Daily Mission Complete} = 50 \text{ coins}$$
  $$\text{New Badge Unlocked} = 100 \text{ coins}$$

### 2.3 Stars (⭐)
* **Purpose:** Earned per mission (0 to 3 stars based on accuracy):
  * ⭐⭐⭐ **3 Stars:** Accuracy $\ge 90\%$
  * ⭐⭐ **2 Stars:** $70\% \le \text{Accuracy} < 90\%$
  * ⭐ **1 Star:** $50\% \le \text{Accuracy} < 70\%$
  * ❌ **0 Stars:** Accuracy $< 50\%$ (Encourages child to "Retry with Starry's Hints")

---

## 3. Level Progression Curve (Ranks)

A child levels up by accumulating Math XP. The curve starts gentle to provide rapid early reinforcement for young children:

$$\text{XP Required for Level } L = 100 \times L^{1.5}$$

| Level | Rank Title | Total XP Required | Unlocks |
| :---: | :--- | :---: | :--- |
| **1** | Cosmic Sprout | 0 XP | Starter Avatar, Practice Arena |
| **2** | Number Cadet | 280 XP | Custom Mission Timers |
| **3** | Star Explorer | 520 XP | Buddy Challenge Mode |
| **4** | Math Wizard | 800 XP | Dino Math Theme |
| **5** | Master Mind | 1,120 XP | Galaxy Quest Theme |
| **6–10**| Grand Cosmic Champion | Up to 3,160 XP | Legendary Avatars & Badges |

---

## 4. Streak System & Grace Period

Matches the **"5 Day Streak!" / "7 Days Unstoppable!"** counter on Screens 1, 2, and 6.

### 4.1 Daily Streak Rules
* A streak increases by $+1$ when the child solves at least **5 math problems** within a calendar day ($00:00 - 23:59$ local time).
* **Streak Freeze (Pedagogical Grace):** Children should never feel crushed if they miss a single day (e.g., weekend family trip or illness).
  * Every child gets **1 automatic Streak Shield** every 7 days.
  * If a day is missed with an active shield, the streak is **frozen** rather than reset to zero.

---

## 5. Math Mastery Tracks (Screen 6)

Every child has individual mastery levels for the 4 core arithmetic operations:

```
┌────────────────────────────────────────────────────────┐
│                  MASTERY PROGRESSION                   │
│ Level 1 (Explorer)     ──► 0-99 Solved (Accuracy >60%) │
│ Level 2 (Adventurer)   ──► 100-249 Solved (>70%)       │
│ Level 3 (Rising Star)  ──► 250-449 Solved (>75%)       │
│ Level 4 (Superhero)    ──► 450-749 Solved (>85%)       │
│ Level 5 (Master!)      ──► 750+ Solved (>90%)          │
└────────────────────────────────────────────────────────┘
```

### Mockup Alignment (From Screen 6):
* **Addition:** Level 5 *Master!* (520 solved, 98% accuracy)
* **Subtraction:** Level 4 *Superhero* (340 solved, 89% accuracy)
* **Multiplication:** Level 3 *Rising Star* (260 solved, 78% accuracy)
* **Division:** Level 2 *Explorer* (128 solved, 62% accuracy)

---

## 6. Trophy Room & Badge Registry

Badges unlocked in **Screen 4 & Screen 6** with clear pedagogical criteria:

| Badge ID | Badge Title | Visual Icon | Unlock Condition |
| :--- | :--- | :---: | :--- |
| `speed_counter` | **Speed Counter** | ⚡ | Solve 5 questions under 5 seconds each in a single round |
| `century_club` | **Century Club** | 💯 | Solve 100 questions total across any operation |
| `lightning_math`| **Lightning Math** | 🌩️ | Score 10 correct answers in under 30 seconds |
| `week_warrior` | **Week Warrior** | 🛡️ | Maintain a 7-day practice streak |
| `times_master` | **Times Master** | ✖️ | Reach Level 5 in Multiplication Mastery Track |
| `space_detective`| **Space Detective**| 🔍 | Complete Today's Mission (10 Addition Puzzles) |
| `clean_slate` | **Zero Mistake Hero**| 🎯 | Complete a 10-question Hard Exam with 100% accuracy |

---

## 7. Daily Missions Engine (Screen 2)

Each day at midnight, the engine generates **1 featured Daily Mission**:

* **Mission Template:** `"Solve [N] [Operation] Puzzles"`
  * Example: `"Solve 10 Addition Puzzles (6 of 10 completed)"`
* **Progress Bar:** $6 / 10 \implies 60\%$
* **Completion Reward:**
  * $+50$ Star Coins
  * Mission Exclusive Badge (e.g., *Space Detective Badge*)
  * Mascot Fanfare Animation from Starry

---

## 8. Dart Domain Implementation (`gamification_engine.dart`)

Save in `lib/features/profile_and_stats/domain/services/gamification_engine.dart`:

```dart
import '../entities/user_profile.dart';
import '../entities/mastery_track.dart';
import '../../../math_engine/domain/entities/exam_report.dart';

class RewardCalculationResult {
  final int earnedXp;
  final int earnedCoins;
  final int earnedStars;
  final List<String> newlyUnlockedBadges;

  const RewardCalculationResult({
    required this.earnedXp,
    required this.earnedCoins,
    required this.earnedStars,
    required this.newlyUnlockedBadges,
  });
}

class GamificationEngine {
  /// Evaluates an exam/practice round and returns rewards and unlocked badges
  static RewardCalculationResult evaluateSession({
    required ExamReport report,
    required UserProfile profile,
    required bool isDailyMission,
  }) {
    // 1. Calculate XP
    int xp = report.correctCount * 10;
    if (report.accuracyPercentage == 100) xp += 50; // Perfect bonus
    if (report.accuracyPercentage >= 90) xp += 20;

    // 2. Calculate Star Coins
    int coins = report.correctCount * 2;
    if (isDailyMission) coins += 50;

    // 3. Stars
    int stars = report.starsEarned;

    // 4. Badge Evaluation
    final List<String> newBadges = [];

    // Check: Speed Counter (5 questions < 5s each)
    if (!profile.unlockedBadgeIds.contains('speed_counter')) {
      final fastAnswers = report.answers.where(
        (a) => a.isCorrect && a.timeTaken.inSeconds <= 5,
      ).length;
      if (fastAnswers >= 5) {
        newBadges.add('speed_counter');
        coins += 100;
      }
    }

    // Check: Zero Mistake Hero (10/10 with 100% accuracy)
    if (!profile.unlockedBadgeIds.contains('clean_slate')) {
      if (report.totalQuestions >= 10 && report.accuracyPercentage == 100) {
        newBadges.add('clean_slate');
        coins += 100;
      }
    }

    // Check: Century Club (Lifetime solved >= 100)
    final totalSolved = profile.masteryTracks.values
        .fold(0, (sum, track) => sum + track.totalSolved);
    if (!profile.unlockedBadgeIds.contains('century_club') && 
        (totalSolved + report.correctCount) >= 100) {
      newBadges.add('century_club');
      coins += 100;
    }

    return RewardCalculationResult(
      earnedXp: xp,
      earnedCoins: coins,
      earnedStars: stars,
      newlyUnlockedBadges: newBadges,
    );
  }

  /// Calculates user level from accumulated XP
  static int computeLevelFromXp(int xp) {
    if (xp < 280) return 1;
    if (xp < 520) return 2;
    if (xp < 800) return 3;
    if (xp < 1120) return 4;
    return 5;
  }
}
```
