import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/create_profile_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/onboarding_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/create_profile_widgets.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/onboarding_widgets.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/welcome_profile_pill.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'onboarding responds to language changes without losing the page',
    (tester) async {
      final locale = ValueNotifier(const Locale('en'));
      addTearDown(locale.dispose);
      final state = OnboardingState.initial();
      var nextCount = 0;
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, value, _) => _app(
            value,
            Column(
              children: [
                OnboardingSlide(slide: state.currentSlide),
                OnboardingFooter(state: state, onNext: () => nextCount++),
              ],
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 6));
      expect(find.text('Welcome to MathQuest!'), findsOneWidget);
      locale.value = const Locale('es');
      await tester.pump();
      await tester.pump(const Duration(seconds: 6));
      expect(find.text('¡Bienvenido a MathQuest!'), findsOneWidget);
      await tester.tap(find.text('Siguiente'));
      expect(nextCount, 1);
      locale.value = const Locale('pt');
      await tester.pump();
      await tester.pump(const Duration(seconds: 6));
      expect(find.text('Boas-vindas ao MathQuest!'), findsOneWidget);
      expect(find.text('Próximo'), findsOneWidget);
    },
  );

  for (final code in ['es', 'pt']) {
    testWidgets(
      'profile form in $code preserves names and stored grade values',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        String? grade;
        String? name;
        String? avatar;
        final locale = ValueNotifier(Locale(code));
        addTearDown(locale.dispose);
        var started = false;
        await tester.pumpWidget(
          ValueListenableBuilder<Locale>(
            valueListenable: locale,
            builder: (_, value, _) => _app(
              value,
              CreateProfileContent(
                state: CreateProfileState.initial(),
                isFromSettings: true,
                onNameChanged: (value) => name = value,
                onAvatarSelected: (value) => avatar = value,
                onGradeSelected: (value) => grade = value,
                onSubmit: () => started = true,
                onCancel: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.getSemantics(find.bySemanticsLabel('Avatar 👦')),
          matchesSemantics(
            label: 'Avatar 👦',
            isButton: true,
            isSelected: true,
            hasSelectedState: true,
            hasTapAction: true,
          ),
        );
        await tester.tap(find.bySemanticsLabel('Avatar 🚀'));
        expect(avatar, '🚀');
        await tester.enterText(
          find.byKey(const Key('create-profile-name')),
          'María',
        );
        expect(name, 'María');
        locale.value = const Locale('en');
        await tester.pumpAndSettle();
        expect(find.text('María'), findsOneWidget);
        locale.value = Locale(code);
        await tester.pumpAndSettle();
        final gradeLabel = find.text(code == 'es' ? '1.er grado' : '1º ano');
        await tester.ensureVisible(gradeLabel);
        await tester.tap(gradeLabel);
        expect(grade, 'Grade 1');
        final launch = find.text(
          code == 'es'
              ? '¡Comenzar mi aventura! 🚀'
              : 'Começar minha aventura! 🚀',
        );
        await tester.ensureVisible(launch);
        await tester.tap(launch);
        expect(started, isTrue);

        await tester.pumpWidget(
          _app(
            Locale(code),
            WelcomeProfilePill(
              avatar: '🚀',
              name: 'María',
              gradeLabel: 'Grade 1',
              onTap: () {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(
            code == 'es'
                ? 'Jugando como: María (1.er grado)'
                : 'Jogando como: María (1º ano)',
          ),
          findsOneWidget,
        );
      },
    );
  }
}

Widget _app(Locale locale, Widget child) => MaterialApp(
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: child,
    ),
  ),
);
