import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/all_badges_controller.dart';

void main() {
  test('maps badge unlocks and defaults to the complete collection', () {
    final controller = AllBadgesController(
      profile: _profileWithBadges(['speed']),
      badges: _badges,
    );

    expect(controller.state.selectedCategory, 'ALL');
    expect(controller.state.unlockedCount, 1);
    expect(controller.state.totalCount, 3);
    expect(controller.state.visibleBadges.map((badge) => badge.id), [
      'speed',
      'accuracy',
      'adventure',
    ]);
    expect(controller.state.visibleBadges.first.isUnlocked, isTrue);
    expect(controller.state.visibleBadges[1].isUnlocked, isFalse);
  });

  test('selectCategory filters badges and rejects unsupported values', () {
    final controller = AllBadgesController(profile: null, badges: _badges);

    controller.selectCategory('ACCURACY');

    expect(controller.state.selectedCategory, 'ACCURACY');
    expect(controller.state.visibleBadges.single.id, 'accuracy');
    expect(() => controller.selectCategory('UNKNOWN'), throwsArgumentError);
    expect(controller.state.selectedCategory, 'ACCURACY');
  });

  test('profile refresh preserves selection and updates unlock state', () {
    final controller = AllBadgesController(profile: null, badges: _badges);
    controller.selectCategory('ADVENTURE');

    controller.updateProfile(_profileWithBadges(['adventure']));

    expect(controller.state.selectedCategory, 'ADVENTURE');
    expect(controller.state.visibleBadges.single.id, 'adventure');
    expect(controller.state.visibleBadges.single.isUnlocked, isTrue);
    expect(controller.state.unlockedCount, 1);
  });

  test('state badge and category collections are immutable snapshots', () {
    final mutableBadges = List<BadgeItem>.of(_badges);
    final controller = AllBadgesController(
      profile: null,
      badges: mutableBadges,
    );
    mutableBadges.clear();

    expect(controller.state.totalCount, 3);
    expect(
      () => controller.state.visibleBadges.add(
        controller.state.visibleBadges.first,
      ),
      throwsUnsupportedError,
    );
    expect(
      () => controller.state.categories.add('OTHER'),
      throwsUnsupportedError,
    );
  });
}

UserProfile _profileWithBadges(List<String> badgeIds) => UserProfile(
  id: 'profile-1',
  name: 'Ana',
  gradeLabel: 'Grade 2',
  avatar: '🚀',
  level: 1,
  starCoins: 100,
  xp: 0,
  currentStreak: 1,
  dailyGoal: 10,
  masteryTracks: const {},
  unlockedBadgeIds: badgeIds,
);

final _badges = [
  _badge('speed', 'SPEED'),
  _badge('accuracy', 'ACCURACY'),
  _badge('adventure', 'ADVENTURE'),
];

BadgeItem _badge(String id, String category) => BadgeItem(
  id: id,
  title: '$category badge',
  description: 'Earn the $category badge.',
  icon: '🏅',
  category: category,
  tier: BadgeTier.bronze,
  isUnlockConditionMet: (_) => false,
);
