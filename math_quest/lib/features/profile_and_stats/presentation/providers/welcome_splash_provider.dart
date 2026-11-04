import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/core/audio/sound_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/welcome_splash_controller.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/welcome_splash_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';

final welcomeSplashProvider = Provider<WelcomeSplashState>((ref) {
  final activeProfile = ref.watch(profileNotifierProvider);
  final profiles = ref.watch(allProfilesProvider);

  return profiles.when(
    data: (value) => WelcomeSplashState.fromSources(
      activeProfile: activeProfile,
      profilesStatus: WelcomeProfilesStatus.data,
      profiles: value,
      profilesError: null,
    ),
    loading: () => WelcomeSplashState.fromSources(
      activeProfile: activeProfile,
      profilesStatus: WelcomeProfilesStatus.loading,
      profiles: const [],
      profilesError: null,
    ),
    error: (error, _) => WelcomeSplashState.fromSources(
      activeProfile: activeProfile,
      profilesStatus: WelcomeProfilesStatus.error,
      profiles: const [],
      profilesError: error,
    ),
  );
});

final welcomeSplashControllerProvider = Provider<WelcomeSplashController>((
  ref,
) {
  return WelcomeSplashController(
    readActiveProfileId: () => ref.read(profileNotifierProvider)?.id,
    playTapAction: ref.read(soundServiceProvider).playTap,
    switchProfileAction: (profileId) =>
        ref.read(profileNotifierProvider.notifier).switchProfile(profileId),
  );
});
