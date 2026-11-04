import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/features/gameplay/presentation/providers/quest_complete_provider.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/quest_rewards_row.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/quest_stats_card.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/quest_stella_card.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/question_review_item.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/star_rating_widget.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/unlocked_badge_banner.dart';
import 'package:math_quest/features/math_engine/domain/entities/exam_report.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_notifier.dart';
import 'package:math_quest/l10n/app_localizations.dart';

// Core

// Domain

// Presentation Widgets & ViewModels

// Import newly refactored components & view model

class QuestCompleteScreen extends ConsumerStatefulWidget {
  final ExamReport report;
  final int? levelNumber;
  final int timerSeconds;

  const QuestCompleteScreen({
    super.key,
    required this.report,
    this.levelNumber,
    this.timerSeconds = 0,
  });

  @override
  ConsumerState<QuestCompleteScreen> createState() =>
      _QuestCompleteScreenState();
}

class _QuestCompleteScreenState extends ConsumerState<QuestCompleteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(questCompleteProvider.notifier)
          .initializeSession(
            report: widget.report,
            levelNumber: widget.levelNumber,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final state = ref.watch(questCompleteProvider);
    final viewModel = ref.read(questCompleteProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: ResponsiveContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    StarRatingWidget(starsEarned: report.starsEarned),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.questComplete,
                        style: AppTypography.titleLarge.copyWith(fontSize: 28),
                      ),
                    ),
                    const SizedBox(height: 16),
                    QuestStellaCard(
                      accuracyPercentage: report.accuracyPercentage,
                      profileName: state.profileName,
                    ),
                    const SizedBox(height: 18),
                    QuestStatsCard(report: report),
                    const SizedBox(height: 14),
                    QuestRewardsRow(report: report),
                    const SizedBox(height: 20),

                    // Newly Unlocked Badges
                    for (final badge in state.newlyUnlockedBadges)
                      UnlockedBadgeBanner(badge: badge),

                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.questionReview,
                          style: AppTypography.titleMedium,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .questionCount(report.answers.length),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    for (final ans in report.answers)
                      QuestionReviewItem(submission: ans),
                    const SizedBox(height: 20),

                    // Primary Button Action
                    if (widget.levelNumber != null && report.starsEarned > 0)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.successGreen,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          final nextLevelNumber = widget.levelNumber! + 1;
                          ref
                              .read(practiceSessionProvider.notifier)
                              .resetSession();
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.activeGame,
                            arguments: ActiveGameArgs(
                              levelNumber: nextLevelNumber,
                              timerSeconds: widget.timerSeconds,
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.nextStage,
                          style: AppTypography.buttonText,
                        ),
                      )
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryOrange,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(practiceSessionProvider.notifier)
                              .resetSession();
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.activeGame,
                            arguments: ActiveGameArgs(
                              levelNumber: widget.levelNumber,
                              timerSeconds: widget.timerSeconds,
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.playAnotherRoundAction,
                          style: AppTypography.buttonText,
                        ),
                      ),

                    // Secondary Mistake Review Button
                    if (report.mistakes.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(practiceSessionProvider.notifier)
                              .resetSession(
                                operation:
                                    report.mistakes.first.problem.operation,
                              );
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.activeGame,
                            arguments: ActiveGameArgs(
                              levelNumber: null,
                              timerSeconds: 0,
                              totalQuestions: report.mistakes.length,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.psychology_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.reviewMistakesCount(report.mistakes.length),
                                textAlign: TextAlign.center,
                                style: AppTypography.buttonText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.mainShell,
                          (route) => false,
                          arguments: widget.levelNumber != null ? 2 : 0,
                        );
                      },
                      child: Text(
                        widget.levelNumber != null
                            ? AppLocalizations.of(context)!.backAdventureMap
                            : AppLocalizations.of(context)!.backHomeAction,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: SizedBox.expand(
                key: const Key('quest-complete-confetti-overlay'),
                child: Stack(
                  children: [
                    _QuestCompleteConfettiBurst(
                      alignment: Alignment.topLeft,
                      blastDirection: math.pi / 4,
                      controller: viewModel.confettiController,
                    ),
                    _QuestCompleteConfettiBurst(
                      alignment: Alignment.topRight,
                      blastDirection: 3 * math.pi / 4,
                      controller: viewModel.confettiController,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestCompleteConfettiBurst extends StatelessWidget {
  final Alignment alignment;
  final double blastDirection;
  final ConfettiController controller;

  const _QuestCompleteConfettiBurst({
    required this.alignment,
    required this.blastDirection,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
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
        colors: const [
          AppColors.primaryBlue,
          AppColors.secondaryOrange,
          AppColors.successGreen,
          AppColors.accentPurple,
        ],
      ),
    );
  }
}
