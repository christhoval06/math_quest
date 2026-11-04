import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/domain/entities/superpower_challenge.dart';
import 'package:math_quest/features/math_engine/presentation/providers/challenge_engine_provider.dart';
import 'package:math_quest/features/mission_setup/domain/entities/daily_mission.dart';
import 'package:math_quest/features/mission_setup/presentation/providers/daily_mission_provider.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_lab_header.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_operation_grid.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_question_selector.dart';
import 'package:math_quest/features/mission_setup/presentation/widgets/mission_timer_selector.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/daily_mission_card.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/game_modes_section.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/superpower_tip_card.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('dashboard modes follow locale changes and retain navigation', (
    tester,
  ) async {
    var quickPlayCount = 0;
    final locale = ValueNotifier(const Locale('en'));
    addTearDown(locale.dispose);
    await tester.pumpWidget(
      ValueListenableBuilder<Locale>(
        valueListenable: locale,
        builder: (context, value, _) => _app(
          value,
          GameModesSection(
            onQuickPlay: () => quickPlayCount++,
            onPracticeArena: () {},
            onAdventureIsland: () {},
            onBuddyChallenge: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Quick Play'), findsOneWidget);

    locale.value = const Locale('es');
    await tester.pumpAndSettle();
    expect(find.text('Juego Rápido'), findsOneWidget);
    expect(find.text('Quick Play'), findsNothing);
    await tester.tap(find.text('Juego Rápido'));
    expect(quickPlayCount, 1);

    locale.value = const Locale('pt');
    await tester.pumpAndSettle();
    expect(find.text('Jogo Rápido'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final code in ['es', 'pt']) {
    testWidgets(
      'rotating dashboard catalog renders translated content in $code',
      (tester) async {
        final challenges = SuperpowerChallenge.catalog;
        for (final mission in DailyMission.catalog) {
          final state = HomeDashboardState.fromSources(
            profile: null,
            missionState: DailyMissionState(
              mission: mission,
              currentProgress: 3,
            ),
            challengeState: ChallengeEngineState(
              todaysChallenge: challenges.first,
            ),
          );
          await tester.pumpWidget(
            _app(
              Locale(code),
              DailyMissionCard(
                data: state.mission,
                primaryColor: Colors.blue,
                onClaim: () async {},
                onContinue: () {},
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text(mission.title), findsNothing, reason: mission.id);
          expect(
            find.textContaining(mission.badgeRewardTitle),
            findsNothing,
            reason: mission.badgeRewardId,
          );
          expect(
            find.text(
              code == 'es' ? '3 de 10 completados' : '3 de 10 concluídos',
            ),
            findsOneWidget,
          );
        }
        for (final challenge in challenges) {
          final state = HomeDashboardState.fromSources(
            profile: null,
            missionState: DailyMissionState(
              mission: DailyMission.catalog.first,
              currentProgress: 0,
            ),
            challengeState: ChallengeEngineState(todaysChallenge: challenge),
          );
          await tester.pumpWidget(
            _app(
              Locale(code),
              SuperpowerTipCard(data: state.tip, onLaunch: () {}),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            find.text(challenge.title),
            findsNothing,
            reason: challenge.id,
          );
          expect(
            find.text(challenge.description),
            findsNothing,
            reason: challenge.id,
          );
        }
      },
    );

    testWidgets('mission setup in $code preserves operation and timer values', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      MathOperation? operation;
      int? seconds;
      await tester.pumpWidget(
        _app(
          Locale(code),
          Column(
            children: [
              const MissionLabHeader(),
              MissionOperationGrid(
                selectedOperations: const {MathOperation.addition},
                onToggle: (value) => operation = value,
              ),
              MissionTimerSelector(
                selectedSeconds: 60,
                onSelected: (value) => seconds = value,
              ),
              MissionQuestionSelector(
                selectedCount: 25,
                isExamMode: false,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          code == 'es'
              ? 'Misión Matemática Personalizada'
              : 'Missão de Matemática Personalizada',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text(code == 'es' ? 'División' : 'Divisão'));
      expect(operation, MathOperation.division);
      final timer = find.text('2 minutos');
      await tester.ensureVisible(timer);
      await tester.tap(timer);
      expect(seconds, 120);
      await tester.ensureVisible(find.byType(MissionQuestionSelector));
      expect(
        find.text(code == 'es' ? '25 preguntas' : '25 perguntas'),
        findsOneWidget,
      );
    });
  }
}

Widget _app(Locale locale, Widget child) => MaterialApp(
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: child,
    ),
  ),
);
