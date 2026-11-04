import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/quest_stella_card.dart';
import 'package:math_quest/features/profile_and_stats/data/models/mastery_track_model.dart';
import 'package:math_quest/features/profile_and_stats/data/models/user_profile_model.dart';
import 'package:math_quest/features/profile_and_stats/data/repositories/profile_repository_impl.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/parent_diagnostic_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/trophy_room_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/explorer_banner.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/parent_diagnostic_widgets.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/trophy_stats_grid.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  late Directory directory;
  late Box settings;
  late Box<UserProfileModel> profiles;
  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('profile_progress_');
    Hive.init(directory.path);
    Hive.registerAdapter(UserProfileModelAdapter());
    Hive.registerAdapter(MasteryTrackModelAdapter());
    settings = await Hive.openBox('app_settings_box');
    profiles = await Hive.openBox<UserProfileModel>('user_profiles_box');
  });
  tearDownAll(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test(
    'completed sessions persist dated counts separately for each child',
    () async {
      await settings.clear();
      final repository = ProfileRepositoryImpl(
        profileBox: profiles,
        settingsBox: settings,
      );
      await repository.saveProfile(_profile('maya'));
      await repository.saveProfile(_profile('mia'));
      await repository.setActiveProfileId('maya');
      var now = DateTime(2026, 11, 3, 23, 59);
      final container = ProviderContainer(
        overrides: [
          profileRepositoryProvider.overrideWithValue(repository),
          practiceClockProvider.overrideWithValue(() => now),
        ],
      );
      addTearDown(container.dispose);
      final notifier = container.read(profileNotifierProvider.notifier);
      await notifier.loadProfile();
      await notifier.recordSessionProgress(
        operation: MathOperationType.addition,
        solvedCount: 4,
        correctCount: 3,
      );
      await notifier.recordSessionProgress(
        operation: MathOperationType.subtraction,
        solvedCount: 2,
        correctCount: 2,
      );
      await notifier.switchProfile('mia');
      await notifier.recordSessionProgress(
        operation: MathOperationType.addition,
        solvedCount: 3,
        correctCount: 2,
      );
      final date = '${now.year}-${now.month}-${now.day}';
      expect(settings.get('daily_solved_maya'), {'date': date, 'count': 6});
      expect(settings.get('daily_solved_mia'), {'date': date, 'count': 3});
      expect(container.read(trophyRoomProvider).todaySolved, 3);
      await notifier.switchProfile('maya');
      expect(container.read(trophyRoomProvider).todaySolved, 6);
      now = DateTime(2026, 11, 4);
      container.invalidate(trophyRoomProvider);
      expect(container.read(trophyRoomProvider).todaySolved, 0);
      await notifier.recordSessionProgress(
        operation: MathOperationType.addition,
        solvedCount: 2,
        correctCount: 2,
      );
      expect(container.read(trophyRoomProvider).todaySolved, 2);
      expect(settings.get('daily_solved_maya'), {
        'date': '2026-11-4',
        'count': 2,
      });
      await notifier.recordSessionProgress(
        operation: MathOperationType.addition,
        solvedCount: 0,
        correctCount: 0,
      );
      expect(container.read(trophyRoomProvider).todaySolved, 2);
    },
  );

  for (final resume in [false, true]) {
    testWidgets(
      'open trophy room refreshes today on ${resume ? 'resume' : 'midnight'} without navigation',
      (tester) async {
        final repository = ProfileRepositoryImpl(
          profileBox: profiles,
          settingsBox: settings,
        );
        await tester.runAsync(() async {
          await repository.saveProfile(_profile('maya'));
          await repository.setActiveProfileId('maya');
          await settings.put('daily_solved_maya', {
            'date': '2026-11-3',
            'count': 6,
          });
        });
        var now = DateTime(2026, 11, 3, 23, 59);
        final container = ProviderContainer(
          overrides: [
            profileRepositoryProvider.overrideWithValue(repository),
            practiceClockProvider.overrideWithValue(() => now),
          ],
        );
        await tester.runAsync(
          () => container.read(profileNotifierProvider.notifier).loadProfile(),
        );
        final subscription = container.listen(trophyRoomProvider, (_, _) {});
        expect(container.read(trophyRoomProvider).todaySolved, 6);
        if (resume) {
          for (final state in [
            AppLifecycleState.inactive,
            AppLifecycleState.hidden,
            AppLifecycleState.paused,
          ]) {
            tester.binding.handleAppLifecycleStateChanged(state);
          }
          now = DateTime(2026, 11, 5);
          for (final state in [
            AppLifecycleState.hidden,
            AppLifecycleState.inactive,
            AppLifecycleState.resumed,
          ]) {
            tester.binding.handleAppLifecycleStateChanged(state);
          }
          await tester.pump();
        } else {
          now = DateTime(2026, 11, 4);
          await tester.pump(const Duration(minutes: 1));
        }
        expect(container.read(trophyRoomProvider).todaySolved, 0);
        subscription.close();
        container.dispose();
      },
    );
  }

  for (final code in ['en', 'es', 'pt']) {
    testWidgets('profile name survives translation in $code', (tester) async {
      await tester.pumpWidget(
        _app(
          Column(
            children: [
              ExplorerBanner(
                profileName: 'María',
                primaryColor: Colors.blue,
                secondaryColor: Colors.orange,
                borderColor: Colors.grey,
                streakDays: 1,
                stars: 0,
                level: 1,
                onOpenTrophyRoom: () {},
              ),
              const QuestStellaCard(
                accuracyPercentage: 100,
                profileName: 'María',
              ),
              const TrophyStatsGrid(
                totalSolved: 14,
                todaySolved: 4,
                averageAccuracy: .75,
                streakDays: 1,
                unlockedBadgesCount: 0,
                totalBadgesCount: 20,
                primaryColor: Colors.blue,
              ),
            ],
          ),
          code,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('María'), findsNWidgets(2));
      expect(find.textContaining('Leo'), findsNothing);
      expect(
        find.text(
          code == 'en'
              ? '+4 today'
              : code == 'es'
              ? '+4 hoy'
              : '+4 hoje',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'coach selects measured strength and weakest practiced operation in $code',
      (tester) async {
        final profile = _profile('maya').copyWith(
          masteryTracks: {
            'addition': const MasteryTrack(
              operation: MathOperationType.addition,
              level: 1,
              title: 'Explorer',
              totalSolved: 10,
              accuracy: .9,
            ),
            'subtraction': const MasteryTrack(
              operation: MathOperationType.subtraction,
              level: 1,
              title: 'Explorer',
              totalSolved: 20,
              accuracy: .4,
            ),
            'division': const MasteryTrack(
              operation: MathOperationType.division,
              level: 1,
              title: 'Explorer',
              totalSolved: 0,
              accuracy: 1,
            ),
          },
        );
        await tester.pumpWidget(
          _app(
            SingleChildScrollView(
              child: ParentDiagnosticReport(
                state: ParentDiagnosticState.fromProfile(
                  profile: profile,
                  reportDate: DateTime(2026, 11, 3),
                ),
              ),
            ),
            code,
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.textContaining(switch (code) {
            'es' => 'SUMA: 90%',
            'pt' => 'ADIÇÃO: 90%',
            _ => 'ADDITION: 90%',
          }, findRichText: true),
          findsOneWidget,
        );
        expect(
          find.textContaining(switch (code) {
            'es' => 'Practica RESTA',
            'pt' => 'Pratique SUBTRAÇÃO',
            _ => 'Practice SUBTRACTION',
          }, findRichText: true),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'empty trophy stats do not invent daily progress or a percentile',
    (tester) async {
      await tester.pumpWidget(
        _app(
          const TrophyStatsGrid(
            totalSolved: 0,
            averageAccuracy: 0,
            streakDays: 0,
            unlockedBadgesCount: 0,
            totalBadgesCount: 20,
            primaryColor: Colors.blue,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('+0 today'), findsOneWidget);
      expect(find.text('Top 5% Learner'), findsNothing);
      expect(find.text('--%'), findsOneWidget);
    },
  );

  testWidgets('coach does not invent a named child when profile is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const QuestStellaCard(accuracyPercentage: 100)),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Leo'), findsNothing);
  });

  testWidgets(
    'empty report requests practice instead of claiming specific skills',
    (tester) async {
      await tester.pumpWidget(
        _app(
          SingleChildScrollView(
            child: ParentDiagnosticReport(
              state: ParentDiagnosticState.fromProfile(
                profile: _profile('maya'),
                reportDate: DateTime(2026, 11, 3),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Complete a practice session', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('number bonds', findRichText: true),
        findsNothing,
      );
    },
  );
}

Widget _app(Widget child, [String code = 'en']) => MaterialApp(
  locale: Locale(code),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);
UserProfile _profile(String id) => UserProfile(
  id: id,
  name: id == 'maya' ? 'Maya' : 'Mia',
  gradeLabel: 'Grade 2',
  avatar: '🚀',
  level: 1,
  starCoins: 0,
  xp: 0,
  currentStreak: 0,
  dailyGoal: 10,
  masteryTracks: const {},
  unlockedBadgeIds: const [],
);
