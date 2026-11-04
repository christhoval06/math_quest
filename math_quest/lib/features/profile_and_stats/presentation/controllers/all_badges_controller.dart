import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/all_badges_state.dart';

class AllBadgesController extends StateNotifier<AllBadgesState> {
  final List<BadgeItem> _badges;
  UserProfile? _profile;

  AllBadgesController({
    required UserProfile? profile,
    required List<BadgeItem> badges,
  }) : _badges = List.of(badges),
       _profile = profile,
       super(AllBadgesState.fromSources(profile: profile, badges: badges));

  void selectCategory(String category) {
    if (!state.categories.contains(category)) {
      throw ArgumentError.value(
        category,
        'category',
        'Unsupported badge category',
      );
    }
    if (category == state.selectedCategory) return;

    state = AllBadgesState.fromSources(
      profile: _profile,
      badges: _badges,
      selectedCategory: category,
    );
  }

  void updateProfile(UserProfile? profile) {
    _profile = profile;
    state = AllBadgesState.fromSources(
      profile: profile,
      badges: _badges,
      selectedCategory: state.selectedCategory,
    );
  }
}
