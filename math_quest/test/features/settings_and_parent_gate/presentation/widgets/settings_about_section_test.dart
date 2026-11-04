import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/services/support_email.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_about_section.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_app_header.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  for (final code in ['en', 'es', 'pt']) {
    testWidgets('localized about sheets fit a narrow screen in $code', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        _app(code, const SettingsAboutSection(), textScale: 1.5),
      );
      final context = tester.element(find.byType(SettingsAboutSection));
      final l10n = AppLocalizations.of(context)!;
      if (code == 'es') expect(l10n.settingsTitle, 'Ajustes');
      await tester.tap(find.text(l10n.aboutAppTitle));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.text(l10n.aboutAppStory), findsOneWidget);
      expect(find.text(l10n.aboutFamilyBody), findsOneWidget);
      await tester.ensureVisible(find.text(l10n.gotIt));
      await tester.tap(find.text(l10n.gotIt));
      await tester.pumpAndSettle();
      final developer = find.text(l10n.aboutDeveloperTitle);
      await tester.ensureVisible(developer);
      await tester.tap(developer);
      await tester.pumpAndSettle();
      expect(find.text(l10n.aboutDeveloperBio), findsOneWidget);
      expect(find.text(l10n.developerStackBody), findsOneWidget);
      await tester.ensureVisible(find.text(l10n.gotIt));
      await tester.tap(find.text(l10n.gotIt));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('support opens a localized email draft in $code', (
      tester,
    ) async {
      Uri? draft;
      await tester.pumpWidget(
        _app(
          code,
          SettingsAboutSection(
            openEmail: (uri) async {
              draft = uri;
              return true;
            },
          ),
        ),
      );
      final l10n = AppLocalizations.of(
        tester.element(find.byType(SettingsAboutSection)),
      )!;
      await tester.tap(find.text(l10n.contactSupportTitle));
      await tester.pumpAndSettle();
      expect(draft!.scheme, 'mailto');
      expect(draft!.path, 'me@christhoval.dev');
      expect(draft!.queryParameters['subject'], l10n.supportEmailSubject);
      expect(draft!.queryParameters['body'], l10n.supportEmailBody);
      expect(draft.toString(), isNot(contains('+')));
      expect(find.byType(BottomSheet), findsNothing);
    });
  }

  for (final throwsError in [false, true]) {
    testWidgets(
      'mail failure offers a copyable address (throws: $throwsError)',
      (tester) async {
        String? copied;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async {
            if (call.method == 'Clipboard.setData') {
              copied = (call.arguments as Map)['text'] as String;
            }
            return null;
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            null,
          ),
        );
        await tester.pumpWidget(
          _app(
            'en',
            SettingsAboutSection(
              openEmail: (_) async {
                if (throwsError) throw PlatformException(code: 'unavailable');
                return false;
              },
            ),
          ),
        );
        await tester.tap(find.text('Contact / Support'));
        await tester.pumpAndSettle();
        expect(find.byType(BottomSheet), findsOneWidget);
        expect(find.text(SupportEmail.address), findsOneWidget);
        await tester.tap(find.text('Copy email address'));
        await tester.pump();
        expect(copied, SupportEmail.address);
        final confirmation = find.text('Email address copied');
        expect(confirmation, findsOneWidget);
        expect(
          find.descendant(of: find.byType(BottomSheet), matching: confirmation),
          findsOneWidget,
        );
        expect(
          tester
              .getRect(find.byType(BottomSheet))
              .contains(tester.getCenter(confirmation)),
          isTrue,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('app header uses the installed version and local branding', (
    tester,
  ) async {
    PackageInfo.setMockInitialValues(
      appName: 'MathQuest',
      packageName: 'dev.christhoval.mathquest',
      version: '2.3.4',
      buildNumber: '17',
      buildSignature: '',
    );
    await tester.pumpWidget(_app('en', const SettingsAppHeader()));
    await tester.pumpAndSettle();
    expect(find.text('MathQuest'), findsOneWidget);
    expect(find.text('v2.3.4 (17)'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('A little practice. A big adventure.'), findsOneWidget);
  });
}

Widget _app(String code, Widget child, {double textScale = 1}) => MaterialApp(
  locale: Locale(code),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  ),
);
