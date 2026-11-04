import 'package:flutter/material.dart';

// Core
import 'package:math_quest/core/navigation/main_navigation_shell.dart';

// Domain
import 'package:math_quest/features/math_engine/domain/entities/exam_report.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';

// Screens
import 'package:math_quest/features/profile_and_stats/presentation/screens/onboarding_screen.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/create_profile_screen.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/welcome_splash_screen.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/trophy_room_screen.dart';
import 'package:math_quest/features/mission_setup/presentation/screens/custom_mission_screen.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/screens/settings_screen.dart';
import 'package:math_quest/features/gameplay/presentation/screens/active_game_screen.dart';
import 'package:math_quest/features/gameplay/presentation/screens/quest_complete_screen.dart';
import 'package:math_quest/features/gameplay/presentation/screens/adventure_island_screen.dart';
import 'package:math_quest/features/gameplay/presentation/screens/buddy_challenge_screen.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/parent_diagnostic_screen.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/all_badges_screen.dart';

/// 1. Named Route Constants
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String createProfile = '/create-profile';
  static const String welcome = '/welcome';
  static const String mainShell = '/main';
  static const String activeGame = '/active-game';
  static const String questComplete = '/quest-complete';
  static const String customMission = '/custom-mission';
  static const String adventureIsland = '/adventure-island';
  static const String buddyChallenge = '/buddy-challenge';
  static const String trophyRoom = '/trophy-room';
  static const String settings = '/settings';
  static const String parentReport = '/parent-report';
  static const String allBadges = '/all-badges';
}

class ActiveGameArgs {
  final int? levelNumber;
  final String? stageTitle; // 👈 e.g. "Pebble Beach", "Gummy Shore"
  final int timerSeconds;
  final bool isExamMode;
  final List<MathOperation> allowedOperations;
  final int totalQuestions;
  final bool preservePreparedSession;
  final bool visualAidsEnabled;
  final bool soundEnabled;

  const ActiveGameArgs({
    this.levelNumber,
    this.stageTitle,
    this.timerSeconds = 60,
    this.isExamMode = false,
    this.allowedOperations = const [MathOperation.addition],
    this.totalQuestions = 10,
    this.preservePreparedSession = false,
    this.visualAidsEnabled = true,
    this.soundEnabled = true,
  });
}

/// 2. Route Arguments Data Contracts
class QuestCompleteArgs {
  final ExamReport report;
  final int? levelNumber;
  final int timerSeconds;

  const QuestCompleteArgs({
    required this.report,
    this.levelNumber,
    this.timerSeconds = 0,
  });
}

/// 3. Centralized Route Generator
class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Onboarding
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );

      // Create Profile
      case AppRoutes.createProfile:
        final isFromSettings = (settings.arguments as bool?) ?? false;
        return MaterialPageRoute(
          builder: (_) => CreateProfileScreen(isFromSettings: isFromSettings),
          settings: settings,
        );

      // Welcome Splash Screen
      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeSplashScreen(),
          settings: settings,
        );

      // Main Persistent Shell with Bottom Navigation
      case AppRoutes.mainShell:
        final initialIndex = (settings.arguments as int?) ?? 0;
        return MaterialPageRoute(
          builder: (_) => MainNavigationShell(initialIndex: initialIndex),
          settings: settings,
        );

      // Active Math Game
      case AppRoutes.activeGame:
        int? levelNumber;
        String? stageTitle;
        int timerSeconds = 60;
        bool isExamMode = false;
        List<MathOperation> allowedOperations = [MathOperation.addition];
        int totalQuestions = 10;
        bool preservePreparedSession = false;
        bool visualAidsEnabled = true;
        bool soundEnabled = true;

        if (settings.arguments is int) {
          levelNumber = settings.arguments as int;
          timerSeconds = 0;
        } else if (settings.arguments is ActiveGameArgs) {
          final args = settings.arguments as ActiveGameArgs;
          levelNumber = args.levelNumber;
          stageTitle = args.stageTitle;
          timerSeconds = args.timerSeconds;
          isExamMode = args.isExamMode;
          allowedOperations = args.allowedOperations;
          totalQuestions = args.totalQuestions;
          preservePreparedSession = args.preservePreparedSession;
          visualAidsEnabled = args.visualAidsEnabled;
          soundEnabled = args.soundEnabled;
        }

        return MaterialPageRoute(
          builder: (_) => ActiveGameScreen(
            levelNumber: levelNumber,
            stageTitle: stageTitle, // 👈 Passed to screen!
            timerSeconds: timerSeconds,
            isExamMode: isExamMode,
            allowedOperations: allowedOperations,
            totalQuestions: totalQuestions,
            preservePreparedSession: preservePreparedSession,
            visualAidsEnabled: visualAidsEnabled,
            soundEnabled: soundEnabled,
          ),
          settings: settings,
        );
      // Quest Complete Summary
      case AppRoutes.questComplete:
        final args = settings.arguments as QuestCompleteArgs;
        return MaterialPageRoute(
          builder: (_) => QuestCompleteScreen(
            report: args.report,
            levelNumber: args.levelNumber,
            timerSeconds: args.timerSeconds,
          ),
          settings: settings,
        );

      // Custom Math Mission Setup (Practice Lab)
      case AppRoutes.customMission:
        return MaterialPageRoute(
          builder: (_) => const CustomMissionScreen(),
          settings: settings,
        );

      // Adventure Island (Story Map)
      case AppRoutes.adventureIsland:
        return MaterialPageRoute(
          builder: (_) => const AdventureIslandScreen(),
          settings: settings,
        );

      // 2-Player Buddy Duel
      case AppRoutes.buddyChallenge:
        return MaterialPageRoute(
          builder: (_) => const BuddyChallengeScreen(),
          settings: settings,
        );

      // Trophy Room & Stats
      case AppRoutes.trophyRoom:
        return MaterialPageRoute(
          builder: (_) => const TrophyRoomScreen(),
          settings: settings,
        );

      // Settings & Parent Gate
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );

      // Parent Diagnostic Report Screen
      case AppRoutes.parentReport:
        return MaterialPageRoute(
          builder: (_) => const ParentDiagnosticScreen(),
          settings: settings,
        );

      // All Badges & Trophies Showcase Screen
      case AppRoutes.allBadges:
        return MaterialPageRoute(
          builder: (_) => const AllBadgesScreen(),
          settings: settings,
        );

      // 404 Fallback
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}
