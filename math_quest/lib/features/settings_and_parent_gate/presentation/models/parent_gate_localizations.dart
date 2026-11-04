import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_config.dart';

extension ParentGateLocalizations on ParentGateConfig {
  String localizedTitle(AppLocalizations l10n) => switch (localizationId) {
    'parentSettings' => l10n.gateSettingsTitle,
    'screenLimit' => l10n.gateScreenLimitTitle,
    'learningGoal' => l10n.gateLearningTitle,
    'resetProgress' => l10n.gateResetTitle,
    'extraTime' => l10n.gateExtraTimeTitle,
    _ => title,
  };
  String localizedDescription(AppLocalizations l10n) =>
      switch (localizationId) {
        'parentSettings' => l10n.gateSettingsDescription,
        'screenLimit' => l10n.gateScreenLimitDescription,
        'learningGoal' => l10n.gateLearningDescription,
        'resetProgress' => l10n.gateResetDescription,
        'extraTime' => l10n.gateExtraTimeDescription,
        _ => description,
      };
  String localizedAction(AppLocalizations l10n) => switch (localizationId) {
    'parentSettings' => l10n.unlockSettings,
    'screenLimit' || 'learningGoal' || 'resetProgress' => l10n.continueBtn,
    'extraTime' => l10n.addFifteenMinutes,
    _ => actionLabel,
  };
}

String? localizedParentGateError(AppLocalizations l10n, String? error) =>
    switch (error) {
      'Enter an answer to continue.' => l10n.gateAnswerRequired,
      'Use numbers only.' => l10n.gateNumbersOnly,
      'Not quite. Please try again.' => l10n.gateAnswerIncorrect,
      _ => error,
    };
