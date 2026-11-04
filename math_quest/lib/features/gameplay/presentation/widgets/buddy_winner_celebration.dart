import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/gameplay/presentation/models/gameplay_localizations.dart';
import 'package:math_quest/l10n/app_localizations.dart';

BoxDecoration buddyWinnerBackground(Color winnerColor) => BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.alphaBlend(
        winnerColor.withValues(alpha: 0.13),
        AppColors.backgroundLight,
      ),
      Colors.white,
      Color.alphaBlend(
        AppColors.secondaryOrange.withValues(alpha: 0.08),
        AppColors.backgroundLight,
      ),
    ],
  ),
);

class BuddyWinnerCelebrationCard extends StatelessWidget {
  final String winnerName;
  final Color winnerColor;
  final Color winnerForegroundColor;
  final int player1Score;
  final int player2Score;
  final VoidCallback onPlayAgain;
  final VoidCallback onChangeSettings;
  final VoidCallback onExit;

  const BuddyWinnerCelebrationCard({
    super.key,
    required this.winnerName,
    required this.winnerColor,
    required this.winnerForegroundColor,
    required this.player1Score,
    required this.player2Score,
    required this.onPlayAgain,
    required this.onChangeSettings,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 460),
      child: Card(
        elevation: 12,
        shadowColor: winnerColor.withValues(alpha: 0.22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 30, 28, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TrophyMedallion(color: winnerColor),
              const SizedBox(height: 18),
              _ChampionBadge(color: winnerForegroundColor),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.winnerName(
                  localizedPlayerName(
                    AppLocalizations.of(context)!,
                    winnerName,
                  ),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.titleLarge.copyWith(
                  color: winnerForegroundColor,
                  fontSize: 32,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.outstandingReflexes,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 22),
              _FinalScore(
                player1Score: player1Score,
                player2Score: player2Score,
                accentColor: winnerForegroundColor,
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onPlayAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: winnerForegroundColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.replay_rounded),
                  label: Text(AppLocalizations.of(context)!.playAgain),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onChangeSettings,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: AppColors.borderLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.tune_rounded),
                  label: Text(AppLocalizations.of(context)!.changeSettings),
                ),
              ),
              const SizedBox(height: 4),
              TextButton.icon(
                onPressed: onExit,
                icon: const Icon(Icons.close_rounded, size: 18),
                label: Text(AppLocalizations.of(context)!.exit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuddyCelebrationBackdrop extends StatelessWidget {
  final Color color;

  const BuddyCelebrationBackdrop({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -45,
            child: _GlowCircle(size: 190, color: color),
          ),
          const Positioned(
            bottom: -80,
            left: -60,
            child: _GlowCircle(size: 220, color: AppColors.secondaryOrange),
          ),
        ],
      ),
    );
  }
}

class _TrophyMedallion extends StatelessWidget {
  final Color color;

  const _TrophyMedallion({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94,
      height: 94,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondaryOrange.withValues(alpha: 0.18),
            color.withValues(alpha: 0.14),
          ],
        ),
        border: Border.all(
          color: AppColors.secondaryOrange.withValues(alpha: 0.55),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.emoji_events_rounded,
        size: 52,
        color: AppColors.secondaryOrange,
      ),
    );
  }
}

class _ChampionBadge extends StatelessWidget {
  final Color color;

  const _ChampionBadge({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        AppLocalizations.of(context)!.champion,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _FinalScore extends StatelessWidget {
  final int player1Score;
  final int player2Score;
  final Color accentColor;

  const _FinalScore({
    required this.player1Score,
    required this.player2Score,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: AppLocalizations.of(context)!
          .finalScoreSemantics(player1Score, player2Score),
      child: ExcludeSemantics(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.finalScore,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$player1Score – $player2Score',
                style: AppTypography.displayStat.copyWith(color: accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.06),
      ),
    );
  }
}
