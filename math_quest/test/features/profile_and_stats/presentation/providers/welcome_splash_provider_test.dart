import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/domain/repositories/i_profile_repository.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/welcome_splash_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/welcome_splash_provider.dart';

void main() {
  test('maps active profile and immutable switcher rows', () {
    final source = <UserProfile>[_leo, _mia];

    final state = WelcomeSplashState.fromSources(
      activeProfile: _leo,
      profilesStatus: WelcomeProfilesStatus.data,
      profiles: source,
      profilesError: null,
    );
    source.clear();

    expect(state.activeProfileId, 'leo');
    expect(state.name, 'Leo');
    expect(state.gradeLabel, 'Grade 2');
    expect(state.avatar, '🚀');
    expect(state.starCoins, 875);
    expect(state.currentStreak, 12);
    expect(state.profiles, hasLength(2));
    expect(state.profiles.first.isActive, isTrue);
    expect(() => state.profiles.clear(), throwsUnsupportedError);
  });

  test('missing active profile uses current welcome defaults', () {
    final state = WelcomeSplashState.fromSources(
      activeProfile: null,
      profilesStatus: WelcomeProfilesStatus.data,
      profiles: const [],
      profilesError: null,
    );

    expect(state.name, 'Leo');
    expect(state.gradeLabel, 'Grade 2');
    expect(state.avatar, '👦');
    expect(state.starCoins, 1420);
    expect(state.currentStreak, 5);
  });

  test('loading and errors affect only switcher state', () {
    for (final status in [
      WelcomeProfilesStatus.loading,
      WelcomeProfilesStatus.error,
    ]) {
      final state = WelcomeSplashState.fromSources(
        activeProfile: _leo,
        profilesStatus: status,
        profiles: const [],
        profilesError: status == WelcomeProfilesStatus.error
            ? StateError('profiles failed')
            : null,
      );

      expect(state.name, 'Leo');
      expect(state.starCoins, 875);
      expect(state.profilesStatus, status);
      expect(
        state.profilesErrorMessage,
        status == WelcomeProfilesStatus.error
            ? contains('profiles failed')
            : null,
      );
    }
  });

  test('only lists below three profiles can add another profile', () {
    final two = WelcomeSplashState.fromSources(
      activeProfile: _leo,
      profilesStatus: WelcomeProfilesStatus.data,
      profiles: const [_leo, _mia],
      profilesError: null,
    );
    final three = WelcomeSplashState.fromSources(
      activeProfile: _leo,
      profilesStatus: WelcomeProfilesStatus.data,
      profiles: const [_leo, _mia, _ava],
      profilesError: null,
    );

    expect(two.canAddProfile, isTrue);
    expect(three.canAddProfile, isFalse);
  });

  test(
    'provider reflects profile refresh and active profile changes',
    () async {
      final repository = _FakeProfileRepository([_leo, _mia], activeId: 'leo');
      final container = ProviderContainer(
        overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(profileNotifierProvider.notifier).loadProfile();
      await container.read(allProfilesProvider.future);
      expect(container.read(welcomeSplashProvider).name, 'Leo');
      expect(container.read(welcomeSplashProvider).profiles, hasLength(2));

      repository.profiles = [_leo.copyWith(starCoins: 999), _mia];
      await container.read(profileNotifierProvider.notifier).loadProfile();
      await container.read(allProfilesProvider.future);
      expect(container.read(welcomeSplashProvider).starCoins, 999);

      await container
          .read(profileNotifierProvider.notifier)
          .switchProfile('mia');
      await container.read(allProfilesProvider.future);
      final switched = container.read(welcomeSplashProvider);
      expect(switched.name, 'Mia');
      expect(
        switched.profiles.singleWhere((p) => p.id == 'mia').isActive,
        isTrue,
      );
    },
  );
}

class _FakeProfileRepository implements IProfileRepository {
  _FakeProfileRepository(this.profiles, {required this.activeId});

  List<UserProfile> profiles;
  String activeId;

  @override
  Future<UserProfile?> getActiveProfile() async {
    return profiles.where((profile) => profile.id == activeId).firstOrNull;
  }

  @override
  Future<List<UserProfile>> getAllProfiles() async => [...profiles];

  @override
  Future<void> saveProfile(UserProfile profile) async {}

  @override
  Future<void> setActiveProfileId(String id) async {
    activeId = id;
  }
}

const _leo = UserProfile(
  id: 'leo',
  name: 'Leo',
  gradeLabel: 'Grade 2',
  avatar: '🚀',
  level: 7,
  starCoins: 875,
  xp: 500,
  currentStreak: 12,
  dailyGoal: 10,
  masteryTracks: {},
  unlockedBadgeIds: [],
);

const _mia = UserProfile(
  id: 'mia',
  name: 'Mia',
  gradeLabel: 'Grade 1',
  avatar: '🦄',
  level: 4,
  starCoins: 320,
  xp: 200,
  currentStreak: 3,
  dailyGoal: 10,
  masteryTracks: {},
  unlockedBadgeIds: [],
);

const _ava = UserProfile(
  id: 'ava',
  name: 'Ava',
  gradeLabel: 'Grade 3',
  avatar: '⭐',
  level: 5,
  starCoins: 450,
  xp: 300,
  currentStreak: 4,
  dailyGoal: 10,
  masteryTracks: {},
  unlockedBadgeIds: [],
);
