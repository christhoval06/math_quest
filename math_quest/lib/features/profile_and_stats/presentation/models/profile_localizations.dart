import 'package:math_quest/features/profile_and_stats/presentation/models/onboarding_state.dart';
import 'package:math_quest/l10n/app_localizations.dart';

// Keep persisted grade values independent of the display language.
String localizedProfileGrade(AppLocalizations l10n, String grade) =>
    switch (grade) {
      'Kindergarten' => l10n.gradeKindergarten,
      'Pre-K' => l10n.gradePreK,
      'Grade 1' => l10n.gradeOne,
      'Grade 2' => l10n.gradeTwo,
      'Grade 3+' => l10n.gradeThreePlus,
      _ => grade,
    };

String localizedProfileGradeAge(AppLocalizations l10n, String age) =>
    switch (age) {
      'Age 4-5' => l10n.gradeAgeRange(4, 5),
      'Age 6-7' => l10n.gradeAgeRange(6, 7),
      'Age 7-8' => l10n.gradeAgeRange(7, 8),
      'Age 8-10' => l10n.gradeAgeRange(8, 10),
      _ => age,
    };

extension OnboardingLocalizations on OnboardingSlideViewData {
  String localizedTitle(AppLocalizations l10n) => switch (localizationId) {
    'welcome' => l10n.onboardingWelcomeTitle,
    'blocks' => l10n.onboardingBlocksTitle,
    'adventure' => l10n.onboardingAdventureTitle,
    _ => title,
  };
  String localizedDescription(AppLocalizations l10n) =>
      switch (localizationId) {
        'welcome' => l10n.onboardingWelcomeDescription,
        'blocks' => l10n.onboardingBlocksDescription,
        'adventure' => l10n.onboardingAdventureDescription,
        _ => description,
      };
}
