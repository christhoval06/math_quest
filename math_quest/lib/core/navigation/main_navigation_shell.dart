
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/audio/sound_provider.dart';
import 'package:math_quest/core/theme/theme_provider.dart';
import 'package:math_quest/core/services/screen_time_provider.dart';

import 'package:math_quest/features/profile_and_stats/presentation/screens/home_dashboard_screen.dart';
import 'package:math_quest/features/mission_setup/presentation/screens/custom_mission_screen.dart';
import 'package:math_quest/features/gameplay/presentation/screens/adventure_island_screen.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/trophy_room_screen.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_config.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/navigation/parent_gate_launcher.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/screens/settings_screen.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/screen_time_lock_dialog.dart';

typedef ParentGateRequest = Future<bool> Function(
  BuildContext context, {
  required ParentGateChallenge challenge,
  required ParentGateConfig config,
});

class MainNavigationShell extends ConsumerStatefulWidget {
  final int initialIndex;
  final List<Widget> screens;
  final ParentGateChallengeGenerator? parentGateGenerator;
  final ParentGateRequest requestParentAccess;

  const MainNavigationShell({
    super.key,
    this.initialIndex = 0,
    this.screens = const [
      HomeDashboardScreen(),
      CustomMissionScreen(),
      AdventureIslandScreen(),
      TrophyRoomScreen(),
      SettingsScreen(),
    ],
    this.parentGateGenerator,
    this.requestParentAccess = ParentGateLauncher.requestAccess,
  }) : assert(screens.length == 5);

  @override
  ConsumerState<MainNavigationShell> createState() =>
      _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  late int _currentIndex;
  late final ParentGateChallengeGenerator _parentGateGenerator;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _parentGateGenerator =
        widget.parentGateGenerator ??
        ParentGateChallengeGenerator(Random().nextInt);
  }

  Future<bool> _promptParentGate(BuildContext context) async {
    return widget.requestParentAccess(
      context,
      challenge: _parentGateGenerator.generate(),
      config: ParentGateConfig.extraTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<_NavigationTabItem> tabs = [
      _NavigationTabItem(
        icon: Icons.play_circle_filled_rounded,
        label: AppLocalizations.of(context)!.navPlay,
      ),
      _NavigationTabItem(
        icon: Icons.edit_calendar_rounded,
        label: AppLocalizations.of(context)!.navPractice,
      ),
      _NavigationTabItem(
        icon: Icons.explore_rounded,
        label: AppLocalizations.of(context)!.navQuest,
      ),
      _NavigationTabItem(
        icon: Icons.emoji_events_rounded,
        label: AppLocalizations.of(context)!.navTrophies,
      ),
      _NavigationTabItem(
        icon: Icons.settings_rounded,
        label: AppLocalizations.of(context)!.settingsTitle,
      ),
    ];

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // 🎨 READ ACTIVE THEME LIVE!
    final theme = ref.watch(visualThemeProvider);

    ref.listen<ScreenTimeState>(screenTimeProvider, (previous, next) {
      if (next.isLocked && (previous == null || !previous.isLocked)) {
        // 🔒 LAUNCH THE REST OVERLAY AUTOMATICALLY!
        ScreenTimeLockDialog.show(context, () async {
          final unlocked = await _promptParentGate(context);
          if (!unlocked || !mounted) return;

          // Parent grants +15 minutes
          ref.read(screenTimeProvider.notifier).grantExtraMinutes(15);
          Navigator.pop(this.context); // Dismiss dialog
        });
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.background, // 👈 Dynamic scaffold background
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: widget.screens),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: bottomPadding > 0 ? bottomPadding : 20.0,
          ),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withValues(
                    alpha: 0.12,
                  ), // 👈 Dynamic shadow tint!
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: theme.border, // 👈 Dynamic border
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(tabs.length, (index) {
                final tab = tabs[index];
                final isSelected = _currentIndex == index;

                return Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_currentIndex != index) {
                        ref.read(soundServiceProvider).playTap();
                        setState(() => _currentIndex = index);
                      }
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // Icon & Label colored dynamically
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 4),
                            Icon(
                              tab.icon,
                              size: isSelected ? 24 : 22,
                              color: isSelected
                                  ? theme
                                        .primary // 👈 Dynamic active icon!
                                  : const Color(0xFF94A3B8),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              tab.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.w900
                                    : FontWeight.w600,
                                color: isSelected
                                    ? theme
                                          .primary // 👈 Dynamic active text!
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationTabItem {
  final IconData icon;
  final String label;

  const _NavigationTabItem({required this.icon, required this.label});
}
