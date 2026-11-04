import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/mastery_track_ui_model.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/stats_localizations.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/mastery_operation_badge.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class MasteryTrackCard extends StatelessWidget {
  final MasteryTrack track;
  final VoidCallback? onTap;

  const MasteryTrackCard({super.key, required this.track, this.onTap});

  @override
  Widget build(BuildContext context) {
    final ui = MasteryTrackUiModel.fromDomain(track);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. Atomic Badge
            MasteryOperationBadge(symbol: ui.symbol, color: ui.accentColor),
            const SizedBox(width: 12),

            // 2. Details & Progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row A: Operation & Accuracy
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        localizedStatsOperation(
                          AppLocalizations.of(context)!,
                          ui.operationTitle,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        ui.localizedAccuracy(AppLocalizations.of(context)!),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: ui.hasActivity
                              ? ui.accentColor
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Row B: Rank & Remaining Count
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        ui.localizedRank(AppLocalizations.of(context)!),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: ui.accentColor,
                        ),
                      ),
                      Text(
                        ui.localizedProgress(AppLocalizations.of(context)!),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Row C: Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: ui.progressToNextLevel,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation(
                        ui.hasActivity
                            ? ui.accentColor
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
