import 'package:math_quest/l10n/app_localizations.dart';

enum LandingScreenshot {
  welcome('s1'),
  profile('s3'),
  daily('s5'),
  blocks('s9'),
  duel('s7'),
  trophies('s14'),
  report('s15'),
  settings('s10');

  const LandingScreenshot(this.file);
  final String file;
  String get asset => 'assets/screens/$file.png';
  String caption(AppLocalizations l) => switch (this) {
    welcome => l.landingScreenWelcome,
    profile => l.landingScreenProfile,
    daily => l.landingScreenDaily,
    blocks => l.landingScreenBlocks,
    duel => l.landingScreenDuel,
    trophies => l.landingScreenTrophies,
    report => l.landingScreenReport,
    settings => l.landingScreenSettings,
  };
}
