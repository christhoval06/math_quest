import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_config.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_state.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/parent_gate_widgets.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('renders purpose challenge and delegates actions', (
    tester,
  ) async {
    final events = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ParentGateView(
          config: const ParentGateConfig(
            title: 'Change Screen Limit',
            description: 'Confirm an adult is making this change.',
            actionLabel: 'Continue',
          ),
          state: const ParentGateState(
            challenge: ParentGateChallenge(firstFactor: 7, secondFactor: 8),
          ),
          onAnswerChanged: (value) => events.add('answer:$value'),
          onSubmit: () => events.add('submit'),
          onCancel: () => events.add('cancel'),
        ),
      ),
    );

    expect(find.text('Adult verification'), findsOneWidget);
    expect(find.text('Change Screen Limit'), findsOneWidget);
    expect(find.text('What is seven × eight?'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('parent-gate-answer')), '56');
    await tester.tap(find.byKey(const Key('parent-gate-submit')));
    await tester.ensureVisible(find.text('Cancel'));
    await tester.pump();
    await tester.tap(find.text('Cancel'));

    expect(events, ['answer:56', 'submit', 'cancel']);
  });

  testWidgets('renders inline validation feedback accessibly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ParentGateView(
          config: ParentGateConfig.parentSettings,
          state: const ParentGateState(
            challenge: ParentGateChallenge(firstFactor: 7, secondFactor: 8),
            answer: '55',
            errorMessage: 'Not quite. Please try again.',
          ),
          onAnswerChanged: (_) {},
          onSubmit: () {},
          onCancel: () {},
        ),
      ),
    );

    expect(find.text('Not quite. Please try again.'), findsOneWidget);
    expect(find.bySemanticsLabel('Parent verification answer'), findsOneWidget);
  });

  testWidgets('long purpose content fits a phone viewport', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ParentGateView(
          config: const ParentGateConfig(
            title: 'A very long parent-only action title that must fit safely',
            description: 'A detailed explanation for a grown-up that can wrap onto several lines without breaking the layout.',
            actionLabel: 'Confirm This Protected Action',
          ),
          state: const ParentGateState(
            challenge: ParentGateChallenge(firstFactor: 10, secondFactor: 10),
          ),
          onAnswerChanged: (_) {},
          onSubmit: () {},
          onCancel: () {},
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
