class MasteryTier {
  final int level;
  final String title;
  final String badgeIcon;
  final int requiredSolved;
  final int requiredXp;
  final String unlockPerk;

  const MasteryTier({
    required this.level,
    required this.title,
    required this.badgeIcon,
    required this.requiredSolved,
    required this.requiredXp,
    required this.unlockPerk,
  });
}

class MasteryProgressionEngine {
  /// 🌟 10 EXPANDABLE MASTERY TIERS
  static const List<MasteryTier> tiers = [
    MasteryTier(
      level: 1,
      title: 'Sprout Explorer',
      badgeIcon: '🌱',
      requiredSolved: 0,
      requiredXp: 0,
      unlockPerk: 'Starter World',
    ),
    MasteryTier(
      level: 2,
      title: 'Number Cadet',
      badgeIcon: '🚀',
      requiredSolved: 20,
      requiredXp: 200,
      unlockPerk: 'Speed Timer Options',
    ),
    MasteryTier(
      level: 3,
      title: 'Math Adventurer',
      badgeIcon: '🧭',
      requiredSolved: 50,
      requiredXp: 500,
      unlockPerk: 'Buddy Duel Mode',
    ),
    MasteryTier(
      level: 4,
      title: 'Rising Star',
      badgeIcon: '⭐',
      requiredSolved: 100,
      requiredXp: 1000,
      unlockPerk: 'Candy Land Theme',
    ),
    MasteryTier(
      level: 5,
      title: 'Number Wizard',
      badgeIcon: '🧙',
      requiredSolved: 175,
      requiredXp: 1800,
      unlockPerk: 'Dino Math Theme',
    ),
    MasteryTier(
      level: 6,
      title: 'Math Superhero',
      badgeIcon: '🦸',
      requiredSolved: 275,
      requiredXp: 2800,
      unlockPerk: 'Underwater Coral Theme',
    ),
    MasteryTier(
      level: 7,
      title: 'Cosmic Champion',
      badgeIcon: '🌌',
      requiredSolved: 400,
      requiredXp: 4000,
      unlockPerk: 'Silver Avatar Frame',
    ),
    MasteryTier(
      level: 8,
      title: 'Mastermind',
      badgeIcon: '🧠',
      requiredSolved: 550,
      requiredXp: 5500,
      unlockPerk: 'Galaxy Quest Pro Mode',
    ),
    MasteryTier(
      level: 9,
      title: 'Grand Titan',
      badgeIcon: '⚡',
      requiredSolved: 750,
      requiredXp: 7500,
      unlockPerk: 'Gold Avatar Crown',
    ),
    MasteryTier(
      level: 10,
      title: 'Supreme Math Legend!',
      badgeIcon: '👑',
      requiredSolved: 1000,
      requiredXp: 10000,
      unlockPerk: 'Cosmic Legend Trophy',
    ),
  ];

  /// Get the active tier based on total questions solved (for operations +, -, ×, ÷)
  static MasteryTier getTierForSolvedCount(int solvedCount) {
    for (int i = tiers.length - 1; i >= 0; i--) {
      if (solvedCount >= tiers[i].requiredSolved) {
        return tiers[i];
      }
    }
    return tiers.first;
  }

  /// Get the active tier based on lifetime Math XP (for the child's Hero Profile)
  static MasteryTier getTierForXp(int xp) {
    for (int i = tiers.length - 1; i >= 0; i--) {
      if (xp >= tiers[i].requiredXp) {
        return tiers[i];
      }
    }
    return tiers.first;
  }

  /// Calculates progress fraction (0.0 to 1.0) towards the NEXT level
  static double getProgressToNextLevel(int currentSolved) {
    final currentTier = getTierForSolvedCount(currentSolved);
    if (currentTier.level >= tiers.last.level) return 1.0; // Max level reached!

    final nextTier = tiers[currentTier.level]; // Next tier
    final solvedInCurrentTier = currentSolved - currentTier.requiredSolved;
    final totalNeededForNext =
        nextTier.requiredSolved - currentTier.requiredSolved;

    if (totalNeededForNext <= 0) return 1.0;
    return (solvedInCurrentTier / totalNeededForNext).clamp(0.0, 1.0);
  }

  /// Returns how many questions remain until leveling up
  static int getQuestionsRemainingForNextLevel(int currentSolved) {
    final currentTier = getTierForSolvedCount(currentSolved);
    if (currentTier.level >= tiers.last.level) return 0;

    final nextTier = tiers[currentTier.level];
    return (nextTier.requiredSolved - currentSolved).clamp(0, 9999);
  }
}
