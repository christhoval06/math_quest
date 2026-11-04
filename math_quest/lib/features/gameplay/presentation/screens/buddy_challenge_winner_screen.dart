import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/buddy_winner_celebration.dart';

class BuddyChallengeWinnerScreen extends StatefulWidget {
  final String winnerName;
  final int winnerNumber;
  final int player1Score;
  final int player2Score;
  final VoidCallback onExit;
  final VoidCallback onPlayAgain;
  final VoidCallback onChangeSettings;

  const BuddyChallengeWinnerScreen({
    super.key,
    required this.winnerName,
    required this.winnerNumber,
    required this.player1Score,
    required this.player2Score,
    required this.onExit,
    required this.onPlayAgain,
    required this.onChangeSettings,
  });

  @override
  State<BuddyChallengeWinnerScreen> createState() =>
      _BuddyChallengeWinnerScreenState();
}

class _BuddyChallengeWinnerScreenState extends State<BuddyChallengeWinnerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final ConfettiController _leftConfettiController;
  late final ConfettiController _rightConfettiController;
  bool _celebrationStarted = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0, 0.65, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );
    _leftConfettiController = _createConfettiController();
    _rightConfettiController = _createConfettiController();
  }

  ConfettiController _createConfettiController() =>
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    final reduceMotion =
        mediaQuery.accessibleNavigation || mediaQuery.disableAnimations;
    if (reduceMotion != _reduceMotion) {
      _reduceMotion = reduceMotion;
      if (_reduceMotion) {
        _entranceController.value = 1;
        _leftConfettiController.stop();
        _rightConfettiController.stop();
      }
    }

    if (_celebrationStarted) return;
    _celebrationStarted = true;
    if (_reduceMotion) {
      _entranceController.value = 1;
      return;
    }

    _entranceController.forward();
    _leftConfettiController.play();
    _rightConfettiController.play();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _leftConfettiController.dispose();
    _rightConfettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final winnerColor = widget.winnerNumber == 1
        ? AppColors.opAddition
        : AppColors.opSubtraction;
    final winnerForegroundColor = widget.winnerNumber == 1
        ? const Color(0xFF0369A1)
        : const Color(0xFFBE123C);

    return Scaffold(
      key: const Key('buddy-winner-screen'),
      body: DecoratedBox(
        decoration: buddyWinnerBackground(winnerColor),
        child: SafeArea(
          child: Stack(
            children: [
              BuddyCelebrationBackdrop(color: winnerColor),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: FadeTransition(
                    key: const Key('buddy-winner-entrance'),
                    opacity: _fadeAnimation,
                    alwaysIncludeSemantics: true,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: BuddyWinnerCelebrationCard(
                        winnerName: widget.winnerName,
                        winnerColor: winnerColor,
                        winnerForegroundColor: winnerForegroundColor,
                        player1Score: widget.player1Score,
                        player2Score: widget.player2Score,
                        onPlayAgain: widget.onPlayAgain,
                        onChangeSettings: widget.onChangeSettings,
                        onExit: widget.onExit,
                      ),
                    ),
                  ),
                ),
              ),
              if (!_reduceMotion) ...[
                _ConfettiBurst(
                  alignment: Alignment.topLeft,
                  controller: _leftConfettiController,
                  blastDirection: math.pi / 4,
                  winnerColor: winnerColor,
                ),
                _ConfettiBurst(
                  alignment: Alignment.topRight,
                  controller: _rightConfettiController,
                  blastDirection: 3 * math.pi / 4,
                  winnerColor: winnerColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfettiBurst extends StatelessWidget {
  final Alignment alignment;
  final ConfettiController controller;
  final double blastDirection;
  final Color winnerColor;

  const _ConfettiBurst({
    required this.alignment,
    required this.controller,
    required this.blastDirection,
    required this.winnerColor,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirection: blastDirection,
          blastDirectionality: BlastDirectionality.directional,
          emissionFrequency: 0.06,
          numberOfParticles: 18,
          maxBlastForce: 18,
          minBlastForce: 8,
          gravity: 0.16,
          shouldLoop: false,
          colors: [
            winnerColor,
            AppColors.primaryBlue,
            AppColors.secondaryOrange,
            AppColors.successGreen,
            AppColors.accentPurple,
          ],
        ),
      ),
    );
  }
}
