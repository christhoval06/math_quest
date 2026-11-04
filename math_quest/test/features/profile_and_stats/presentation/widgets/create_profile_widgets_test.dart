import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/create_profile_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/create_profile_widgets.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('form renders state and reports every editable action', (
    tester,
  ) async {
    final events = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: CreateProfileContent(
              state: CreateProfileState.initial(),
              isFromSettings: true,
              onNameChanged: (name) => events.add('name:$name'),
              onAvatarSelected: (avatar) => events.add('avatar:$avatar'),
              onGradeSelected: (grade) => events.add('grade:$grade'),
              onSubmit: () => events.add('submit'),
              onCancel: () => events.add('cancel'),
            ),
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('create-profile-name')),
      'Maya',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.tap(find.text('🚀'));
    await tester.tap(find.text('🦉'));
    await tester.ensureVisible(find.text('Grade 3+'));
    await tester.pump();
    await tester.tap(find.text('Grade 3+'));
    await tester.ensureVisible(find.text('Start My Adventure! 🚀'));
    await tester.pump();
    await tester.tap(find.text('Start My Adventure! 🚀'));
    await tester.tap(find.text('Cancel'));

    expect(
      events,
      containsAll([
        'name:Maya',
        'avatar:🚀',
        'avatar:🦉',
        'grade:Grade 3+',
        'submit',
        'cancel',
      ]),
    );
  });

  testWidgets('submitting state disables the primary action', (tester) async {
    var submitCount = 0;
    final state = CreateProfileState.initial().copyWith(isSubmitting: true);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: CreateProfileContent(
              state: state,
              isFromSettings: false,
              onNameChanged: (_) {},
              onAvatarSelected: (_) {},
              onGradeSelected: (_) {},
              onSubmit: () => submitCount++,
              onCancel: () {},
            ),
          ),
        ),
      ),
    );

    await tester.ensureVisible(find.text('Creating Profile…'));
    await tester.pump();
    expect(find.text('Creating Profile…'), findsOneWidget);
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
    expect(submitCount, 0);
  });
}
