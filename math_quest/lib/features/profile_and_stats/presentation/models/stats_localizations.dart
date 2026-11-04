import 'package:intl/intl.dart';
import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/mastery_track_ui_model.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/parent_diagnostic_state.dart';

String localizedStatsOperation(AppLocalizations l10n, String operation) =>
    switch (operation.toUpperCase()) {
      'ADDITION' => l10n.operationAddition.toUpperCase(),
      'SUBTRACTION' => l10n.operationSubtraction.toUpperCase(),
      'MULTIPLICATION' => l10n.operationMultiplication.toUpperCase(),
      'DIVISION' => l10n.operationDivision.toUpperCase(),
      _ => operation,
    };

extension MasteryLocalizations on MasteryTrackUiModel {
  String localizedRank(AppLocalizations l10n) => l10n.masteryRank(
    tier.badgeIcon,
    l10n.masteryTierTitle('l${tier.level}'),
    tier.level,
  );
  String localizedProgress(AppLocalizations l10n) => questionsRemaining == 0
      ? l10n.masteryMaxProgress(track.totalSolved)
      : l10n.masteryProgress(
          track.totalSolved,
          questionsRemaining,
          tier.level + 1,
        );
  String localizedAccuracy(AppLocalizations l10n) => track.totalSolved == 0
      ? '--%'
      : l10n.shortAccuracy((track.accuracy * 100).toInt());
}

extension DiagnosticLocalizations on ParentDiagnosticState {
  String localizedStrength(AppLocalizations l10n) {
    if (totalSolved == 0) return l10n.observationNeedsPractice;
    final strongest = strongestOperation;
    return strongest == null
        ? l10n.observationBuilding
        : l10n.observationStrength(
            localizedStatsOperation(l10n, strongest.title),
            strongest.accuracyPercent,
            strongest.totalSolved,
          );
  }

  String localizedFocus(AppLocalizations l10n) {
    if (totalSolved == 0) return l10n.observationStart;
    final focus = focusOperation;
    if (focus == null) return l10n.observationMaintain;
    final operation = localizedStatsOperation(l10n, focus.title);
    return focus.totalSolved == 0
        ? l10n.observationTry(operation)
        : l10n.observationFocus(operation, focus.accuracyPercent);
  }

  String localizedDate(AppLocalizations l10n) => reportDate == null
      ? reportDateLabel
      : DateFormat.yMd(l10n.localeName).format(reportDate!);
  String localizedReadiness(AppLocalizations l10n) => !usesGeneratedCopy
      ? readinessLabel
      : totalSolved == 0
      ? l10n.baselineGathering
      : l10n.masteryPercent((overallAccuracy * 100).toInt());
  String localizedSummary(AppLocalizations l10n) => !usesGeneratedCopy
      ? readinessSummary
      : totalSolved > 50
      ? l10n.readinessStrong(name)
      : l10n.readinessStarting(name);
}

extension DiagnosticOperationLocalizations on OperationDiagnosticViewData {
  String localizedStatus(AppLocalizations l10n) => switch (status) {
    DiagnosticOperationStatus.pending => l10n.diagnosticPending,
    DiagnosticOperationStatus.needsPractice => l10n.diagnosticNeedsPractice,
    DiagnosticOperationStatus.onTrack => l10n.diagnosticOnTrack,
    DiagnosticOperationStatus.mastered => l10n.diagnosticMastered,
  };
}
