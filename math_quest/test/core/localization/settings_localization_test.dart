import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_banner.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_language_selector.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_parent_zone.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('translated grade choices preserve stored curriculum values', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: SettingsParentZone(
            activeProfileName: 'Leo',
            screenLimitMinutes: 30,
            targetMathStandard: 'Grade 2',
            primaryColor: Colors.blue,
            onScreenLimitSelected: (_) {},
            onTargetStandardSelected: (value) => selected = value,
            onResetProgress: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Límite diario de pantalla (Leo)'), findsOneWidget);
    expect(find.text('2.º grado'), findsOneWidget);
    await tester.tap(find.text('1.er grado'));
    expect(selected, 'Grade 1');
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings copy follows language selection without restarting', (
    tester,
  ) async {
    await tester.pumpWidget(const _LanguageHarness());
    await tester.pumpAndSettle();
    expect(find.text('Personalize Quest!'), findsOneWidget);

    final selector = tester.widget<SettingsLanguageSelector>(
      find.byType(SettingsLanguageSelector),
    );
    selector.onChanged('es');
    await tester.pumpAndSettle();
    expect(find.text('¡Personaliza tu aventura!'), findsOneWidget);
    expect(find.text('Idioma de la App'), findsOneWidget);
    expect(find.text('Personalize Quest!'), findsNothing);

    tester
        .widget<SettingsLanguageSelector>(find.byType(SettingsLanguageSelector))
        .onChanged('pt');
    await tester.pumpAndSettle();
    expect(find.text('Personalize sua aventura!'), findsOneWidget);
    expect(find.text('Idioma do Aplicativo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _LanguageHarness extends StatefulWidget {
  const _LanguageHarness();

  @override
  State<_LanguageHarness> createState() => _LanguageHarnessState();
}

class _LanguageHarnessState extends State<_LanguageHarness> {
  String code = 'en';

  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: Locale(code),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: Column(
        children: [
          const SettingsBanner(),
          SettingsLanguageSelector(
            localeCode: code,
            onChanged: (value) => setState(() => code = value),
          ),
        ],
      ),
    ),
  );
}
