import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/all_badges_controller.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/all_badges_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';

final allBadgesProvider =
    StateNotifierProvider.autoDispose<AllBadgesController, AllBadgesState>((
      ref,
    ) {
      final controller = AllBadgesController(
        profile: ref.read(profileNotifierProvider),
        badges: BadgeItem.allBadges,
      );
      ref.listen<UserProfile?>(profileNotifierProvider, (_, profile) {
        controller.updateProfile(profile);
      });
      return controller;
    });
