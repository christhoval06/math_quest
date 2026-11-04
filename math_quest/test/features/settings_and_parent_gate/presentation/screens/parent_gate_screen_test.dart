import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_config.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/navigation/parent_gate_launcher.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('correct answer returns successful authorization', (
    tester,
  ) async {
    await _pumpLauncher(tester);

    await tester.tap(find.text('Open Gate'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('parent-gate-answer')), '56');
    await tester.tap(find.byKey(const Key('parent-gate-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Result: true'), findsOneWidget);
  });

  testWidgets('wrong answer stays on screen and can retry from keyboard', (
    tester,
  ) async {
    await _pumpLauncher(tester);
    await tester.tap(find.text('Open Gate'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('parent-gate-answer')), '55');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.text('Not quite. Please try again.'), findsOneWidget);
    expect(find.text('Change Screen Limit'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('parent-gate-answer')), '56');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Result: true'), findsOneWidget);
  });

  testWidgets('cancel and system back return unsuccessful authorization', (
    tester,
  ) async {
    await _pumpLauncher(tester);
    await tester.tap(find.text('Open Gate'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Cancel'));
    await tester.pump();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Result: false'), findsOneWidget);

    await tester.tap(find.text('Open Gate'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Result: false'), findsOneWidget);
  });

  testWidgets('rapid requests open one gate and authorize one action', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: _RapidLaunchHarness(),
      ),
    );

    await tester.tap(find.text('Open Gate Twice'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('parent-gate-answer')), '56');
    await tester.tap(find.byKey(const Key('parent-gate-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Change Screen Limit'), findsNothing);
    expect(find.text('Authorized actions: 1'), findsOneWidget);
  });
}

Future<void> _pumpLauncher(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: _LauncherHarness(
        requestAccess: (context) => ParentGateLauncher.requestAccess(
          context,
          challenge: const ParentGateChallenge(firstFactor: 7, secondFactor: 8),
          config: const ParentGateConfig(
            title: 'Change Screen Limit',
            description: 'Confirm an adult is making this change.',
            actionLabel: 'Continue',
          ),
        ),
      ),
    ),
  );
}

class _LauncherHarness extends StatefulWidget {
  final Future<bool> Function(BuildContext context) requestAccess;

  const _LauncherHarness({required this.requestAccess});

  @override
  State<_LauncherHarness> createState() => _LauncherHarnessState();
}

class _LauncherHarnessState extends State<_LauncherHarness> {
  bool? result;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final value = await widget.requestAccess(context);
            if (mounted) setState(() => result = value);
          },
          child: const Text('Open Gate'),
        ),
        Text('Result: $result'),
      ],
    ),
  );
}

class _RapidLaunchHarness extends StatefulWidget {
  const _RapidLaunchHarness();

  @override
  State<_RapidLaunchHarness> createState() => _RapidLaunchHarnessState();
}

class _RapidLaunchHarnessState extends State<_RapidLaunchHarness> {
  int authorizedActions = 0;

  Future<bool> _requestAccess() => ParentGateLauncher.requestAccess(
    context,
    challenge: const ParentGateChallenge(firstFactor: 7, secondFactor: 8),
    config: const ParentGateConfig(
      title: 'Change Screen Limit',
      description: 'Confirm an adult is making this change.',
      actionLabel: 'Continue',
    ),
  );

  Future<void> _openTwice() async {
    final requests = [_requestAccess(), _requestAccess()];
    final results = await Future.wait(requests);
    if (!mounted) return;
    setState(() => authorizedActions += results.where((value) => value).length);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        ElevatedButton(
          onPressed: _openTwice,
          child: const Text('Open Gate Twice'),
        ),
        Text('Authorized actions: $authorizedActions'),
      ],
    ),
  );
}
