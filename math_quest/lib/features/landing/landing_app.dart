import 'package:flutter/material.dart';

import 'package:math_quest/features/landing/landing_page.dart';
import 'package:math_quest/features/landing/services/landing_actions.dart';

import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/landing/theme/landing_theme.dart';

class LandingApp extends StatefulWidget {
  const LandingApp({super.key, this.actions, this.initialLocale});
  final LandingActions? actions;
  final Locale? initialLocale;

  @override
  State<LandingApp> createState() => _LandingAppState();
}

class _LandingAppState extends State<LandingApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: _locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    onGenerateTitle: (context) =>
        AppLocalizations.of(context)!.landingPageTitle,
    theme: LandingTheme.light,
    home: LandingPage(
      actions: widget.actions,
      onLocaleChanged: (locale) => setState(() => _locale = locale),
    ),
  );
}
