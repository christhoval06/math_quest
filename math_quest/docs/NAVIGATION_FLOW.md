# Navigation Flow & Route Architecture

**App:** MathQuest  
**Routing Framework:** [`go_router`](https://pub.dev/packages/go_router) (Declarative, Type-Safe, Deep-Link Ready, ShellRoute for Bottom Navigation)

---

## 1. Routing Architecture Overview

The app splits navigation into two categories:
1. **Persistent Bottom Navigation Shell (`StatefulShellRoute`):** Keeps bottom bar intact and maintains tab scroll positions.
2. **Full-Screen Modal Routes:** Overlays without the bottom bar (Gameplay, Quest Completion, Parent Gate).

```
┌────────────────────────────────────────────────────────────────────────┐
│                        APP ROUTER (go_router)                          │
├────────────────────────────────────────────────────────────────────────┤
│  Standalone Full-Screen Routes:                                        │
│   • /splash           (Screen 1: Welcome & Profile Selection)          │
│   • /game-active      (Screen 5: Active Problem Solving)               │
│   • /quest-complete   (Screen 4: Stars, Summary & Mistake Review)      │
│                                                                        │
│  StatefulShellRoute (Persistent Bottom Navigation Bar):                │
│   ├── Tab 0: /home            (Screen 2: Play Hub & Daily Mission)     │
│   ├── Tab 1: /practice        (Screen 3: Custom Math Mission Setup)    │
│   ├── Tab 2: /adventure       (Adventure Island / Story Mode)          │
│   ├── Tab 3: /trophies        (Screen 6: Trophy Room & Stats)          │
│   └── Tab 4: /settings        (Screen 7: Settings & Parental Zone)     │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Route Registry & Screen Mapping

| Route Path | Screen Ref | Name | Presentation Type | Guard / Prerequisite |
| :--- | :--- | :--- | :--- | :--- |
| `/splash` | **Screen 1** | `WelcomeSplash` | Full Screen | None |
| `/home` | **Screen 2** | `HomeDashboard` | Tab 0 (`Play`) | Active profile selected |
| `/practice` | **Screen 3** | `CustomMission` | Tab 1 (`Practice`) | None |
| `/adventure` | — | `AdventureIsland` | Tab 2 (`Quest`) | None |
| `/trophies` | **Screen 6** | `TrophyRoom` | Tab 3 (`Trophies`) | None |
| `/settings` | **Screen 7** | `Settings` | Tab 4 (`Settings`) | **Protected by Parent Gate** |
| `/game-active` | **Screen 5** | `ActiveGame` | Full-Screen Modal | Requires `MissionLaunchArgs` |
| `/quest-complete` | **Screen 4** | `QuestComplete` | Full-Screen Modal | Requires `QuestResultArgs` |

---

## 3. Screen-by-Screen Navigation Flows

### Flow A: Core Gameplay Loop (Practice or Exam)
```
[Screen 2: Home] OR [Screen 3: Custom Mission]
       │
       ▼ (Tap "Start Adventure!" or "Launch Math Mission!")
[Screen 5: Active Game Screen] (Full Screen)
       │
       ├─► (Tap "Exit / Back") ──► Confirmation Dialog ("Quit Mission?")
       │                                  │
       │                                  ├─► Confirm: Pop to Home
       │                                  └─► Cancel: Resume Quest
       ▼ (Complete all questions / Time expires)
[Screen 4: Quest Complete Screen] (Full Screen)
       │
       ├─► (Tap "Play Another Round") ──► Push Replacement to `/game-active`
       ├─► (Tap "Review 1 Mistake")   ──► Show Mistake Review Bottom Sheet
       └─► (Tap "Back to Home")       ──► Navigate to `/home` (Tab 0)
```

### Flow B: Parental Gate Access
```
[Screen 2: Home]
       │
       ▼ (Tap "Settings" tab in Bottom Bar)
[Parent Gate Interceptor Modal]
       │
       ├─► Fails Challenge / Dismisses ──► Stay on current tab (e.g., `/home`)
       │
       ▼ Passes Challenge ("Solve 7 × 8" or PIN)
[Screen 7: Settings & Parental Control Screen]
```

### Flow C: Profile Switching
```
[Screen 1: Splash] OR [Screen 7: Settings]
       │
       ▼ (Tap "Playing as: Leo" or "Switch Profile")
[Profile Switcher Bottom Sheet]
       │
       ▼ (Select "Mia - Kindergarten")
Re-seed Active Profile State ──► Navigate to `/home` (Refreshes Mastery Tracks)
```

---

## 4. Route Arguments & Contracts (Data Payloads)

To avoid global mutable state coupling, data between screens is passed via type-safe DTOs.

### 4.1 Launch Arguments: `/practice` $\rightarrow$ `/game-active`
```dart
import '../../math_engine/domain/entities/math_operation.dart';
import '../../math_engine/domain/entities/difficulty_level.dart';

class MissionLaunchArgs {
  final List<MathOperation> operations;
  final Difficulty difficulty;
  final int totalQuestions;
  final int timeLimitSeconds; // 0 = No timer
  final bool enableVisualAids; // Base-10 helper
  final bool isExamMode;       // Silent feedback vs immediate validation

  const MissionLaunchArgs({
    required this.operations,
    required this.difficulty,
    this.totalQuestions = 10,
    this.timeLimitSeconds = 0,
    this.enableVisualAids = true,
    this.isExamMode = false,
  });
}
```

### 4.2 Completion Arguments: `/game-active` $\rightarrow$ `/quest-complete`
```dart
import '../../math_engine/domain/entities/exam_report.dart';
import 'mission_launch_args.dart';

class QuestResultArgs {
  final ExamReport report;
  final MissionLaunchArgs originalConfig;
  final int earnedCoins;
  final int earnedXp;

  const QuestResultArgs({
    required this.report,
    required this.originalConfig,
    required this.earnedCoins,
    required this.earnedXp,
  });
}
```

---

## 5. Security & Parent Gate Guard Strategy

Under **Apple App Store Review Guideline 1.3** and **Google Play Families Policy**, apps directed to children must protect settings, external links, and account management behind an adult gate.

### Parent Gate Verification Function
```dart
class ParentGateGuard {
  static Future<bool> verifyAdult(BuildContext context) async {
    final rand = Random();
    final n1 = rand.nextInt(5) + 6; // 6 to 10
    final n2 = rand.nextInt(5) + 6; // 6 to 10
    final expectedAnswer = n1 * n2;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ParentGateDialog(
        num1: n1,
        num2: n2,
        expectedAnswer: expectedAnswer,
      ),
    );

    return result ?? false;
  }
}
```

---

## 6. Complete Router Implementation (`app_router.dart`)

Save this file in `lib/core/navigation/app_router.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import '../../features/profile_and_stats/presentation/screens/welcome_splash_screen.dart';
import '../../features/profile_and_stats/presentation/screens/home_dashboard_screen.dart';
import '../../features/profile_and_stats/presentation/screens/trophy_room_screen.dart';
import '../../features/mission_setup/presentation/screens/custom_mission_screen.dart';
import '../../features/settings_and_parent_gate/presentation/screens/settings_screen.dart';
import '../../features/gameplay/presentation/screens/active_game_screen.dart';
import '../../features/gameplay/presentation/screens/quest_complete_screen.dart';

// Shell & Contracts
import 'app_shell_scaffold.dart';
import 'parent_gate_guard.dart';
import 'mission_launch_args.dart';
import 'quest_result_args.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // 1. Entry / Welcome Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const WelcomeSplashScreen(),
      ),

      // 2. Persistent Bottom Navigation Bar Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home / Play Hub
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeDashboardScreen(),
              ),
            ],
          ),

          // Tab 1: Practice / Custom Mission
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/practice',
                name: 'practice',
                builder: (context, state) => const CustomMissionScreen(),
              ),
            ],
          ),

          // Tab 2: Adventure Quest (Placeholder / Story mode)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/adventure',
                name: 'adventure',
                builder: (context, state) => const Scaffold(
                  body: Center(child: Text('Adventure Island Coming Soon!')),
                ),
              ),
            ],
          ),

          // Tab 3: Trophies & Stats
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/trophies',
                name: 'trophies',
                builder: (context, state) => const TrophyRoomScreen(),
              ),
            ],
          ),

          // Tab 4: Settings (Guarded by Parent Gate)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
                onExit: (context, state) => true,
              ),
            ],
          ),
        ],
      ),

      // 3. Active Gameplay Screen (Full Screen Modal)
      GoRoute(
        path: '/game-active',
        name: 'game-active',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as MissionLaunchArgs;
          return ActiveGameScreen(args: args);
        },
      ),

      // 4. Quest Complete Summary (Full Screen Modal)
      GoRoute(
        path: '/quest-complete',
        name: 'quest-complete',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as QuestResultArgs;
          return QuestCompleteScreen(args: args);
        },
      ),
    ],
  );
}
```

---

## 7. Scaffold with Bottom Navigation Bar (`app_shell_scaffold.dart`)

Matches the exact icons and labels from **Screen 2 & Screen 7**:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'parent_gate_guard.dart';

class AppShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) async {
            // Intercept tab 4 (Settings) for Parent Gate verification
            if (index == 4) {
              final isAdult = await ParentGateGuard.verifyAdult(context);
              if (!isAdult) return; // Do not switch tab if canceled/incorrect
            }
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1CB0F6),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.play_circle_filled_rounded), label: 'Play'),
            BottomNavigationBarItem(icon: Icon(Icons.edit_calendar_rounded), label: 'Practice'),
            BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Quest'),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events_rounded), label: 'Trophies'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}
```
