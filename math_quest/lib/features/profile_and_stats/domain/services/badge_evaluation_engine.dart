import '../entities/badge_item.dart';

class BadgeEvaluationEngine {
  /// Evaluates all badges and returns the ones whose condition is met!
  static List<BadgeItem> evaluateSession(BadgeContext context) {
    final alreadyUnlocked = context.profile.unlockedBadgeIds.toSet();

    return BadgeItem.allBadges.where((badge) {
      // Must not be already unlocked, AND its own condition must be met
      return !alreadyUnlocked.contains(badge.id) &&
          badge.isUnlockConditionMet(context);
    }).toList();
  }
}
