import 'dart:collection';

import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';

enum WelcomeProfilesStatus { loading, data, error }

class WelcomeProfileViewData {
  final String id;
  final String name;
  final String gradeLabel;
  final String avatar;
  final int starCoins;
  final bool isActive;

  const WelcomeProfileViewData({
    required this.id,
    required this.name,
    required this.gradeLabel,
    required this.avatar,
    required this.starCoins,
    required this.isActive,
  });
}

class WelcomeSplashState {
  final String? activeProfileId;
  final String name;
  final String gradeLabel;
  final String avatar;
  final int starCoins;
  final int currentStreak;
  final WelcomeProfilesStatus profilesStatus;
  final List<WelcomeProfileViewData> profiles;
  final String? profilesErrorMessage;
  final bool canAddProfile;

  WelcomeSplashState({
    required this.activeProfileId,
    required this.name,
    required this.gradeLabel,
    required this.avatar,
    required this.starCoins,
    required this.currentStreak,
    required this.profilesStatus,
    required List<WelcomeProfileViewData> profiles,
    required this.profilesErrorMessage,
    required this.canAddProfile,
  }) : profiles = UnmodifiableListView(List.of(profiles));

  factory WelcomeSplashState.fromSources({
    required UserProfile? activeProfile,
    required WelcomeProfilesStatus profilesStatus,
    required List<UserProfile> profiles,
    required Object? profilesError,
  }) {
    return WelcomeSplashState(
      activeProfileId: activeProfile?.id,
      name: activeProfile?.name ?? 'Leo',
      gradeLabel: activeProfile?.gradeLabel ?? 'Grade 2',
      avatar: activeProfile?.avatar ?? '👦',
      starCoins: activeProfile?.starCoins ?? 1420,
      currentStreak: activeProfile?.currentStreak ?? 5,
      profilesStatus: profilesStatus,
      profiles: profiles
          .map(
            (profile) => WelcomeProfileViewData(
              id: profile.id,
              name: profile.name,
              gradeLabel: profile.gradeLabel,
              avatar: profile.avatar,
              starCoins: profile.starCoins,
              isActive: profile.id == activeProfile?.id,
            ),
          )
          .toList(growable: false),
      profilesErrorMessage: profilesError?.toString(),
      canAddProfile: profiles.length < 3,
    );
  }
}
