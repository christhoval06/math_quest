import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/written_answer_pad.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('default standard pad hides controls and centers zero', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 2,
          accentColor: Colors.indigo,
          onSubmit: (_) async {},
        ),
      ),
    );

    expect(find.byKey(const Key('written-delete')), findsNothing);
    expect(find.byKey(const Key('written-confirm')), findsNothing);
    expect(find.byTooltip('Delete digit'), findsNothing);
    expect(find.byTooltip('Check answer'), findsNothing);
    expect(find.bySemanticsLabel('Delete digit'), findsNothing);
    expect(find.bySemanticsLabel('Check answer'), findsNothing);
    expect(
      tester.getSize(find.byKey(const Key('written-digit-0'))).width,
      greaterThan(
        tester.getSize(find.byKey(const Key('written-digit-1'))).width * 2,
      ),
    );
  });

  testWidgets('default compact pad uses two balanced rows', (tester) async {
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 2,
          compact: true,
          accentColor: Colors.indigo,
          onSubmit: (_) async {},
        ),
      ),
    );

    expect(find.byKey(const Key('written-delete')), findsNothing);
    expect(find.byKey(const Key('written-confirm')), findsNothing);
    expect(find.bySemanticsLabel('Delete digit'), findsNothing);
    expect(find.bySemanticsLabel('Check answer'), findsNothing);
    expect(
      tester.getTopLeft(find.byKey(const Key('written-digit-1'))).dy,
      tester.getTopLeft(find.byKey(const Key('written-digit-5'))).dy,
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('written-digit-6'))).dy,
      tester.getTopLeft(find.byKey(const Key('written-digit-0'))).dy,
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('written-digit-1'))).dy,
      isNot(tester.getTopLeft(find.byKey(const Key('written-digit-6'))).dy),
    );
    expect(
      tester.getSize(find.byKey(const Key('written-digit-0'))).height,
      greaterThanOrEqualTo(44),
    );
  });

  testWidgets('controls can be explicitly restored', (tester) async {
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showDeleteButton: true,
          showCheckButton: true,
          accentColor: Colors.indigo,
          onSubmit: (_) async {},
        ),
      ),
    );

    expect(find.byKey(const Key('written-delete')), findsOneWidget);
    expect(find.byKey(const Key('written-confirm')), findsOneWidget);
  });

  testWidgets('hidden confirmation shows checking status without a button', (
    tester,
  ) async {
    final barrier = Completer<void>();
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          showCheckingStatus: true,
          digitCount: 1,
          accentColor: Colors.indigo,
          onSubmit: (_) => barrier.future,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-3')));
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.byKey(const Key('written-confirm')), findsNothing);
    expect(find.bySemanticsLabel('Checking answer'), findsNothing);
    expect(find.text('Checking…'), findsNothing);
    await tester.pump(const Duration(milliseconds: 249));
    expect(find.bySemanticsLabel('Checking answer'), findsNothing);
    expect(find.text('Checking…'), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.bySemanticsLabel('Checking answer'), findsOneWidget);
    expect(find.text('Checking…'), findsOneWidget);
    final status = tester.widget<Container>(
      find.byKey(const Key('written-checking-status')),
    );
    expect((status.decoration! as BoxDecoration).color, Colors.indigo);
    expect(
      tester.widget<Text>(find.text('Checking…')).style?.color,
      Colors.white,
    );

    barrier.complete();
    await tester.pump();
  });

  testWidgets('failed automatic check reveals one manual retry', (
    tester,
  ) async {
    var submissions = 0;
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showCheckingStatus: false,
          accentColor: Colors.indigo,
          onSubmit: (_) async {
            submissions++;
            if (submissions == 1) throw StateError('temporary failure');
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-9')));
    await tester.pump(const Duration(milliseconds: 450));

    expect(submissions, 1);
    expect(find.bySemanticsLabel('Checking answer'), findsNothing);
    expect(find.text('Checking…'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Try Again'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Try checking the answer again'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 1));
    expect(submissions, 1);

    await tester.tap(find.byKey(const Key('written-confirm')));
    await tester.pump();
    expect(submissions, 2);
  });

  testWidgets('complete answer auto-submits once after 450 milliseconds', (
    tester,
  ) async {
    final submissions = <int>[];
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 2,
          accentColor: Colors.indigo,
          onSubmit: (answer) async => submissions.add(answer),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-4')));
    await tester.tap(find.byKey(const Key('written-digit-2')));
    await tester.pump(const Duration(milliseconds: 449));
    expect(submissions, isEmpty);

    await tester.pump(const Duration(milliseconds: 1));
    expect(submissions, [42]);
    expect(find.bySemanticsLabel('Checking answer'), findsNothing);
    expect(find.text('Checking…'), findsNothing);
    await tester.pump(const Duration(seconds: 1));
    expect(submissions, [42]);
  });

  for (final compact in [false, true]) {
    testWidgets(
      'checking status can be hidden in ${compact ? 'compact' : 'standard'} mode',
      (tester) async {
        final barrier = Completer<void>();
        await tester.pumpWidget(
          _app(
            WrittenAnswerPad(
              digitCount: 1,
              compact: compact,
              showCheckingStatus: false,
              accentColor: Colors.indigo,
              onSubmit: (_) => barrier.future,
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('written-digit-4')));
        await tester.pump(const Duration(milliseconds: 450));
        await tester.pump(const Duration(seconds: 1));

        expect(find.byKey(const Key('written-checking-status')), findsNothing);
        expect(find.bySemanticsLabel('Checking answer'), findsNothing);
        expect(find.text('Checking…'), findsNothing);

        barrier.complete();
        await tester.pump();
      },
    );
  }

  testWidgets('manual confirmation cancels pending automatic check', (
    tester,
  ) async {
    var submissions = 0;
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showCheckButton: true,
          accentColor: Colors.indigo,
          onSubmit: (_) async => submissions++,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-7')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('written-confirm')));
    await tester.pump(const Duration(milliseconds: 500));

    expect(submissions, 1);
  });

  testWidgets('editing or disabling cancels pending automatic check', (
    tester,
  ) async {
    var submissions = 0;
    Widget buildPad({bool enabled = true}) => _app(
      WrittenAnswerPad(
        digitCount: 1,
        enabled: enabled,
        showDeleteButton: true,
        accentColor: Colors.indigo,
        onSubmit: (_) async => submissions++,
      ),
    );

    await tester.pumpWidget(buildPad());
    await tester.tap(find.byKey(const Key('written-digit-5')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('written-delete')));
    await tester.pump(const Duration(milliseconds: 500));
    expect(submissions, 0);

    await tester.tap(find.byKey(const Key('written-digit-5')));
    await tester.pumpWidget(buildPad(enabled: false));
    await tester.pump(const Duration(milliseconds: 500));
    expect(submissions, 0);
  });

  testWidgets('re-enabling a complete answer schedules one fresh check', (
    tester,
  ) async {
    var submissions = 0;
    Widget buildPad({required bool enabled}) => _app(
      WrittenAnswerPad(
        digitCount: 1,
        enabled: enabled,
        accentColor: Colors.indigo,
        onSubmit: (_) async => submissions++,
      ),
    );

    await tester.pumpWidget(buildPad(enabled: true));
    await tester.tap(find.byKey(const Key('written-digit-5')));
    await tester.pumpWidget(buildPad(enabled: false));
    await tester.pump(const Duration(milliseconds: 500));
    expect(submissions, 0);

    await tester.pumpWidget(buildPad(enabled: true));
    await tester.pump(const Duration(milliseconds: 449));
    expect(submissions, 0);
    await tester.pump(const Duration(milliseconds: 1));
    expect(submissions, 1);
    await tester.pump(const Duration(seconds: 1));
    expect(submissions, 1);
  });

  testWidgets('re-enabling never automatically retries a failed answer', (
    tester,
  ) async {
    var submissions = 0;
    Widget buildPad({required bool enabled}) => _app(
      WrittenAnswerPad(
        digitCount: 1,
        enabled: enabled,
        accentColor: Colors.indigo,
        onSubmit: (_) async {
          submissions++;
          throw StateError('temporary failure');
        },
      ),
    );

    await tester.pumpWidget(buildPad(enabled: true));
    await tester.tap(find.byKey(const Key('written-digit-5')));
    await tester.pump(const Duration(milliseconds: 450));
    expect(submissions, 1);

    await tester.pumpWidget(buildPad(enabled: false));
    await tester.pumpWidget(buildPad(enabled: true));
    await tester.pump(const Duration(seconds: 1));

    expect(submissions, 1);
    expect(find.widgetWithText(FilledButton, 'Try Again'), findsOneWidget);
  });

  testWidgets('disposing cancels pending automatic check', (tester) async {
    var submissions = 0;
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showDeleteButton: true,
          showCheckButton: true,
          accentColor: Colors.indigo,
          onSubmit: (_) async => submissions++,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-8')));
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SizedBox.shrink(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(submissions, 0);
  });

  testWidgets('failed automatic check unlocks for manual retry only', (
    tester,
  ) async {
    var submissions = 0;
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showCheckButton: true,
          accentColor: Colors.indigo,
          onSubmit: (_) async {
            submissions++;
            if (submissions == 1) throw StateError('temporary failure');
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-9')));
    await tester.pump(const Duration(milliseconds: 450));
    expect(submissions, 1);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('written-confirm')))
          .onPressed,
      isNotNull,
    );

    await tester.pump(const Duration(seconds: 1));
    expect(submissions, 1);
    await tester.tap(find.byKey(const Key('written-confirm')));
    await tester.pump();
    expect(submissions, 2);
  });

  testWidgets('renders one slot per answer digit and submits explicit value', (
    tester,
  ) async {
    int? submitted;
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 2,
          showCheckButton: true,
          accentColor: Colors.indigo,
          onSubmit: (answer) async => submitted = answer,
        ),
      ),
    );

    expect(find.byKey(const Key('written-slot-0')), findsOneWidget);
    expect(find.byKey(const Key('written-slot-1')), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('written-confirm')))
          .onPressed,
      isNull,
    );

    await tester.tap(find.byKey(const Key('written-digit-4')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('written-digit-2')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('written-confirm')));
    await tester.pump();

    expect(submitted, 42);
  });

  testWidgets(
    'delete edits without submitting and disabled pad ignores input',
    (tester) async {
      var submissions = 0;
      await tester.pumpWidget(
        _app(
          WrittenAnswerPad(
            digitCount: 2,
            showDeleteButton: true,
            accentColor: Colors.indigo,
            onSubmit: (_) async => submissions++,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('written-digit-1')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('written-delete')));
      expect(submissions, 0);

      await tester.pumpWidget(
        _app(
          WrittenAnswerPad(
            digitCount: 2,
            enabled: false,
            showDeleteButton: true,
            accentColor: Colors.indigo,
            onSubmit: (_) async => submissions++,
          ),
        ),
      );
      await tester.tap(find.byKey(const Key('written-digit-9')));
      expect(submissions, 0);
    },
  );

  testWidgets('locks after confirmation and prevents duplicate submissions', (
    tester,
  ) async {
    final barrier = Completer<void>();
    var submissions = 0;
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showCheckButton: true,
          accentColor: Colors.indigo,
          onSubmit: (_) async {
            submissions++;
            await barrier.future;
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-7')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('written-confirm')));
    await tester.tap(find.byKey(const Key('written-confirm')));
    await tester.pump();

    expect(submissions, 1);
    barrier.complete();
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('written-confirm')))
          .onPressed,
      isNull,
    );
  });

  testWidgets('standard mode renders a professional themed answer console', (
    tester,
  ) async {
    const accent = Color(0xFF6750A4);
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
        ).copyWith(
          surfaceContainerLow: const Color(0xFF20212A),
          surfaceContainerLowest: const Color(0xFF171820),
          surfaceContainerHighest: const Color(0xFF343541),
          outlineVariant: const Color(0xFF515361),
        );

    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showCheckButton: true,
          accentColor: accent,
          onSubmit: (_) async {},
        ),
        colorScheme: colorScheme,
      ),
    );

    expect(find.byKey(const Key('written-answer-panel')), findsOneWidget);
    expect(find.byKey(const Key('written-keypad-panel')), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Check Answer'), findsOneWidget);

    final answerPanel = tester.widget<Container>(
      find.byKey(const Key('written-answer-panel')),
    );
    final answerDecoration = answerPanel.decoration! as BoxDecoration;
    expect(answerDecoration.color, colorScheme.surfaceContainerLow);

    final digit = tester.widget<FilledButton>(
      find.byKey(const Key('written-digit-1')),
    );
    expect(
      digit.style?.backgroundColor?.resolve({}),
      Color.alphaBlend(
        accent.withValues(alpha: 0.18),
        colorScheme.surfaceContainerHighest,
      ),
    );
    expect(digit.style?.foregroundColor?.resolve({}), colorScheme.onSurface);
    expect(
      digit.style?.side?.resolve({})?.color,
      accent.withValues(alpha: 0.5),
    );
    expect(digit.style?.elevation?.resolve({}), 2);

    await tester.tap(find.byKey(const Key('written-digit-1')));
    await tester.pump();
    final confirm = tester.widget<FilledButton>(
      find.byKey(const Key('written-confirm')),
    );
    expect(confirm.style?.backgroundColor?.resolve({}), accent);
    expect(confirm.style?.foregroundColor?.resolve({}), Colors.white);
  });

  testWidgets('filled and result slots strengthen their semantic border', (
    tester,
  ) async {
    const accent = Color(0xFF006A6A);
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showCheckButton: true,
          accentColor: accent,
          onSubmit: (_) async {},
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-4')));
    await tester.pump();
    var slot = tester.widget<AnimatedContainer>(
      find.byKey(const Key('written-slot-0')),
    );
    var decoration = slot.decoration! as BoxDecoration;
    expect(decoration.border, Border.all(color: accent, width: 2));

    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showCheckButton: true,
          accentColor: accent,
          feedback: WrittenAnswerFeedback.incorrect,
          onSubmit: (_) async {},
        ),
      ),
    );
    slot = tester.widget<AnimatedContainer>(
      find.byKey(const Key('written-slot-0')),
    );
    decoration = slot.decoration! as BoxDecoration;
    expect(decoration.border, Border.all(color: AppColors.errorRed, width: 2));
    final resultDigit = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const Key('written-slot-0')),
        matching: find.text('4'),
      ),
    );
    expect(
      resultDigit.style?.color,
      Theme.of(tester.element(find.byType(WrittenAnswerPad)))
          .colorScheme
          .onSurface,
    );
  });

  testWidgets('failed submission unlocks the same answer for retry', (
    tester,
  ) async {
    var submissions = 0;
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showCheckButton: true,
          accentColor: Colors.indigo,
          onSubmit: (_) async {
            submissions++;
            if (submissions == 1) throw StateError('temporary failure');
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-8')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('written-confirm')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('written-confirm')));
    await tester.pump();

    expect(submissions, 2);
  });

  testWidgets('confirmation shows progress while an answer is submitting', (
    tester,
  ) async {
    final barrier = Completer<void>();
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          showCheckingStatus: true,
          digitCount: 1,
          showCheckButton: true,
          accentColor: Colors.indigo,
          onSubmit: (_) => barrier.future,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-3')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('written-confirm')));
    await tester.pump();

    expect(find.text('Checking…'), findsNothing);
    expect(find.bySemanticsLabel('Checking answer'), findsNothing);
    await tester.pump(const Duration(milliseconds: 249));
    expect(find.text('Checking…'), findsNothing);
    expect(find.bySemanticsLabel('Checking answer'), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.text('Checking…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Checking answer'), findsOneWidget);
    final confirmation = tester.widget<FilledButton>(
      find.byKey(const Key('written-confirm')),
    );
    expect(
      confirmation.style?.backgroundColor?.resolve({WidgetState.disabled}),
      Colors.indigo,
    );
    expect(
      confirmation.style?.foregroundColor?.resolve({WidgetState.disabled}),
      Colors.white,
    );

    barrier.complete();
    await tester.pump();
  });

  testWidgets('compact checking progress announces its status accessibly', (
    tester,
  ) async {
    final barrier = Completer<void>();
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          showCheckingStatus: true,
          digitCount: 1,
          compact: true,
          showCheckButton: true,
          accentColor: Colors.indigo,
          onSubmit: (_) => barrier.future,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-6')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('written-confirm')));
    await tester.pump();

    expect(find.bySemanticsLabel('Checking answer'), findsNothing);
    await tester.pump(const Duration(milliseconds: 249));
    expect(find.bySemanticsLabel('Checking answer'), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.bySemanticsLabel('Checking answer'), findsOneWidget);
    final confirmation = tester.widget<IconButton>(
      find.byKey(const Key('written-confirm')),
    );
    expect(
      confirmation.style?.backgroundColor?.resolve({WidgetState.disabled}),
      Colors.indigo,
    );
    expect(
      confirmation.style?.foregroundColor?.resolve({WidgetState.disabled}),
      Colors.white,
    );

    barrier.complete();
    await tester.pump();
  });

  testWidgets('compact hidden confirmation uses a high-contrast live status', (
    tester,
  ) async {
    final barrier = Completer<void>();
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          showCheckingStatus: true,
          digitCount: 1,
          compact: true,
          accentColor: Colors.indigo,
          onSubmit: (_) => barrier.future,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-digit-6')));
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.byKey(const Key('written-confirm')), findsNothing);
    expect(find.bySemanticsLabel('Checking answer'), findsNothing);
    await tester.pump(const Duration(milliseconds: 249));
    expect(find.bySemanticsLabel('Checking answer'), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.bySemanticsLabel('Checking answer'), findsOneWidget);
    final status = tester.widget<Container>(
      find.byKey(const Key('written-checking-status')),
    );
    expect((status.decoration! as BoxDecoration).color, Colors.indigo);
    expect(
      tester.widget<Text>(find.text('Checking…')).style?.color,
      Colors.white,
    );

    barrier.complete();
    await tester.pump();
  });

  testWidgets('feedback state is exposed accessibly', (tester) async {
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showDeleteButton: true,
          showCheckButton: true,
          accentColor: Colors.indigo,
          feedback: WrittenAnswerFeedback.correct,
          onSubmit: (_) async {},
        ),
      ),
    );

    expect(
      tester.getSemantics(find.bySemanticsLabel('Correct answer')),
      matchesSemantics(label: 'Correct answer', isLiveRegion: true),
    );
  });

  testWidgets('input feedback runs only when an edit changes the answer', (
    tester,
  ) async {
    var feedbackCount = 0;
    await tester.pumpWidget(
      _app(
        WrittenAnswerPad(
          digitCount: 1,
          showDeleteButton: true,
          showCheckButton: true,
          accentColor: Colors.indigo,
          onInputFeedback: () => feedbackCount++,
          onSubmit: (_) async {},
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('written-delete')));
    await tester.tap(find.byKey(const Key('written-digit-6')));
    await tester.pump();
    expect(feedbackCount, 1);

    await tester.tap(find.byKey(const Key('written-digit-7')));
    await tester.tap(find.byKey(const Key('written-confirm')));
    await tester.pump();
    expect(feedbackCount, 1);
  });
}

Widget _app(Widget child, {ColorScheme? colorScheme}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: colorScheme == null ? null : ThemeData(colorScheme: colorScheme),
  home: Scaffold(body: SizedBox(width: 390, height: 844, child: child)),
);
