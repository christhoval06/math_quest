import 'dart:collection';

import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';

class BadgeViewData {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;
  final BadgeTier tier;
  final bool isUnlocked;

  const BadgeViewData({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.tier,
    required this.isUnlocked,
  });

  factory BadgeViewData.fromItem(BadgeItem badge, {required bool isUnlocked}) =>
      BadgeViewData(
        id: badge.id,
        title: badge.title,
        description: badge.description,
        icon: badge.icon,
        category: badge.category,
        tier: badge.tier,
        isUnlocked: isUnlocked,
      );
}

class AllBadgesState {
  static const supportedCategories = [
    'ALL',
    'SPEED',
    'ACCURACY',
    'STREAK',
    'MILESTONE',
    'MASTERY',
    'ADVENTURE',
  ];

  final String selectedCategory;
  final List<String> categories;
  final List<BadgeViewData> allBadges;
  final List<BadgeViewData> visibleBadges;
  final int unlockedCount;
  final int totalCount;

  AllBadgesState({
    required this.selectedCategory,
    required List<String> categories,
    required List<BadgeViewData> allBadges,
    required List<BadgeViewData> visibleBadges,
    required this.unlockedCount,
    required this.totalCount,
  }) : categories = UnmodifiableListView(List.of(categories)),
       allBadges = UnmodifiableListView(List.of(allBadges)),
       visibleBadges = UnmodifiableListView(List.of(visibleBadges));

  factory AllBadgesState.fromSources({
    required UserProfile? profile,
    required List<BadgeItem> badges,
    String selectedCategory = 'ALL',
  }) {
    if (!supportedCategories.contains(selectedCategory)) {
      throw ArgumentError.value(
        selectedCategory,
        'selectedCategory',
        'Unsupported badge category',
      );
    }

    final unlockedIds = profile?.unlockedBadgeIds.toSet() ?? const <String>{};
    final mappedBadges = badges
        .map(
          (badge) => BadgeViewData.fromItem(
            badge,
            isUnlocked: unlockedIds.contains(badge.id),
          ),
        )
        .toList(growable: false);
    final visibleBadges = selectedCategory == 'ALL'
        ? mappedBadges
        : mappedBadges
              .where((badge) => badge.category == selectedCategory)
              .toList(growable: false);

    return AllBadgesState(
      selectedCategory: selectedCategory,
      categories: supportedCategories,
      allBadges: mappedBadges,
      visibleBadges: visibleBadges,
      unlockedCount: mappedBadges.where((badge) => badge.isUnlocked).length,
      totalCount: mappedBadges.length,
    );
  }
}
