import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/parent_diagnostic_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/parent_diagnostic_widgets.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('app bar reports navigation without a share action', (
    tester,
  ) async {
    final events = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: ParentDiagnosticAppBar(onBack: () => events.add('back')),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    expect(events, ['back']);
    expect(find.byIcon(Icons.share_rounded), findsNothing);
  });

  testWidgets('report renders mapped content without printable actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ParentDiagnosticReport(state: _state()),
          ),
        ),
      ),
    );

    expect(find.text('Maya'), findsOneWidget);
    expect(find.text('85% Mastery'), findsOneWidget);
    expect(find.text('ADDITION'), findsOneWidget);
    expect(find.text('On Track ⚡'), findsOneWidget);
    expect(find.text('Download Worksheets (PDF)'), findsNothing);
    expect(find.text('Generate Printable Math Worksheets'), findsNothing);
  });

  testWidgets('long student name and empty operations fit phone width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final state = ParentDiagnosticState(
      name: 'A very long student name that must never overflow',
      grade: 'Grade 2',
      avatar: '🚀',
      reportDateLabel: '10/23/2026',
      totalSolved: 0,
      overallAccuracy: 0,
      readinessProgress: 0.1,
      readinessLabel: 'Baseline Gathering',
      readinessSummary: 'Keep practicing.',
      operations: const [],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ParentDiagnosticReport(state: state),
          ),
        ),
      ),
    );

    expect(find.text('No operation data yet.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

ParentDiagnosticState _state() => ParentDiagnosticState(
  name: 'Maya',
  grade: 'Grade 3',
  avatar: '🚀',
  reportDateLabel: '10/23/2026',
  totalSolved: 30,
  overallAccuracy: 0.85,
  readinessProgress: 0.85,
  readinessLabel: '85% Mastery',
  readinessSummary: 'Maya is building strong skills.',
  operations: const [
    OperationDiagnosticViewData(
      title: 'ADDITION',
      totalSolved: 20,
      accuracyPercent: 85,
      status: DiagnosticOperationStatus.onTrack,
    ),
  ],
);
