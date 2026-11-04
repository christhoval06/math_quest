import 'package:math_quest/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart';
import 'package:math_quest/l10n/app_localizations.dart';

// Catalog IDs remain stable when the app language changes. Custom content keeps
// its supplied copy when no built-in translation is available.
String localizedMissionBadge(
  AppLocalizations l10n,
  String badgeId,
  String fallback,
) => switch (badgeId) {
  'space_detective' => l10n.spaceDetectiveBadge,
  'balloon_popper' => l10n.balloonPopperBadge,
  'lightning_math' => l10n.lightningBoosterBadge,
  'times_master' => l10n.pizzaMasterBadge,
  _ => fallback,
};

extension DailyMissionLocalizations on DailyMissionViewData {
  String localizedTitle(AppLocalizations l10n) => switch (missionId) {
    'mission_addition' => l10n.dailyAdditionTitle(targetCount),
    'mission_subtraction' => l10n.dailySubtractionTitle(targetCount),
    'mission_multiplication' => l10n.dailyMultiplicationTitle(targetCount),
    'mission_division' => l10n.dailyDivisionTitle(targetCount),
    _ => title,
  };

  String localizedBadge(AppLocalizations l10n) =>
      localizedMissionBadge(l10n, badgeRewardId, badgeRewardTitle);
}

extension SuperpowerTipLocalizations on SuperpowerTipViewData {
  String localizedTitle(AppLocalizations l10n) => switch (challengeId) {
    'doubles_plus_one' => l10n.tipDoublesTitle,
    'make_a_ten' => l10n.tipMakeTenTitle,
    'subtract_to_ten' => l10n.tipSubtractTenTitle,
    'times_five_half_ten' => l10n.tipTimesFiveTitle,
    'nine_times_magic' => l10n.tipNinesTitle,
    'halving_division' => l10n.tipHalvingTitle,
    'zero_hero' => l10n.tipZeroTitle,
    _ => title,
  };

  String localizedDescription(AppLocalizations l10n) => switch (challengeId) {
    'doubles_plus_one' => l10n.tipDoublesDescription,
    'make_a_ten' => l10n.tipMakeTenDescription,
    'subtract_to_ten' => l10n.tipSubtractTenDescription,
    'times_five_half_ten' => l10n.tipTimesFiveDescription,
    'nine_times_magic' => l10n.tipNinesDescription,
    'halving_division' => l10n.tipHalvingDescription,
    'zero_hero' => l10n.tipZeroDescription,
    _ => description,
  };
}
