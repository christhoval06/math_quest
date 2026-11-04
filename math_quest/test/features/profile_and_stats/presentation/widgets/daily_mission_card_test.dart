import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/home_dashboard_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/daily_mission_card.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('in-progress mission invokes continue once', (tester) async {
    var continueCount = 0;
    await tester.pumpWidget(
      _app(
        data: _mission(status: DailyMissionStatus.inProgress),
        onContinue: () => continueCount++,
      ),
    );

    await tester.tap(find.text('Continue Mission'));
    await tester.pump();

    expect(continueCount, 1);
    expect(find.text('Claim 50 Coins & Badge! 🎁'), findsNothing);
  });

  testWidgets('ready mission awaits claim once', (tester) async {
    var claimCount = 0;
    await tester.pumpWidget(
      _app(
        data: _mission(status: DailyMissionStatus.readyToClaim),
        onClaim: () async => claimCount++,
      ),
    );

    await tester.tap(find.text('Claim 50 Coins & Badge! 🎁'));
    await tester.pump();

    expect(claimCount, 1);
    expect(find.text('Continue Mission'), findsNothing);
  });

  testWidgets('ready mission disables claim while request is pending', (
    tester,
  ) async {
    var claimCount = 0;
    final completer = Completer<void>();
    await tester.pumpWidget(
      _app(
        data: _mission(status: DailyMissionStatus.readyToClaim),
        onClaim: () {
          claimCount++;
          return completer.future;
        },
      ),
    );

    await tester.tap(find.text('Claim 50 Coins & Badge! 🎁'));
    await tester.pump();
    await tester.tap(find.text('Claim 50 Coins & Badge! 🎁'));

    expect(claimCount, 1);
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
    completer.complete();
    await tester.pump();
  });

  testWidgets('claimed mission shows completion without actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(data: _mission(status: DailyMissionStatus.claimed)),
    );

    expect(find.text('Mission Completed for Today! 🎉'), findsOneWidget);
    expect(find.text('Continue Mission'), findsNothing);
    expect(find.text('Claim 50 Coins & Badge! 🎁'), findsNothing);
  });

  testWidgets('complete progress renders without framework exceptions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        data: _mission(
          status: DailyMissionStatus.readyToClaim,
          progressFraction: 1,
          progressPercent: 100,
          currentProgress: 10,
        ),
      ),
    );

    expect(find.text('10 of 10 completed'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _app({
  required DailyMissionViewData data,
  Future<void> Function()? onClaim,
  VoidCallback? onContinue,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: DailyMissionCard(
        data: data,
        primaryColor: Colors.blue,
        onClaim: onClaim ?? () async {},
        onContinue: onContinue ?? () {},
      ),
    ),
  );
}

DailyMissionViewData _mission({
  required DailyMissionStatus status,
  double progressFraction = 0.3,
  int progressPercent = 30,
  int currentProgress = 3,
}) {
  return DailyMissionViewData(
    title: 'Solve 10 Addition Puzzles',
    coinReward: 50,
    badgeRewardTitle: 'Test Badge',
    currentProgress: currentProgress,
    targetCount: 10,
    progressFraction: progressFraction,
    progressPercent: progressPercent,
    status: status,
  );
}
