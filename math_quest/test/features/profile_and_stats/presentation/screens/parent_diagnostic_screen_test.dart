import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/parent_diagnostic_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/parent_diagnostic_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/screens/parent_diagnostic_screen.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('renders provider state without export or printable actions', (
    tester,
  ) async {
    await _pumpScreen(tester);

    expect(find.text('Maya'), findsOneWidget);
    expect(find.text('85% Mastery'), findsOneWidget);
    expect(find.byIcon(Icons.share_rounded), findsNothing);
    expect(find.text('Download Worksheets (PDF)'), findsNothing);
    expect(find.text('Generate Printable Math Worksheets'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('back action pops the diagnostic route', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [parentDiagnosticProvider.overrideWithValue(_state)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentDiagnosticScreen(),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Open'), findsOneWidget);
  });
}

Future<void> _pumpScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [parentDiagnosticProvider.overrideWithValue(_state)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ParentDiagnosticScreen(),
      ),
    ),
  );
  await tester.pump();
  expect(tester.takeException(), isNull);
}

final _state = ParentDiagnosticState(
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
