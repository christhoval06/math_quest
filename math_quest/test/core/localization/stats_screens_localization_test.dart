import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/controllers/all_badges_controller.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/parent_diagnostic_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/all_badges_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/parent_diagnostic_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/trophy_room_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/all_badges_screen.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/parent_diagnostic_screen.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/trophy_room_screen.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/screen_time_lock_dialog.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  late Directory directory;
  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('stats_localization_');
    Hive.init(directory.path);
    await Hive.openBox('app_settings_box');
  });
  tearDownAll(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });
  for (final code in ['en', 'es', 'pt']) {
    testWidgets('empty statistics show translated guidance in $code', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            trophyRoomProvider.overrideWithValue(
              const TrophyRoomState(
                totalSolved: 0,
                averageAccuracy: 0,
                streakDays: 0,
                starCoins: 0,
                unlockedBadgeIds: [],
                totalBadgesCount: 20,
                weeklyData: {},
                masteryTracks: [],
                profile: null,
              ),
            ),
          ],
          child: _app(code, const TrophyRoomScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(switch (code) {
          'es' => 'Aún no hay práctica',
          'pt' => 'Ainda sem prática',
          _ => 'No practice yet',
        }),
        findsOneWidget,
      );
      expect(
        find.text(switch (code) {
          'es' => '🎯 ¡Meta cumplida!',
          'pt' => '🎯 Meta atingida!',
          _ => '🎯 Goal Met!',
        }),
        findsNothing,
      );
      expect(
        find.text(switch (code) {
          'es' => 'Comienza a practicar para ver tu progreso.',
          'pt' => 'Comece a praticar para ver seu progresso.',
          _ => 'Start practicing to see your mastery progress.',
        }),
        findsOneWidget,
      );
      await tester.pumpWidget(
        ProviderScope(
          key: const ValueKey('empty-badges'),
          overrides: [
            allBadgesProvider.overrideWith(
              (ref) => AllBadgesController(profile: null, badges: []),
            ),
          ],
          child: _app(code, const AllBadgesScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(switch (code) {
          'es' => 'Aún no hay insignias en esta categoría.',
          'pt' => 'Ainda não há emblemas nesta categoria.',
          _ => 'No badges in this category yet.',
        }),
        findsOneWidget,
      );
      await tester.pumpWidget(
        ProviderScope(
          key: const ValueKey('empty-report'),
          overrides: [
            parentDiagnosticProvider.overrideWithValue(
              ParentDiagnosticState.fromProfile(
                profile: null,
                reportDate: DateTime(2026, 11, 3),
              ),
            ),
          ],
          child: _app(code, const ParentDiagnosticScreen()),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(switch (code) {
          'es' => 'Aún no hay datos de operaciones.',
          'pt' => 'Ainda não há dados de operações.',
          _ => 'No operation data yet.',
        }),
        findsOneWidget,
      );
    });

    testWidgets(
      'trophy report, badge gallery and diagnostics fit a phone in $code',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final profile = _profile;
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              trophyRoomProvider.overrideWithValue(
                TrophyRoomState(
                  totalSolved: 155,
                  averageAccuracy: .85,
                  streakDays: 7,
                  starCoins: 500,
                  unlockedBadgeIds: profile.unlockedBadgeIds,
                  totalBadgesCount: 20,
                  weeklyData: const {'Mon': 10, 'Tue': 25},
                  masteryTracks: profile.masteryTracks.values.toList(),
                  profile: profile,
                ),
              ),
            ],
            child: _app(code, const TrophyRoomScreen()),
          ),
        );
        await tester.pumpAndSettle();
        for (final paragraph in tester.renderObjectList<RenderParagraph>(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.byType(RichText),
          ),
        )) {
          expect(
            paragraph.didExceedMaxLines,
            isFalse,
            reason: paragraph.text.toPlainText(),
          );
        }
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -600),
        );
        await tester.pumpAndSettle();
        final controller = AllBadgesController(
          profile: profile,
          badges: BadgeItem.allBadges,
        );
        await tester.pumpWidget(
          ProviderScope(
            key: const ValueKey('badges'),
            overrides: [allBadgesProvider.overrideWith((ref) => controller)],
            child: _app(code, const AllBadgesScreen()),
          ),
        );
        await tester.pumpAndSettle();
        final speed = switch (code) {
          'es' => 'VELOCIDAD',
          'pt' => 'VELOCIDADE',
          _ => 'SPEED',
        };
        await tester.tap(
          find.descendant(
            of: find.byType(ChoiceChip),
            matching: find.text(speed),
          ),
        );
        await tester.pumpAndSettle();
        expect(controller.state.selectedCategory, 'SPEED');
        final badge = switch (code) {
          'es' => 'Contador veloz',
          'pt' => 'Contador veloz',
          _ => 'Speed Counter',
        };
        await tester.tap(find.text(badge));
        await tester.pumpAndSettle();
        expect(find.byType(BottomSheet), findsOneWidget);
        await tester.tap(
          find.text(switch (code) {
            'es' => '¡Entendido!',
            'pt' => 'Entendi!',
            _ => 'Got it!',
          }),
        );
        await tester.pumpAndSettle();
        await tester.pumpWidget(
          ProviderScope(
            key: const ValueKey('report'),
            overrides: [
              parentDiagnosticProvider.overrideWithValue(
                ParentDiagnosticState.fromProfile(
                  profile: profile,
                  reportDate: DateTime(2026, 11, 3),
                ),
              ),
            ],
            child: _app(code, const ParentDiagnosticScreen()),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.textContaining(switch (code) {
            'es' => 'Fecha del informe: 3/11/2026',
            'pt' => 'Data do relatório: 03/11/2026',
            _ => 'Report Date: 11/3/2026',
          }),
          findsOneWidget,
        );
        expect(
          find.textContaining('Kindergarten'),
          code == 'en' ? findsOneWidget : findsNothing,
        );
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -600),
        );
        await tester.pumpAndSettle();
      },
    );
    testWidgets(
      'screen time lock is localized and unlock callback works in $code',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var requests = 0;
        await tester.pumpWidget(
          _app(
            code,
            ScreenTimeLockDialog(
              onParentUnlock: () async {
                requests++;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(switch (code) {
            'es' => 'Desbloqueo parental 🛡️',
            'pt' => 'Desbloqueio dos pais 🛡️',
            _ => 'Parent Unlock 🛡️',
          }),
        );
        await tester.pumpAndSettle();
        expect(requests, 1);
      },
    );
  }
}

Widget _app(String code, Widget child) => MaterialApp(
  locale: Locale(code),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);
final _profile = UserProfile(
  id: 'child',
  name: 'María',
  gradeLabel: 'Kindergarten',
  avatar: '🚀',
  level: 4,
  starCoins: 500,
  xp: 700,
  currentStreak: 7,
  dailyGoal: 20,
  unlockedBadgeIds: const ['speed_counter', 'clean_slate'],
  masteryTracks: {
    for (final operation in MathOperationType.values)
      operation.name: MasteryTrack(
        operation: operation,
        level: 3,
        title: 'Math Adventurer',
        totalSolved: operation.index * 25,
        accuracy: .65 + operation.index * .1,
      ),
  },
);
