import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/welcome_splash_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_brand_card.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_launch_button.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_loading_progress.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_profile_pill.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_profile_switcher.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_status_bar.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  test('loading status uses the existing exact boundaries', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(welcomeLoadingStatus(0, l10n), 'Charging math boosters...');
    expect(welcomeLoadingStatus(0.449, l10n), 'Charging math boosters...');
    expect(welcomeLoadingStatus(0.45, l10n), 'Warming up superpowers...');
    expect(welcomeLoadingStatus(0.899, l10n), 'Warming up superpowers...');
    expect(welcomeLoadingStatus(0.90, l10n), 'Ready for Adventure! 🚀');
    expect(welcomeLoadingStatus(1, l10n), 'Ready for Adventure! 🚀');
  });

  testWidgets('status bar renders counters and profile callback', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: WelcomeStatusBar(
            currentStreak: 12,
            starCoins: 875,
            avatar: '🚀',
            name: 'Leo',
            onProfileTap: () => taps++,
          ),
        ),
      ),
    );

    expect(find.text('12 Day Streak!'), findsOneWidget);
    expect(find.text('875'), findsOneWidget);
    await tester.tap(find.text('Hi Leo!'));
    expect(taps, 1);
  });

  testWidgets('brand card displays the fallback and float offset', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: WelcomeBrandCard(
            floatOffset: 4,
            logoAssetPath: 'assets/images/branding/missing.png',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('STAR MATH'), findsOneWidget);
    expect(find.text('⭐'), findsOneWidget);
    final transform = tester.widget<Transform>(
      find.byKey(const Key('welcome-brand-float')),
    );
    expect(transform.transform.getTranslation().y, 4);
  });

  testWidgets('loading progress renders status and percentage', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: WelcomeLoadingProgress(progress: 0.45)),
      ),
    );

    expect(find.text('Warming up superpowers...'), findsOneWidget);
    expect(find.text('45%'), findsOneWidget);
  });

  testWidgets('launch button and profile pill report taps', (tester) async {
    var launchCount = 0;
    var profileCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            children: [
              WelcomeLaunchButton(onPressed: () => launchCount++),
              WelcomeProfilePill(
                avatar: '🚀',
                name: 'Leo',
                gradeLabel: 'Grade 2',
                onTap: () => profileCount++,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tap to Start Adventure!'));
    await tester.tap(find.text('Playing as: Leo (Grade 2)'));
    expect(launchCount, 1);
    expect(profileCount, 1);
  });

  testWidgets('profile switcher renders loading error and empty states', (
    tester,
  ) async {
    for (final status in WelcomeProfilesStatus.values) {
      if (status == WelcomeProfilesStatus.data) continue;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: WelcomeProfileSwitcher(
              state: _state(status: status),
              onProfileSelected: (_) async {},
              onAddProfile: () {},
            ),
          ),
        ),
      );
      expect(
        find.byKey(Key('welcome-profiles-${status.name}')),
        findsOneWidget,
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: WelcomeProfileSwitcher(
            state: _state(),
            onProfileSelected: (_) async {},
            onAddProfile: () {},
          ),
        ),
      ),
    );
    expect(find.byKey(const Key('welcome-profiles-empty')), findsOneWidget);
  });

  testWidgets('profile switcher reports rows and add action until full', (
    tester,
  ) async {
    String? selected;
    var addCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: WelcomeProfileSwitcher(
            state: _state(profiles: _profiles, canAdd: true),
            onProfileSelected: (id) async => selected = id,
            onAddProfile: () => addCount++,
          ),
        ),
      ),
    );

    expect(find.text('Leo'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    await tester.tap(find.text('Mia'));
    await tester.pump();
    expect(selected, 'mia');
    await tester.tap(find.text('Add New Child Profile'));
    expect(addCount, 1);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: WelcomeProfileSwitcher(
            state: _state(profiles: _profiles, canAdd: false),
            onProfileSelected: (_) async {},
            onAddProfile: () {},
          ),
        ),
      ),
    );
    expect(find.text('Add New Child Profile'), findsNothing);
  });
}

WelcomeSplashState _state({
  WelcomeProfilesStatus status = WelcomeProfilesStatus.data,
  List<WelcomeProfileViewData> profiles = const [],
  bool canAdd = true,
}) {
  return WelcomeSplashState(
    activeProfileId: 'leo',
    name: 'Leo',
    gradeLabel: 'Grade 2',
    avatar: '🚀',
    starCoins: 875,
    currentStreak: 12,
    profilesStatus: status,
    profiles: profiles,
    profilesErrorMessage: status == WelcomeProfilesStatus.error
        ? 'profiles failed'
        : null,
    canAddProfile: canAdd,
  );
}

const _profiles = [
  WelcomeProfileViewData(
    id: 'leo',
    name: 'Leo',
    gradeLabel: 'Grade 2',
    avatar: '🚀',
    starCoins: 875,
    isActive: true,
  ),
  WelcomeProfileViewData(
    id: 'mia',
    name: 'Mia',
    gradeLabel: 'Grade 1',
    avatar: '🦄',
    starCoins: 320,
    isActive: false,
  ),
];
