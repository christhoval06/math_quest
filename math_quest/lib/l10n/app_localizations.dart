import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MathQuest'**
  String get appTitle;

  /// No description provided for @tapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to Start Adventure!'**
  String get tapToStart;

  /// No description provided for @playingAs.
  ///
  /// In en, this message translates to:
  /// **'Playing as: {name} ({grade})'**
  String playingAs(String name, String grade);

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'{count} Day Streak!'**
  String dayStreak(int count);

  /// No description provided for @todaysMission.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S MISSION'**
  String get todaysMission;

  /// No description provided for @solveAddition.
  ///
  /// In en, this message translates to:
  /// **'Solve 10 Addition Puzzles'**
  String get solveAddition;

  /// No description provided for @continueMission.
  ///
  /// In en, this message translates to:
  /// **'Continue Mission'**
  String get continueMission;

  /// No description provided for @gameModes.
  ///
  /// In en, this message translates to:
  /// **'Game Modes'**
  String get gameModes;

  /// No description provided for @allUnlocked.
  ///
  /// In en, this message translates to:
  /// **'All Unlocked'**
  String get allUnlocked;

  /// No description provided for @quickPlay.
  ///
  /// In en, this message translates to:
  /// **'Quick Play'**
  String get quickPlay;

  /// No description provided for @practiceArena.
  ///
  /// In en, this message translates to:
  /// **'Practice Arena'**
  String get practiceArena;

  /// No description provided for @adventureIsland.
  ///
  /// In en, this message translates to:
  /// **'Adventure Island'**
  String get adventureIsland;

  /// No description provided for @buddyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Buddy Challenge'**
  String get buddyChallenge;

  /// No description provided for @practiceLab.
  ///
  /// In en, this message translates to:
  /// **'PRACTICE LAB'**
  String get practiceLab;

  /// No description provided for @customMission.
  ///
  /// In en, this message translates to:
  /// **'Custom Math Mission'**
  String get customMission;

  /// No description provided for @chooseOperation.
  ///
  /// In en, this message translates to:
  /// **'Choose Operation'**
  String get chooseOperation;

  /// No description provided for @chooseDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty (Number of Digits)'**
  String get chooseDifficulty;

  /// No description provided for @chooseTimer.
  ///
  /// In en, this message translates to:
  /// **'Choose Timer / Pace'**
  String get chooseTimer;

  /// No description provided for @funHelpers.
  ///
  /// In en, this message translates to:
  /// **'Fun Helpers'**
  String get funHelpers;

  /// No description provided for @visualCountingAids.
  ///
  /// In en, this message translates to:
  /// **'Visual Counting Aids'**
  String get visualCountingAids;

  /// No description provided for @soundEffectsCheering.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects & Cheering'**
  String get soundEffectsCheering;

  /// No description provided for @launchMission.
  ///
  /// In en, this message translates to:
  /// **'Launch Math Mission! (10 Questions)'**
  String get launchMission;

  /// No description provided for @pickYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Pick your answer:'**
  String get pickYourAnswer;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check Answer!'**
  String get checkAnswer;

  /// No description provided for @correctTitle.
  ///
  /// In en, this message translates to:
  /// **'Awesome Job! 🌟'**
  String get correctTitle;

  /// No description provided for @wrongTitle.
  ///
  /// In en, this message translates to:
  /// **'Not quite right!'**
  String get wrongTitle;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @questComplete.
  ///
  /// In en, this message translates to:
  /// **'Quest Complete!'**
  String get questComplete;

  /// No description provided for @roundStats.
  ///
  /// In en, this message translates to:
  /// **'Round Stats'**
  String get roundStats;

  /// No description provided for @correctAnswers.
  ///
  /// In en, this message translates to:
  /// **'Correct Answers'**
  String get correctAnswers;

  /// No description provided for @averageSpeed.
  ///
  /// In en, this message translates to:
  /// **'Average Speed'**
  String get averageSpeed;

  /// No description provided for @playAnotherRound.
  ///
  /// In en, this message translates to:
  /// **'Play Another Round'**
  String get playAnotherRound;

  /// No description provided for @reviewMistakes.
  ///
  /// In en, this message translates to:
  /// **'Review Mistakes'**
  String get reviewMistakes;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @trophyRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Trophy Room & Stats'**
  String get trophyRoomTitle;

  /// No description provided for @weeklyPractice.
  ///
  /// In en, this message translates to:
  /// **'Weekly Practice'**
  String get weeklyPractice;

  /// No description provided for @mathMasteryTracks.
  ///
  /// In en, this message translates to:
  /// **'Math Mastery Tracks'**
  String get mathMasteryTracks;

  /// No description provided for @recentBadges.
  ///
  /// In en, this message translates to:
  /// **'Recent Badges'**
  String get recentBadges;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get language;

  /// No description provided for @parentGateTitle.
  ///
  /// In en, this message translates to:
  /// **'Grown-Ups Zone'**
  String get parentGateTitle;

  /// No description provided for @parentGatePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please ask a grown-up to solve: What is {num1} × {num2}?'**
  String parentGatePrompt(int num1, int num2);

  /// No description provided for @navPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get navPlay;

  /// No description provided for @navPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get navPractice;

  /// No description provided for @navQuest.
  ///
  /// In en, this message translates to:
  /// **'Quest'**
  String get navQuest;

  /// No description provided for @navTrophies.
  ///
  /// In en, this message translates to:
  /// **'Trophies'**
  String get navTrophies;

  /// No description provided for @settingsLabel.
  ///
  /// In en, this message translates to:
  /// **'APP SETTINGS'**
  String get settingsLabel;

  /// No description provided for @personalizeQuest.
  ///
  /// In en, this message translates to:
  /// **'Personalize Quest!'**
  String get personalizeQuest;

  /// No description provided for @settingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust sounds, switch profiles & manage parent rules.'**
  String get settingsDescription;

  /// No description provided for @soundsAndWorld.
  ///
  /// In en, this message translates to:
  /// **'Sounds & Adventure World'**
  String get soundsAndWorld;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects (SFX)'**
  String get soundEffects;

  /// No description provided for @gameMelodies.
  ///
  /// In en, this message translates to:
  /// **'Game Melodies'**
  String get gameMelodies;

  /// No description provided for @voiceReadAloud.
  ///
  /// In en, this message translates to:
  /// **'Voice Read-Aloud'**
  String get voiceReadAloud;

  /// No description provided for @voiceReadAloudDescription.
  ///
  /// In en, this message translates to:
  /// **'Reads word problems out loud automatically'**
  String get voiceReadAloudDescription;

  /// No description provided for @hapticTouch.
  ///
  /// In en, this message translates to:
  /// **'Haptic Touch Buzz'**
  String get hapticTouch;

  /// No description provided for @hapticTouchDescription.
  ///
  /// In en, this message translates to:
  /// **'Feel answer taps and correct or incorrect feedback'**
  String get hapticTouchDescription;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'🌐 Select Language'**
  String get selectLanguage;

  /// No description provided for @responseMode.
  ///
  /// In en, this message translates to:
  /// **'Response Mode'**
  String get responseMode;

  /// No description provided for @responseModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how answers are entered throughout the app.'**
  String get responseModeDescription;

  /// No description provided for @responseChoice.
  ///
  /// In en, this message translates to:
  /// **'Choice'**
  String get responseChoice;

  /// No description provided for @responseWrite.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get responseWrite;

  /// No description provided for @responseChoiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick from four answers'**
  String get responseChoiceDescription;

  /// No description provided for @responseWriteDescription.
  ///
  /// In en, this message translates to:
  /// **'Type the answer'**
  String get responseWriteDescription;

  /// No description provided for @responseModeSemantics.
  ///
  /// In en, this message translates to:
  /// **'{mode} response mode'**
  String responseModeSemantics(String mode);

  /// No description provided for @gameVisualTheme.
  ///
  /// In en, this message translates to:
  /// **'Game Visual Theme'**
  String get gameVisualTheme;

  /// No description provided for @themeGalaxy.
  ///
  /// In en, this message translates to:
  /// **'Galaxy Quest'**
  String get themeGalaxy;

  /// No description provided for @themeGalaxyDescription.
  ///
  /// In en, this message translates to:
  /// **'Deep space'**
  String get themeGalaxyDescription;

  /// No description provided for @themeCandy.
  ///
  /// In en, this message translates to:
  /// **'Candy Land'**
  String get themeCandy;

  /// No description provided for @themeCandyDescription.
  ///
  /// In en, this message translates to:
  /// **'Sweet hills'**
  String get themeCandyDescription;

  /// No description provided for @themeDino.
  ///
  /// In en, this message translates to:
  /// **'Dino Math'**
  String get themeDino;

  /// No description provided for @themeDinoDescription.
  ///
  /// In en, this message translates to:
  /// **'Prehistoric'**
  String get themeDinoDescription;

  /// No description provided for @themeUnderwater.
  ///
  /// In en, this message translates to:
  /// **'Underwater'**
  String get themeUnderwater;

  /// No description provided for @themeUnderwaterDescription.
  ///
  /// In en, this message translates to:
  /// **'Coral reef'**
  String get themeUnderwaterDescription;

  /// No description provided for @whosPlaying.
  ///
  /// In en, this message translates to:
  /// **'Who\'s Playing?'**
  String get whosPlaying;

  /// No description provided for @profileSlotsUsed.
  ///
  /// In en, this message translates to:
  /// **'{count} of 3 slots used'**
  String profileSlotsUsed(int count);

  /// No description provided for @profilesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Profiles unavailable'**
  String get profilesUnavailable;

  /// No description provided for @addChildProfile.
  ///
  /// In en, this message translates to:
  /// **'Add New Child Profile'**
  String get addChildProfile;

  /// No description provided for @allProfileSlotsUsed.
  ///
  /// In en, this message translates to:
  /// **'All 3 profile slots in use'**
  String get allProfileSlotsUsed;

  /// No description provided for @profileLevel.
  ///
  /// In en, this message translates to:
  /// **'Lvl {level}'**
  String profileLevel(int level);

  /// No description provided for @profileActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get profileActive;

  /// No description provided for @switchProfile.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchProfile;

  /// No description provided for @safeKidsEdition.
  ///
  /// In en, this message translates to:
  /// **'MathQuest v{version} (Safe Kids Edition)'**
  String safeKidsEdition(String version);

  /// No description provided for @localProgressBackup.
  ///
  /// In en, this message translates to:
  /// **'All game progress backed up safely in local storage.'**
  String get localProgressBackup;

  /// No description provided for @parentZone.
  ///
  /// In en, this message translates to:
  /// **'Parent Gate Zone'**
  String get parentZone;

  /// No description provided for @parentZoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Adults Only: Curriculums, timers & reports'**
  String get parentZoneDescription;

  /// No description provided for @dailyScreenLimit.
  ///
  /// In en, this message translates to:
  /// **'Daily Screen Limit ({name})'**
  String dailyScreenLimit(String name);

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @targetMathStandard.
  ///
  /// In en, this message translates to:
  /// **'Target Math Standard'**
  String get targetMathStandard;

  /// No description provided for @gradePreK.
  ///
  /// In en, this message translates to:
  /// **'Pre-K'**
  String get gradePreK;

  /// No description provided for @gradeOne.
  ///
  /// In en, this message translates to:
  /// **'Grade 1'**
  String get gradeOne;

  /// No description provided for @gradeTwo.
  ///
  /// In en, this message translates to:
  /// **'Grade 2'**
  String get gradeTwo;

  /// No description provided for @gradeThreePlus.
  ///
  /// In en, this message translates to:
  /// **'Grade 3+'**
  String get gradeThreePlus;

  /// No description provided for @resetCurrentHero.
  ///
  /// In en, this message translates to:
  /// **'Reset Adventure Progress for Current Hero'**
  String get resetCurrentHero;

  /// No description provided for @resetProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset All Progress?'**
  String get resetProgressTitle;

  /// No description provided for @resetProgressDescription.
  ///
  /// In en, this message translates to:
  /// **'This will lock all completed stages and worlds, resetting Adventure Island back to Stage 1. Are you sure?'**
  String get resetProgressDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @resetNow.
  ///
  /// In en, this message translates to:
  /// **'Reset Now'**
  String get resetNow;

  /// No description provided for @hero.
  ///
  /// In en, this message translates to:
  /// **'Hero'**
  String get hero;

  /// No description provided for @profileSwitched.
  ///
  /// In en, this message translates to:
  /// **'Profile switched! 🚀'**
  String get profileSwitched;

  /// No description provided for @switchedToProfile.
  ///
  /// In en, this message translates to:
  /// **'Switched to {name}! 🚀'**
  String switchedToProfile(String name);

  /// No description provided for @screenLimitUpdated.
  ///
  /// In en, this message translates to:
  /// **'Screen limit updated to {limit}!'**
  String screenLimitUpdated(String limit);

  /// No description provided for @minutesLong.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, one{1 minute} other{{minutes} minutes}}'**
  String minutesLong(int minutes);

  /// No description provided for @targetStandardUpdated.
  ///
  /// In en, this message translates to:
  /// **'Target Math Standard set to {standard}!'**
  String targetStandardUpdated(String standard);

  /// No description provided for @adventureProgressReset.
  ///
  /// In en, this message translates to:
  /// **'✅ Adventure Island has been reset to Stage 1!'**
  String get adventureProgressReset;

  /// No description provided for @settingsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update settings. Please try again.'**
  String get settingsUpdateFailed;

  /// No description provided for @explorerName.
  ///
  /// In en, this message translates to:
  /// **'Explorer {name}'**
  String explorerName(String name);

  /// No description provided for @readyForQuest.
  ///
  /// In en, this message translates to:
  /// **'Ready for your quest?'**
  String get readyForQuest;

  /// No description provided for @starryWaiting.
  ///
  /// In en, this message translates to:
  /// **'Starry is waiting at the Cosmic Summit!'**
  String get starryWaiting;

  /// No description provided for @streakLabel.
  ///
  /// In en, this message translates to:
  /// **'STREAK'**
  String get streakLabel;

  /// No description provided for @starsLabel.
  ///
  /// In en, this message translates to:
  /// **'STARS'**
  String get starsLabel;

  /// No description provided for @rankLabel.
  ///
  /// In en, this message translates to:
  /// **'RANK'**
  String get rankLabel;

  /// No description provided for @daysShort.
  ///
  /// In en, this message translates to:
  /// **'{count}d'**
  String daysShort(int count);

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 Day} other{{count} Days}}'**
  String daysCount(int count);

  /// No description provided for @quickPlayDuration.
  ///
  /// In en, this message translates to:
  /// **'2 Min'**
  String get quickPlayDuration;

  /// No description provided for @customModeBadge.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customModeBadge;

  /// No description provided for @storyModeBadge.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get storyModeBadge;

  /// No description provided for @twoPlayersBadge.
  ///
  /// In en, this message translates to:
  /// **'2 Players'**
  String get twoPlayersBadge;

  /// No description provided for @quickPlayDescription.
  ///
  /// In en, this message translates to:
  /// **'Beat the ticking clock with snappy math!'**
  String get quickPlayDescription;

  /// No description provided for @practiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose operations, digits & pace.'**
  String get practiceDescription;

  /// No description provided for @adventureDescription.
  ///
  /// In en, this message translates to:
  /// **'Defeat math monsters & find treasure.'**
  String get adventureDescription;

  /// No description provided for @buddyDescription.
  ///
  /// In en, this message translates to:
  /// **'Pass & play duel with friends or family.'**
  String get buddyDescription;

  /// No description provided for @playNowAction.
  ///
  /// In en, this message translates to:
  /// **'Play Now →'**
  String get playNowAction;

  /// No description provided for @configureAction.
  ///
  /// In en, this message translates to:
  /// **'Configure →'**
  String get configureAction;

  /// No description provided for @exploreAction.
  ///
  /// In en, this message translates to:
  /// **'Explore →'**
  String get exploreAction;

  /// No description provided for @battleAction.
  ///
  /// In en, this message translates to:
  /// **'Battle →'**
  String get battleAction;

  /// No description provided for @missionProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total} completed'**
  String missionProgress(int current, int total);

  /// No description provided for @dailyMissionReward.
  ///
  /// In en, this message translates to:
  /// **'Reward: {coins} Star Coins & {badge}'**
  String dailyMissionReward(int coins, String badge);

  /// No description provided for @missionCompletedToday.
  ///
  /// In en, this message translates to:
  /// **'Mission Completed for Today! 🎉'**
  String get missionCompletedToday;

  /// No description provided for @claimMissionReward.
  ///
  /// In en, this message translates to:
  /// **'Claim {coins} Coins & Badge! 🎁'**
  String claimMissionReward(int coins);

  /// No description provided for @missionRewardAdded.
  ///
  /// In en, this message translates to:
  /// **'🎁 +{coins} Star Coins and {badge} added!'**
  String missionRewardAdded(int coins, String badge);

  /// No description provided for @superpowerTipHeading.
  ///
  /// In en, this message translates to:
  /// **'SUPERPOWER SECRET • Today\'s Tip'**
  String get superpowerTipHeading;

  /// No description provided for @tryNextChallenge.
  ///
  /// In en, this message translates to:
  /// **'Try it in your next challenge! →'**
  String get tryNextChallenge;

  /// No description provided for @missionLabDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick your math superpower and challenge rules!'**
  String get missionLabDescription;

  /// No description provided for @practiceMode.
  ///
  /// In en, this message translates to:
  /// **'🎮 Practice Mode'**
  String get practiceMode;

  /// No description provided for @examChallenge.
  ///
  /// In en, this message translates to:
  /// **'📝 Exam Challenge'**
  String get examChallenge;

  /// No description provided for @selectOperation.
  ///
  /// In en, this message translates to:
  /// **'Select operation'**
  String get selectOperation;

  /// No description provided for @operationAddition.
  ///
  /// In en, this message translates to:
  /// **'Addition'**
  String get operationAddition;

  /// No description provided for @operationSubtraction.
  ///
  /// In en, this message translates to:
  /// **'Subtraction'**
  String get operationSubtraction;

  /// No description provided for @operationMultiplication.
  ///
  /// In en, this message translates to:
  /// **'Multiplication'**
  String get operationMultiplication;

  /// No description provided for @operationDivision.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get operationDivision;

  /// No description provided for @appleCounters.
  ///
  /// In en, this message translates to:
  /// **'Apple counters'**
  String get appleCounters;

  /// No description provided for @balloonPops.
  ///
  /// In en, this message translates to:
  /// **'Balloon pops'**
  String get balloonPops;

  /// No description provided for @boosters.
  ///
  /// In en, this message translates to:
  /// **'Boosters'**
  String get boosters;

  /// No description provided for @pizzaSlices.
  ///
  /// In en, this message translates to:
  /// **'Pizza slices'**
  String get pizzaSlices;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @easyDigits.
  ///
  /// In en, this message translates to:
  /// **'1 Digit (3 + 5)'**
  String get easyDigits;

  /// No description provided for @mediumDigits.
  ///
  /// In en, this message translates to:
  /// **'2 Digits (24 + 38)'**
  String get mediumDigits;

  /// No description provided for @hardDigits.
  ///
  /// In en, this message translates to:
  /// **'3 Digits (145 + 289)'**
  String get hardDigits;

  /// No description provided for @easyDescription.
  ///
  /// In en, this message translates to:
  /// **'Gentle warm-up for beginners'**
  String get easyDescription;

  /// No description provided for @mediumDescription.
  ///
  /// In en, this message translates to:
  /// **'Elementary challenge & brain workout'**
  String get mediumDescription;

  /// No description provided for @hardDescription.
  ///
  /// In en, this message translates to:
  /// **'Math superhero level!'**
  String get hardDescription;

  /// No description provided for @noTimer.
  ///
  /// In en, this message translates to:
  /// **'No Timer'**
  String get noTimer;

  /// No description provided for @relaxAndLearn.
  ///
  /// In en, this message translates to:
  /// **'Relax & Learn'**
  String get relaxAndLearn;

  /// No description provided for @secondsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 Second} other{{count} Seconds}}'**
  String secondsCount(int count);

  /// No description provided for @twoMinutes.
  ///
  /// In en, this message translates to:
  /// **'2 Minutes'**
  String get twoMinutes;

  /// No description provided for @rapidDash.
  ///
  /// In en, this message translates to:
  /// **'Rapid Dash'**
  String get rapidDash;

  /// No description provided for @standardPace.
  ///
  /// In en, this message translates to:
  /// **'Standard Pace'**
  String get standardPace;

  /// No description provided for @deepFocus.
  ///
  /// In en, this message translates to:
  /// **'Deep Focus'**
  String get deepFocus;

  /// No description provided for @visualAidsDescription.
  ///
  /// In en, this message translates to:
  /// **'Show interactive blocks & dot grid'**
  String get visualAidsDescription;

  /// No description provided for @soundCheeringDescription.
  ///
  /// In en, this message translates to:
  /// **'Bubbly pops & joyful mascot chimes'**
  String get soundCheeringDescription;

  /// No description provided for @numberOfQuestions.
  ///
  /// In en, this message translates to:
  /// **'Number of Questions'**
  String get numberOfQuestions;

  /// No description provided for @questionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 Question} other{{count} Questions}}'**
  String questionCount(int count);

  /// No description provided for @completionReward.
  ///
  /// In en, this message translates to:
  /// **'Reward Upon Completion: +50 Stars & 1 Quest Key'**
  String get completionReward;

  /// No description provided for @missionRewardXp.
  ///
  /// In en, this message translates to:
  /// **'100 XP'**
  String get missionRewardXp;

  /// No description provided for @launchMissionCount.
  ///
  /// In en, this message translates to:
  /// **'Launch Mission! ({count, plural, one{1 Question} other{{count} Questions}})'**
  String launchMissionCount(int count);

  /// No description provided for @startExamCount.
  ///
  /// In en, this message translates to:
  /// **'Start Exam ({count, plural, one{1 Question} other{{count} Questions}})'**
  String startExamCount(int count);

  /// No description provided for @dailyAdditionTitle.
  ///
  /// In en, this message translates to:
  /// **'Solve {count} Addition Puzzles'**
  String dailyAdditionTitle(int count);

  /// No description provided for @dailySubtractionTitle.
  ///
  /// In en, this message translates to:
  /// **'Solve {count} Subtraction Puzzles'**
  String dailySubtractionTitle(int count);

  /// No description provided for @dailyMultiplicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Solve {count} Multiplication Puzzles'**
  String dailyMultiplicationTitle(int count);

  /// No description provided for @dailyDivisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Solve {count} Division Puzzles'**
  String dailyDivisionTitle(int count);

  /// No description provided for @spaceDetectiveBadge.
  ///
  /// In en, this message translates to:
  /// **'Space Detective Badge'**
  String get spaceDetectiveBadge;

  /// No description provided for @balloonPopperBadge.
  ///
  /// In en, this message translates to:
  /// **'Balloon Popper Badge'**
  String get balloonPopperBadge;

  /// No description provided for @lightningBoosterBadge.
  ///
  /// In en, this message translates to:
  /// **'Lightning Booster Badge'**
  String get lightningBoosterBadge;

  /// No description provided for @pizzaMasterBadge.
  ///
  /// In en, this message translates to:
  /// **'Pizza Master Badge'**
  String get pizzaMasterBadge;

  /// No description provided for @tipDoublesTitle.
  ///
  /// In en, this message translates to:
  /// **'The \"Doubles + 1\" Trick!'**
  String get tipDoublesTitle;

  /// No description provided for @tipDoublesDescription.
  ///
  /// In en, this message translates to:
  /// **'If you know 6 + 6 = 12, then 6 + 7 is super easy: just add 1 more to reach 13!'**
  String get tipDoublesDescription;

  /// No description provided for @tipMakeTenTitle.
  ///
  /// In en, this message translates to:
  /// **'The \"Make a 10\" Secret!'**
  String get tipMakeTenTitle;

  /// No description provided for @tipMakeTenDescription.
  ///
  /// In en, this message translates to:
  /// **'8 + 5 looks hard? Take 2 from the 5 to turn 8 into 10! Then 10 + 3 = 13!'**
  String get tipMakeTenDescription;

  /// No description provided for @tipSubtractTenTitle.
  ///
  /// In en, this message translates to:
  /// **'The \"Drop to 10\" Trick!'**
  String get tipSubtractTenTitle;

  /// No description provided for @tipSubtractTenDescription.
  ///
  /// In en, this message translates to:
  /// **'Solving 15 - 7? First drop 5 to hit 10, then drop the remaining 2 to get 8!'**
  String get tipSubtractTenDescription;

  /// No description provided for @tipTimesFiveTitle.
  ///
  /// In en, this message translates to:
  /// **'The \"Multiply by 5\" Hack!'**
  String get tipTimesFiveTitle;

  /// No description provided for @tipTimesFiveDescription.
  ///
  /// In en, this message translates to:
  /// **'6 × 5? Just add a zero to get 60, then take half of that: 30! Works every time!'**
  String get tipTimesFiveDescription;

  /// No description provided for @tipNinesTitle.
  ///
  /// In en, this message translates to:
  /// **'The Magic of 9s!'**
  String get tipNinesTitle;

  /// No description provided for @tipNinesDescription.
  ///
  /// In en, this message translates to:
  /// **'The digits of 9 times table always add up to 9! 9 × 3 = 27 (2+7=9). 9 × 4 = 36 (3+6=9)!'**
  String get tipNinesDescription;

  /// No description provided for @tipHalvingTitle.
  ///
  /// In en, this message translates to:
  /// **'Divide by 4 by Halving Twice!'**
  String get tipHalvingTitle;

  /// No description provided for @tipHalvingDescription.
  ///
  /// In en, this message translates to:
  /// **'To divide by 4, just cut the number in half, and then in half again! 28 → 14 → 7!'**
  String get tipHalvingDescription;

  /// No description provided for @tipZeroTitle.
  ///
  /// In en, this message translates to:
  /// **'The \"Zero Hero\" Rule!'**
  String get tipZeroTitle;

  /// No description provided for @tipZeroDescription.
  ///
  /// In en, this message translates to:
  /// **'Any number plus zero stays itself, but any number times zero always vanishes to 0!'**
  String get tipZeroDescription;

  /// No description provided for @tapCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Tap the correct answer:'**
  String get tapCorrectAnswer;

  /// No description provided for @writeCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Write the correct answer:'**
  String get writeCorrectAnswer;

  /// No description provided for @matchSetup.
  ///
  /// In en, this message translates to:
  /// **'Match Setup'**
  String get matchSetup;

  /// No description provided for @questionReview.
  ///
  /// In en, this message translates to:
  /// **'Question Review'**
  String get questionReview;

  /// No description provided for @nextStage.
  ///
  /// In en, this message translates to:
  /// **'Next Stage 🚀'**
  String get nextStage;

  /// No description provided for @playAnotherRoundAction.
  ///
  /// In en, this message translates to:
  /// **'Play Another Round 🔄'**
  String get playAnotherRoundAction;

  /// No description provided for @reviewMistakesCount.
  ///
  /// In en, this message translates to:
  /// **'Review {count, plural, one{1 Mistake} other{{count} Mistakes}} 🎯'**
  String reviewMistakesCount(int count);

  /// No description provided for @backAdventureMap.
  ///
  /// In en, this message translates to:
  /// **'Back to Adventure Map 🏝️'**
  String get backAdventureMap;

  /// No description provided for @backHomeAction.
  ///
  /// In en, this message translates to:
  /// **'Back to Home 🏠'**
  String get backHomeAction;

  /// No description provided for @targetBoss.
  ///
  /// In en, this message translates to:
  /// **'Target Boss: {name}'**
  String targetBoss(String name);

  /// No description provided for @worldTitle.
  ///
  /// In en, this message translates to:
  /// **'World {index}: {name}'**
  String worldTitle(int index, String name);

  /// No description provided for @switchIsland.
  ///
  /// In en, this message translates to:
  /// **'Switch Island'**
  String get switchIsland;

  /// No description provided for @countingHelpers.
  ///
  /// In en, this message translates to:
  /// **'Counting Helpers'**
  String get countingHelpers;

  /// No description provided for @tensAndOnes.
  ///
  /// In en, this message translates to:
  /// **'Tens & Ones'**
  String get tensAndOnes;

  /// No description provided for @numberDecomposition.
  ///
  /// In en, this message translates to:
  /// **'{value} ({tens} Tens, {ones} Ones)'**
  String numberDecomposition(int value, int tens, int ones);

  /// No description provided for @startBuddyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Start Buddy Challenge! (First to {points} Points)'**
  String startBuddyChallenge(int points);

  /// No description provided for @buddyRulesDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your players and challenge rules!'**
  String get buddyRulesDescription;

  /// No description provided for @buddyArena.
  ///
  /// In en, this message translates to:
  /// **'BUDDY ARENA'**
  String get buddyArena;

  /// No description provided for @playerOne.
  ///
  /// In en, this message translates to:
  /// **'Player 1'**
  String get playerOne;

  /// No description provided for @playerTwo.
  ///
  /// In en, this message translates to:
  /// **'Player 2'**
  String get playerTwo;

  /// No description provided for @playerNames.
  ///
  /// In en, this message translates to:
  /// **'Player Names'**
  String get playerNames;

  /// No description provided for @pointsToWin.
  ///
  /// In en, this message translates to:
  /// **'Points to Win'**
  String get pointsToWin;

  /// No description provided for @pointsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 Point} other{{count} Points}}'**
  String pointsCount(int count);

  /// No description provided for @pointsTargetDescription.
  ///
  /// In en, this message translates to:
  /// **'First player to reach the target wins'**
  String get pointsTargetDescription;

  /// No description provided for @buddyScore.
  ///
  /// In en, this message translates to:
  /// **'P1: {score1}  vs  P2: {score2}'**
  String buddyScore(int score1, int score2);

  /// No description provided for @firstToPoints.
  ///
  /// In en, this message translates to:
  /// **'First to {points} points'**
  String firstToPoints(int points);

  /// No description provided for @winnerName.
  ///
  /// In en, this message translates to:
  /// **'{name} Wins!'**
  String winnerName(String name);

  /// No description provided for @outstandingReflexes.
  ///
  /// In en, this message translates to:
  /// **'Outstanding math reflexes!'**
  String get outstandingReflexes;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @changeSettings.
  ///
  /// In en, this message translates to:
  /// **'Change Settings'**
  String get changeSettings;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @champion.
  ///
  /// In en, this message translates to:
  /// **'CHAMPION'**
  String get champion;

  /// No description provided for @finalScoreSemantics.
  ///
  /// In en, this message translates to:
  /// **'Final score: Player 1, {score1}; Player 2, {score2}'**
  String finalScoreSemantics(int score1, int score2);

  /// No description provided for @finalScore.
  ///
  /// In en, this message translates to:
  /// **'FINAL SCORE'**
  String get finalScore;

  /// No description provided for @correctAnswerExplanation.
  ///
  /// In en, this message translates to:
  /// **'The correct answer is {answer}. Keep going, explorer!'**
  String correctAnswerExplanation(String answer);

  /// No description provided for @sparkyAdvice.
  ///
  /// In en, this message translates to:
  /// **'Sparky says: Take your time and think it through!'**
  String get sparkyAdvice;

  /// No description provided for @worldBossDefeated.
  ///
  /// In en, this message translates to:
  /// **'WORLD BOSS DEFEATED!'**
  String get worldBossDefeated;

  /// No description provided for @welcomeToWorld.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {name}!'**
  String welcomeToWorld(String name);

  /// No description provided for @newIslandDescription.
  ///
  /// In en, this message translates to:
  /// **'A new island has appeared on your map with new math challenges and a legendary Boss!'**
  String get newIslandDescription;

  /// No description provided for @exploreNewIsland.
  ///
  /// In en, this message translates to:
  /// **'Explore New Island! 🚀'**
  String get exploreNewIsland;

  /// No description provided for @starCoinsReward.
  ///
  /// In en, this message translates to:
  /// **'+{count} Star Coins'**
  String starCoinsReward(int count);

  /// No description provided for @mathXpReward.
  ///
  /// In en, this message translates to:
  /// **'+{count} Math XP'**
  String mathXpReward(int count);

  /// No description provided for @accuracyPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Accuracy'**
  String accuracyPercent(int percent);

  /// No description provided for @averageSecondsItem.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s / item'**
  String averageSecondsItem(double seconds);

  /// No description provided for @elapsedSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String elapsedSeconds(double seconds);

  /// No description provided for @stellaCoach.
  ///
  /// In en, this message translates to:
  /// **'STAR COACH STELLA'**
  String get stellaCoach;

  /// No description provided for @stellaExcellent.
  ///
  /// In en, this message translates to:
  /// **'\"Outstanding, {name}! You totally rocked this mission!\"'**
  String stellaExcellent(String name);

  /// No description provided for @stellaEncouragement.
  ///
  /// In en, this message translates to:
  /// **'\"Great effort, math explorer! Every mistake helps your brain grow!\"'**
  String get stellaEncouragement;

  /// No description provided for @tryAgainTitle.
  ///
  /// In en, this message translates to:
  /// **'Try Again!'**
  String get tryAgainTitle;

  /// No description provided for @mistakeCorrected.
  ///
  /// In en, this message translates to:
  /// **'🎉 Awesome! You corrected your mistake!'**
  String get mistakeCorrected;

  /// No description provided for @useCountingBlocks.
  ///
  /// In en, this message translates to:
  /// **'Not quite! Use the blocks to count.'**
  String get useCountingBlocks;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @chosenAnswer.
  ///
  /// In en, this message translates to:
  /// **'You chose: {answer}'**
  String chosenAnswer(String answer);

  /// No description provided for @noAnswer.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noAnswer;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @countingHint.
  ///
  /// In en, this message translates to:
  /// **'Hint: Take your time and use the tens and ones blocks!'**
  String get countingHint;

  /// No description provided for @correctedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'🌟 Corrected successfully!'**
  String get correctedSuccessfully;

  /// No description provided for @starsEarned.
  ///
  /// In en, this message translates to:
  /// **'{count} OF 3 STARS EARNED'**
  String starsEarned(int count);

  /// No description provided for @newBadgeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'NEW BADGE UNLOCKED!'**
  String get newBadgeUnlocked;

  /// No description provided for @correctAnswerSemantics.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get correctAnswerSemantics;

  /// No description provided for @incorrectAnswerSemantics.
  ///
  /// In en, this message translates to:
  /// **'Incorrect answer'**
  String get incorrectAnswerSemantics;

  /// No description provided for @writtenAnswerSemantics.
  ///
  /// In en, this message translates to:
  /// **'Written answer'**
  String get writtenAnswerSemantics;

  /// No description provided for @retryAnswerSemantics.
  ///
  /// In en, this message translates to:
  /// **'Try checking the answer again'**
  String get retryAnswerSemantics;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @checkWrittenAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check Answer'**
  String get checkWrittenAnswer;

  /// No description provided for @tryAgainTooltip.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgainTooltip;

  /// No description provided for @checkAnswerTooltip.
  ///
  /// In en, this message translates to:
  /// **'Check answer'**
  String get checkAnswerTooltip;

  /// No description provided for @deleteDigit.
  ///
  /// In en, this message translates to:
  /// **'Delete digit'**
  String get deleteDigit;

  /// No description provided for @checkingAnswer.
  ///
  /// In en, this message translates to:
  /// **'Checking answer'**
  String get checkingAnswer;

  /// No description provided for @checkingStatus.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checkingStatus;

  /// No description provided for @examStageLabel.
  ///
  /// In en, this message translates to:
  /// **'EXAM CHALLENGE ({current}/{total})'**
  String examStageLabel(int current, int total);

  /// No description provided for @operationAdventure.
  ///
  /// In en, this message translates to:
  /// **'{operation} ADVENTURE'**
  String operationAdventure(String operation);

  /// No description provided for @adventureNamePart.
  ///
  /// In en, this message translates to:
  /// **'{key, select, p0{Emerald} p1{Sunny} p2{Whispering} p3{Verdant} p4{Golden} p5{Atoll} p6{Island} p7{Shores} p8{Meadow} p9{Haven} p10{Sugarplum} p11{Cotton Candy} p12{Lollipop} p13{Caramel} p14{Sweet} p15{Canyon} p16{Isle} p17{Reef} p18{Lagoon} p19{Kingdom} p20{Prehistoric} p21{Thunder} p22{Jurassic} p23{Amber} p24{Ancient} p25{Jungle} p26{Crag} p27{Wilds} p28{Sanctuary} p29{Astral} p30{Starfall} p31{Starlight} p32{Galactic} p33{Cosmic} p34{Summit} p35{Archipelago} p36{Peaks} p37{Nebula} p38{Spire} p39{Sunken} p40{Azure} p41{Tidal} p42{Sapphire} p43{Aquamarine} p44{Cove} p45{Cay} p46{Abyss} p47{Deep} other{{fallback}}}'**
  String adventureNamePart(String key, String fallback);

  /// No description provided for @adventureLandmark.
  ///
  /// In en, this message translates to:
  /// **'{key, select, s0{Pebble Beach} s1{Bamboo Grove} s2{Clover Valley} s3{Waterfall Ridge} s4{Golem’s Fortress} s5{Gummy Shore} s6{Marshmallow Trail} s7{Chocolate River} s8{Lollipop Peak} s9{Dragon’s Candy Keep} s10{Fossil Beach} s11{Fern Canopy} s12{Raptor Ravine} s13{Volcano Foothills} s14{T-Rex Throne Room} s15{Stardust Basin} s16{Meteor Bridge} s17{Aurora Ridge} s18{Gravity Well} s19{Titan’s Observatory} s20{Clownfish Cove} s21{Shell Cavern} s22{Sunken Galleon} s23{Pearl Trench} s24{Kraken’s Sunken Lair} s25{Stone Golem} s26{Sugar Dragon} s27{T-Rex Math King} s28{Star Titan} s29{Kraken Lord} other{{fallback}}}'**
  String adventureLandmark(String key, String fallback);

  /// No description provided for @gameBadgeTitle.
  ///
  /// In en, this message translates to:
  /// **'{key, select, speed_counter{Speed Counter} lightning_math{Lightning Math} quick_thinker{Quick Thinker} clean_slate{Zero Mistake Hero} sharp_shooter{Sharp Shooter} flawless_focus{Flawless Focus} early_starter{Habit Starter} week_warrior{Week Warrior} fortnight_legend{Fortnight Titan} half_century{First Fifty} century_club{Century Club} grand_master_500{Math Marathoner} millennium_scholar{Millennium Scholar} addition_superhero{Sum Hero} minus_ninja{Minus Ninja} times_master{Times Master} division_champ{Fair Share Champ} boss_slayer{Island Conqueror} space_detective{Space Detective} quad_master{Grand Polymath} other{{fallback}}}'**
  String gameBadgeTitle(String key, String fallback);

  /// No description provided for @gameBadgeDescription.
  ///
  /// In en, this message translates to:
  /// **'{key, select, speed_counter{Answer 5 questions under 5 seconds each in one round.} lightning_math{Answer 10 correct questions in under 30 seconds total.} quick_thinker{Solve your first problem in under 3 seconds.} clean_slate{Score 100% accuracy on a round with at least 10 questions.} sharp_shooter{Score 5 correct answers in a row with zero mistakes.} flawless_focus{Complete a 15+ question round with 90%+ accuracy.} early_starter{Maintain a 3-day active learning streak.} week_warrior{Maintain an unstoppable 7-day learning streak.} fortnight_legend{Reach a legendary 14-day practice streak.} half_century{Solve 50 math problems total across all operations.} century_club{Solve 100 math problems total across all operations.} grand_master_500{Reach 500 lifetime questions answered.} millennium_scholar{Solve an astonishing 1,000 total questions!} addition_superhero{Solve 100 addition problems with 90%+ accuracy.} minus_ninja{Solve 100 subtraction problems with 85%+ accuracy.} times_master{Reach Level 4 in Multiplication Mastery Track.} division_champ{Solve 75 division challenges without remainders.} boss_slayer{Defeat a World Boss in Adventure Island.} space_detective{Complete Today’s Daily Mission.} quad_master{Reach at least Level 3 across all 4 math operations.} other{{fallback}}}'**
  String gameBadgeDescription(String key, String fallback);

  /// No description provided for @adventureIslandName.
  ///
  /// In en, this message translates to:
  /// **'{prefix} {suffix}'**
  String adventureIslandName(String prefix, String suffix);

  /// No description provided for @welcomeAppName.
  ///
  /// In en, this message translates to:
  /// **'Math Quest'**
  String get welcomeAppName;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Learn, Play & Count!'**
  String get welcomeTagline;

  /// No description provided for @profileSwitchFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not switch profiles. Please try again.'**
  String get profileSwitchFailed;

  /// No description provided for @addChildProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Child Profile'**
  String get addChildProfileTitle;

  /// No description provided for @createHero.
  ///
  /// In en, this message translates to:
  /// **'Create Your Hero!'**
  String get createHero;

  /// No description provided for @createHeroDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick your avatar and tell us your name to start.'**
  String get createHeroDescription;

  /// No description provided for @chooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Avatar'**
  String get chooseAvatar;

  /// No description provided for @explorerNamePrompt.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name, explorer?'**
  String get explorerNamePrompt;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// No description provided for @selectGrade.
  ///
  /// In en, this message translates to:
  /// **'Select Your Grade'**
  String get selectGrade;

  /// No description provided for @creatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Creating Profile…'**
  String get creatingProfile;

  /// No description provided for @startMyAdventure.
  ///
  /// In en, this message translates to:
  /// **'Start My Adventure! 🚀'**
  String get startMyAdventure;

  /// No description provided for @profileCreated.
  ///
  /// In en, this message translates to:
  /// **'🎉 Welcome {name}! Profile created and active.'**
  String profileCreated(String name);

  /// No description provided for @profileCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to create profile. Please try again.'**
  String get profileCreationFailed;

  /// No description provided for @profileSwitcherDescription.
  ///
  /// In en, this message translates to:
  /// **'Select your profile to continue your adventure!'**
  String get profileSwitcherDescription;

  /// No description provided for @chargingBoosters.
  ///
  /// In en, this message translates to:
  /// **'Charging math boosters...'**
  String get chargingBoosters;

  /// No description provided for @warmingSuperpowers.
  ///
  /// In en, this message translates to:
  /// **'Warming up superpowers...'**
  String get warmingSuperpowers;

  /// No description provided for @readyForAdventure.
  ///
  /// In en, this message translates to:
  /// **'Ready for Adventure! 🚀'**
  String get readyForAdventure;

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}!'**
  String welcomeGreeting(String name);

  /// No description provided for @starMath.
  ///
  /// In en, this message translates to:
  /// **'STAR MATH'**
  String get starMath;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to MathQuest!'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Turn arithmetic into a thrilling cosmic adventure where learning feels like play.'**
  String get onboardingWelcomeDescription;

  /// No description provided for @onboardingBlocksTitle.
  ///
  /// In en, this message translates to:
  /// **'Visual Counting Blocks'**
  String get onboardingBlocksTitle;

  /// No description provided for @onboardingBlocksDescription.
  ///
  /// In en, this message translates to:
  /// **'See numbers come to life with Base-10 blocks! Counting tens and ones makes carrying easy.'**
  String get onboardingBlocksDescription;

  /// No description provided for @onboardingAdventureTitle.
  ///
  /// In en, this message translates to:
  /// **'Defeat Bosses & Win Trophies'**
  String get onboardingAdventureTitle;

  /// No description provided for @onboardingAdventureDescription.
  ///
  /// In en, this message translates to:
  /// **'Climb Adventure Island, unlock new worlds, collect badges, and battle in 2-Player Duels!'**
  String get onboardingAdventureDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started 🚀'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @gradeKindergarten.
  ///
  /// In en, this message translates to:
  /// **'Kindergarten'**
  String get gradeKindergarten;

  /// No description provided for @gradeAgeRange.
  ///
  /// In en, this message translates to:
  /// **'Age {min}-{max}'**
  String gradeAgeRange(int min, int max);

  /// No description provided for @avatarOption.
  ///
  /// In en, this message translates to:
  /// **'Avatar {avatar}'**
  String avatarOption(String avatar);

  /// No description provided for @onboardingPage.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String onboardingPage(int current, int total);

  /// No description provided for @switchProfileAction.
  ///
  /// In en, this message translates to:
  /// **'Switch profile'**
  String get switchProfileAction;

  /// No description provided for @allBadgesTitle.
  ///
  /// In en, this message translates to:
  /// **'All Badges & Trophies'**
  String get allBadgesTitle;

  /// No description provided for @badgeUnlockedCaps.
  ///
  /// In en, this message translates to:
  /// **'✅ UNLOCKED'**
  String get badgeUnlockedCaps;

  /// No description provided for @badgeLockedCaps.
  ///
  /// In en, this message translates to:
  /// **'🔒 LOCKED'**
  String get badgeLockedCaps;

  /// No description provided for @badgeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'✅ Unlocked'**
  String get badgeUnlocked;

  /// No description provided for @badgeLocked.
  ///
  /// In en, this message translates to:
  /// **'🔒 Locked'**
  String get badgeLocked;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotIt;

  /// No description provided for @awesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get awesome;

  /// No description provided for @viewAllCount.
  ///
  /// In en, this message translates to:
  /// **'View All ({count})'**
  String viewAllCount(int count);

  /// No description provided for @operationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 Operation} other{{count} Operations}}'**
  String operationsCount(int count);

  /// No description provided for @parentDiagnosticTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent Diagnostic Report'**
  String get parentDiagnosticTitle;

  /// No description provided for @superMathematician.
  ///
  /// In en, this message translates to:
  /// **'SUPER MATHEMATICIAN!'**
  String get superMathematician;

  /// No description provided for @keepShining.
  ///
  /// In en, this message translates to:
  /// **'Keep shining! You\'re crushing your daily goals.'**
  String get keepShining;

  /// No description provided for @totalSolvedLabel.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SOLVED'**
  String get totalSolvedLabel;

  /// No description provided for @accuracyLabel.
  ///
  /// In en, this message translates to:
  /// **'ACCURACY'**
  String get accuracyLabel;

  /// No description provided for @unstoppable.
  ///
  /// In en, this message translates to:
  /// **'Unstoppable! 🔥'**
  String get unstoppable;

  /// No description provided for @trophiesLabel.
  ///
  /// In en, this message translates to:
  /// **'TROPHIES'**
  String get trophiesLabel;

  /// No description provided for @badgesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} left to unlock'**
  String badgesRemaining(int count);

  /// No description provided for @dailyProblemGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal: {count} problems'**
  String dailyProblemGoal(int count);

  /// No description provided for @weeklyGoalMet.
  ///
  /// In en, this message translates to:
  /// **'🎯 Goal Met!'**
  String get weeklyGoalMet;

  /// No description provided for @weeklyKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing!'**
  String get weeklyKeepGoing;

  /// No description provided for @noWeeklyData.
  ///
  /// In en, this message translates to:
  /// **'No practice yet'**
  String get noWeeklyData;

  /// No description provided for @noCategoryBadges.
  ///
  /// In en, this message translates to:
  /// **'No badges in this category yet.'**
  String get noCategoryBadges;

  /// No description provided for @noMasteryData.
  ///
  /// In en, this message translates to:
  /// **'Start practicing to see your mastery progress.'**
  String get noMasteryData;

  /// No description provided for @shortAccuracy.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Acc'**
  String shortAccuracy(int percent);

  /// No description provided for @masteryRank.
  ///
  /// In en, this message translates to:
  /// **'{icon} {title} (Level {level})'**
  String masteryRank(String icon, String title, int level);

  /// No description provided for @masteryProgress.
  ///
  /// In en, this message translates to:
  /// **'{solved} solved • {remaining} to Level {level}'**
  String masteryProgress(int solved, int remaining, int level);

  /// No description provided for @masteryMaxProgress.
  ///
  /// In en, this message translates to:
  /// **'{solved} solved • Max Level! 👑'**
  String masteryMaxProgress(int solved);

  /// No description provided for @curriculumBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Curriculum Operations Breakdown'**
  String get curriculumBreakdown;

  /// No description provided for @activeStudent.
  ///
  /// In en, this message translates to:
  /// **'Active Student'**
  String get activeStudent;

  /// No description provided for @gradeAligned.
  ///
  /// In en, this message translates to:
  /// **'{grade} • Common Core Aligned'**
  String gradeAligned(String grade);

  /// No description provided for @reportDate.
  ///
  /// In en, this message translates to:
  /// **'Report Date: {date}'**
  String reportDate(String date);

  /// No description provided for @readinessIndex.
  ///
  /// In en, this message translates to:
  /// **'GRADE READINESS INDEX'**
  String get readinessIndex;

  /// No description provided for @noOperationData.
  ///
  /// In en, this message translates to:
  /// **'No operation data yet.'**
  String get noOperationData;

  /// No description provided for @stellaObservations.
  ///
  /// In en, this message translates to:
  /// **'Teacher & Coach Stella Observations'**
  String get stellaObservations;

  /// No description provided for @identifiedStrength.
  ///
  /// In en, this message translates to:
  /// **'Identified Strength:'**
  String get identifiedStrength;

  /// No description provided for @recommendedFocus.
  ///
  /// In en, this message translates to:
  /// **'Recommended Focus:'**
  String get recommendedFocus;

  /// No description provided for @baselineGathering.
  ///
  /// In en, this message translates to:
  /// **'Baseline Gathering'**
  String get baselineGathering;

  /// No description provided for @masteryPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Mastery'**
  String masteryPercent(int percent);

  /// No description provided for @readinessStrong.
  ///
  /// In en, this message translates to:
  /// **'{name} demonstrates strong foundational number sense and is on track for advanced standards.'**
  String readinessStrong(String name);

  /// No description provided for @readinessStarting.
  ///
  /// In en, this message translates to:
  /// **'{name} has begun building foundational skills. Consistent daily 10-minute sessions are recommended.'**
  String readinessStarting(String name);

  /// No description provided for @noRoundsCompleted.
  ///
  /// In en, this message translates to:
  /// **'No rounds completed'**
  String get noRoundsCompleted;

  /// No description provided for @questionsAnswered.
  ///
  /// In en, this message translates to:
  /// **'{count} questions answered'**
  String questionsAnswered(int count);

  /// No description provided for @diagnosticPending.
  ///
  /// In en, this message translates to:
  /// **'Pending Assessment'**
  String get diagnosticPending;

  /// No description provided for @diagnosticNeedsPractice.
  ///
  /// In en, this message translates to:
  /// **'Needs Practice 🎯'**
  String get diagnosticNeedsPractice;

  /// No description provided for @diagnosticOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track ⚡'**
  String get diagnosticOnTrack;

  /// No description provided for @diagnosticMastered.
  ///
  /// In en, this message translates to:
  /// **'Mastered ✅'**
  String get diagnosticMastered;

  /// No description provided for @closeParentVerification.
  ///
  /// In en, this message translates to:
  /// **'Close parent verification'**
  String get closeParentVerification;

  /// No description provided for @adultVerificationCaps.
  ///
  /// In en, this message translates to:
  /// **'ADULT VERIFICATION'**
  String get adultVerificationCaps;

  /// No description provided for @adultVerification.
  ///
  /// In en, this message translates to:
  /// **'Adult verification'**
  String get adultVerification;

  /// No description provided for @parentControlsProtected.
  ///
  /// In en, this message translates to:
  /// **'This check helps keep grown-up controls protected.'**
  String get parentControlsProtected;

  /// No description provided for @parentAnswerSemantics.
  ///
  /// In en, this message translates to:
  /// **'Parent verification answer'**
  String get parentAnswerSemantics;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @gateAnswerRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an answer to continue.'**
  String get gateAnswerRequired;

  /// No description provided for @gateNumbersOnly.
  ///
  /// In en, this message translates to:
  /// **'Use numbers only.'**
  String get gateNumbersOnly;

  /// No description provided for @gateAnswerIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Not quite. Please try again.'**
  String get gateAnswerIncorrect;

  /// No description provided for @parentVerificationPrompt.
  ///
  /// In en, this message translates to:
  /// **'What is {first} × {second}?'**
  String parentVerificationPrompt(String first, String second);

  /// No description provided for @timeForRest.
  ///
  /// In en, this message translates to:
  /// **'Time for a Rest!'**
  String get timeForRest;

  /// No description provided for @restDescription.
  ///
  /// In en, this message translates to:
  /// **'Great job on your math adventure today! Starry is taking a nap. Ask a grown-up if you want to play more.'**
  String get restDescription;

  /// No description provided for @parentUnlock.
  ///
  /// In en, this message translates to:
  /// **'Parent Unlock 🛡️'**
  String get parentUnlock;

  /// No description provided for @gateSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent Settings'**
  String get gateSettingsTitle;

  /// No description provided for @gateSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Confirm you’re a grown-up before opening protected settings.'**
  String get gateSettingsDescription;

  /// No description provided for @unlockSettings.
  ///
  /// In en, this message translates to:
  /// **'Unlock Settings'**
  String get unlockSettings;

  /// No description provided for @gateScreenLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Screen Limit'**
  String get gateScreenLimitTitle;

  /// No description provided for @gateScreenLimitDescription.
  ///
  /// In en, this message translates to:
  /// **'Confirm you’re a grown-up before changing daily play time.'**
  String get gateScreenLimitDescription;

  /// No description provided for @gateLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Learning Goal'**
  String get gateLearningTitle;

  /// No description provided for @gateLearningDescription.
  ///
  /// In en, this message translates to:
  /// **'Confirm you’re a grown-up before changing the target math standard.'**
  String get gateLearningDescription;

  /// No description provided for @gateResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Adventure Progress'**
  String get gateResetTitle;

  /// No description provided for @gateResetDescription.
  ///
  /// In en, this message translates to:
  /// **'This is a protected action. Confirm you’re a grown-up to continue.'**
  String get gateResetDescription;

  /// No description provided for @gateExtraTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add More Play Time'**
  String get gateExtraTimeTitle;

  /// No description provided for @gateExtraTimeDescription.
  ///
  /// In en, this message translates to:
  /// **'Confirm you’re a grown-up before adding 15 more minutes.'**
  String get gateExtraTimeDescription;

  /// No description provided for @addFifteenMinutes.
  ///
  /// In en, this message translates to:
  /// **'Add 15 Minutes'**
  String get addFifteenMinutes;

  /// No description provided for @badgeCategory.
  ///
  /// In en, this message translates to:
  /// **'{key, select, ALL{ALL} SPEED{SPEED} ACCURACY{ACCURACY} STREAK{STREAK} MILESTONE{MILESTONE} MASTERY{MASTERY} ADVENTURE{ADVENTURE} DAILY{DAILY} LEGENDARY{LEGENDARY} other{{fallback}}}'**
  String badgeCategory(String key, String fallback);

  /// No description provided for @badgeTier.
  ///
  /// In en, this message translates to:
  /// **'{key, select, bronze{BRONZE} silver{SILVER} gold{GOLD} diamond{DIAMOND} other{{key}}}'**
  String badgeTier(String key);

  /// No description provided for @masteryTierTitle.
  ///
  /// In en, this message translates to:
  /// **'{level, select, l1{Sprout Explorer} l2{Number Cadet} l3{Math Adventurer} l4{Rising Star} l5{Number Wizard} l6{Math Superhero} l7{Cosmic Champion} l8{Mastermind} l9{Grand Titan} l10{Supreme Math Legend!} other{}}'**
  String masteryTierTitle(String level);

  /// No description provided for @gateNumberWord.
  ///
  /// In en, this message translates to:
  /// **'{value, select, n0{zero} n1{one} n2{two} n3{three} n4{four} n5{five} n6{six} n7{seven} n8{eight} n9{nine} n10{ten} other{}}'**
  String gateNumberWord(String value);

  /// No description provided for @weekdayShort.
  ///
  /// In en, this message translates to:
  /// **'{day, select, d0{Mon} d1{Tue} d2{Wed} d3{Thu} d4{Fri} d5{Sat} d6{Sun} other{}}'**
  String weekdayShort(String day);

  /// No description provided for @solvedToday.
  ///
  /// In en, this message translates to:
  /// **'+{count} today'**
  String solvedToday(int count);

  /// No description provided for @practiceAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Across practiced operations'**
  String get practiceAccuracy;

  /// No description provided for @explorerLabel.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get explorerLabel;

  /// No description provided for @observationNeedsPractice.
  ///
  /// In en, this message translates to:
  /// **'Complete a practice session to discover strengths.'**
  String get observationNeedsPractice;

  /// No description provided for @observationBuilding.
  ///
  /// In en, this message translates to:
  /// **'Skills are still developing. Keep practicing to build accuracy.'**
  String get observationBuilding;

  /// No description provided for @observationStrength.
  ///
  /// In en, this message translates to:
  /// **'{operation}: {percent}% accuracy across {count} answered questions.'**
  String observationStrength(String operation, int percent, int count);

  /// No description provided for @observationStart.
  ///
  /// In en, this message translates to:
  /// **'Try a short practice session to begin the assessment.'**
  String get observationStart;

  /// No description provided for @observationMaintain.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing all operations to maintain accuracy.'**
  String get observationMaintain;

  /// No description provided for @observationTry.
  ///
  /// In en, this message translates to:
  /// **'Try {operation} to gather assessment data.'**
  String observationTry(String operation);

  /// No description provided for @observationFocus.
  ///
  /// In en, this message translates to:
  /// **'Practice {operation}, currently at {percent}% accuracy.'**
  String observationFocus(String operation, int percent);

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'A little practice. A big adventure.'**
  String get appTagline;

  /// No description provided for @aboutSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutSectionTitle;

  /// No description provided for @aboutAppTitle.
  ///
  /// In en, this message translates to:
  /// **'About MathQuest'**
  String get aboutAppTitle;

  /// No description provided for @aboutAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A small idea, inspired by Dion'**
  String get aboutAppSubtitle;

  /// No description provided for @aboutAppStory.
  ///
  /// In en, this message translates to:
  /// **'I created MathQuest to help my son Dion study math. We don’t always have a pencil and paper at hand, so I wanted a simple way to turn any spare moment into a chance to learn together.'**
  String get aboutAppStory;

  /// No description provided for @aboutPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice anywhere'**
  String get aboutPracticeTitle;

  /// No description provided for @aboutPracticeBody.
  ///
  /// In en, this message translates to:
  /// **'A few minutes of math, wherever the day takes you.'**
  String get aboutPracticeBody;

  /// No description provided for @aboutPaceTitle.
  ///
  /// In en, this message translates to:
  /// **'At their own pace'**
  String get aboutPaceTitle;

  /// No description provided for @aboutPaceBody.
  ///
  /// In en, this message translates to:
  /// **'Different grades and activities make room for every little explorer.'**
  String get aboutPaceBody;

  /// No description provided for @aboutFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Made for learning together'**
  String get aboutFamilyTitle;

  /// No description provided for @aboutFamilyBody.
  ///
  /// In en, this message translates to:
  /// **'A project born at home, to make math part of everyday life.'**
  String get aboutFamilyBody;

  /// No description provided for @aboutDeveloperTitle.
  ///
  /// In en, this message translates to:
  /// **'About the developer'**
  String get aboutDeveloperTitle;

  /// No description provided for @aboutDeveloperSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The person behind MathQuest'**
  String get aboutDeveloperSubtitle;

  /// No description provided for @aboutDeveloperBio.
  ///
  /// In en, this message translates to:
  /// **'Hi, I’m @christhoval, a full-stack engineer and Front-End Tech Lead based in Panama. I work with JavaScript and Python, and build CLI tools, npm packages, and mobile apps. I care about useful products, thoughtful UX, and privacy by design. MathQuest grew out of a simple wish: to help Dion enjoy learning math.'**
  String get aboutDeveloperBio;

  /// No description provided for @developerRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Current role'**
  String get developerRoleTitle;

  /// No description provided for @developerRoleBody.
  ///
  /// In en, this message translates to:
  /// **'Full-stack engineer & Front-End Tech Lead.'**
  String get developerRoleBody;

  /// No description provided for @developerStackTitle.
  ///
  /// In en, this message translates to:
  /// **'Main stack'**
  String get developerStackTitle;

  /// No description provided for @developerStackBody.
  ///
  /// In en, this message translates to:
  /// **'JavaScript, TypeScript, Python, Flutter, CLI, and npm.'**
  String get developerStackBody;

  /// No description provided for @developerFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'My focus'**
  String get developerFocusTitle;

  /// No description provided for @developerFocusBody.
  ///
  /// In en, this message translates to:
  /// **'Product, user experience, and privacy by design.'**
  String get developerFocusBody;

  /// No description provided for @contactSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact / Support'**
  String get contactSupportTitle;

  /// No description provided for @contactSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report a bug or share an idea'**
  String get contactSupportSubtitle;

  /// No description provided for @supportEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'MathQuest — Support'**
  String get supportEmailSubject;

  /// No description provided for @supportEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Hello Christhoval,\n\nI’m contacting you about MathQuest:\n\n'**
  String get supportEmailBody;

  /// No description provided for @supportEmailUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No email app is available. You can write to me at the address below.'**
  String get supportEmailUnavailable;

  /// No description provided for @copyEmail.
  ///
  /// In en, this message translates to:
  /// **'Copy email address'**
  String get copyEmail;

  /// No description provided for @emailCopied.
  ///
  /// In en, this message translates to:
  /// **'Email address copied'**
  String get emailCopied;

  /// No description provided for @landingPageTitle.
  ///
  /// In en, this message translates to:
  /// **'MathQuest · Little steps. Cosmic confidence.'**
  String get landingPageTitle;

  /// No description provided for @landingNavLearning.
  ///
  /// In en, this message translates to:
  /// **'How they learn'**
  String get landingNavLearning;

  /// No description provided for @landingNavModes.
  ///
  /// In en, this message translates to:
  /// **'Ways to play'**
  String get landingNavModes;

  /// No description provided for @landingNavParents.
  ///
  /// In en, this message translates to:
  /// **'For parents'**
  String get landingNavParents;

  /// No description provided for @landingNavGallery.
  ///
  /// In en, this message translates to:
  /// **'Inside the app'**
  String get landingNavGallery;

  /// No description provided for @landingLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get landingLanguageLabel;

  /// No description provided for @landingStartAction.
  ///
  /// In en, this message translates to:
  /// **'Download on the App Store'**
  String get landingStartAction;

  /// No description provided for @landingExploreAction.
  ///
  /// In en, this message translates to:
  /// **'Explore game modes'**
  String get landingExploreAction;

  /// No description provided for @landingHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'SMALL STEPS. BIG DISCOVERIES.'**
  String get landingHeroEyebrow;

  /// No description provided for @landingHeroLead.
  ///
  /// In en, this message translates to:
  /// **'Turn math into a'**
  String get landingHeroLead;

  /// No description provided for @landingHeroAccent.
  ///
  /// In en, this message translates to:
  /// **'cosmic adventure.'**
  String get landingHeroAccent;

  /// No description provided for @landingHeroDescription.
  ///
  /// In en, this message translates to:
  /// **'A little practice. A lot of “I did it!” Help your child build real confidence with visual math, playful challenges, and a universe of small wins.'**
  String get landingHeroDescription;

  /// No description provided for @landingProofOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline-ready'**
  String get landingProofOffline;

  /// No description provided for @landingProofAds.
  ///
  /// In en, this message translates to:
  /// **'No ads. Just discovery.'**
  String get landingProofAds;

  /// No description provided for @landingProofProfiles.
  ///
  /// In en, this message translates to:
  /// **'Room for every little hero'**
  String get landingProofProfiles;

  /// No description provided for @landingDailyBadge.
  ///
  /// In en, this message translates to:
  /// **'A little win, every day'**
  String get landingDailyBadge;

  /// No description provided for @landingDailyBadgeDetail.
  ///
  /// In en, this message translates to:
  /// **'Their next adventure is waiting.'**
  String get landingDailyBadgeDetail;

  /// No description provided for @landingStatOperations.
  ///
  /// In en, this message translates to:
  /// **'Essential operations'**
  String get landingStatOperations;

  /// No description provided for @landingStatDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Levels to grow with them'**
  String get landingStatDifficulty;

  /// No description provided for @landingStatWorlds.
  ///
  /// In en, this message translates to:
  /// **'Worlds to explore'**
  String get landingStatWorlds;

  /// No description provided for @landingStatAds.
  ///
  /// In en, this message translates to:
  /// **'Ads in their way'**
  String get landingStatAds;

  /// No description provided for @landingLearningEyebrow.
  ///
  /// In en, this message translates to:
  /// **'UNDERSTANDING BEFORE MEMORIZING'**
  String get landingLearningEyebrow;

  /// No description provided for @landingLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Math is easier when\nthey can see it.'**
  String get landingLearningTitle;

  /// No description provided for @landingLearningIntro.
  ///
  /// In en, this message translates to:
  /// **'From “what does this mean?” to “I know how!” Make abstract ideas click with friendly, visual helpers.'**
  String get landingLearningIntro;

  /// No description provided for @landingBlocksTitle.
  ///
  /// In en, this message translates to:
  /// **'Big ideas. Little blocks.'**
  String get landingBlocksTitle;

  /// No description provided for @landingBlocksBody.
  ///
  /// In en, this message translates to:
  /// **'Tens-rods and ones-dots make place value, carrying, and counting feel wonderfully concrete.'**
  String get landingBlocksBody;

  /// No description provided for @landingEncouragementTitle.
  ///
  /// In en, this message translates to:
  /// **'A safe space to try again'**
  String get landingEncouragementTitle;

  /// No description provided for @landingEncouragementBody.
  ///
  /// In en, this message translates to:
  /// **'Helpful hints and gentle encouragement keep curiosity going, even when an answer takes another try.'**
  String get landingEncouragementBody;

  /// No description provided for @landingPaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Their pace. Their lightbulb moment.'**
  String get landingPaceTitle;

  /// No description provided for @landingPaceBody.
  ///
  /// In en, this message translates to:
  /// **'Start with visual support, then build toward independent problem solving, one small step at a time.'**
  String get landingPaceBody;

  /// No description provided for @landingModesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'SERIOUS LEARNING. PLAYFUL POSSIBILITIES.'**
  String get landingModesEyebrow;

  /// No description provided for @landingModesTitle.
  ///
  /// In en, this message translates to:
  /// **'Different moods.\nA whole universe of ways to play.'**
  String get landingModesTitle;

  /// No description provided for @landingModesIntro.
  ///
  /// In en, this message translates to:
  /// **'A quiet practice session or a friendly face-off? There’s a little adventure for every kind of learner.'**
  String get landingModesIntro;

  /// No description provided for @landingPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice Arena'**
  String get landingPracticeTitle;

  /// No description provided for @landingPracticeBody.
  ///
  /// In en, this message translates to:
  /// **'Take a breath, try a strategy, and let the visual helpers guide the way.'**
  String get landingPracticeBody;

  /// No description provided for @landingPracticeTag.
  ///
  /// In en, this message translates to:
  /// **'NO RUSH. JUST PROGRESS.'**
  String get landingPracticeTag;

  /// No description provided for @landingDuelTitle.
  ///
  /// In en, this message translates to:
  /// **'2-Player Duel'**
  String get landingDuelTitle;

  /// No description provided for @landingDuelBody.
  ///
  /// In en, this message translates to:
  /// **'One screen. Two explorers. Turn practice into a friendly challenge together.'**
  String get landingDuelBody;

  /// No description provided for @landingDuelTag.
  ///
  /// In en, this message translates to:
  /// **'BETTER TOGETHER'**
  String get landingDuelTag;

  /// No description provided for @landingMissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Missions'**
  String get landingMissionTitle;

  /// No description provided for @landingMissionBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the operation, difficulty, and timer. Make a mission that fits today.'**
  String get landingMissionBody;

  /// No description provided for @landingMissionTag.
  ///
  /// In en, this message translates to:
  /// **'THEIR VERY OWN QUEST'**
  String get landingMissionTag;

  /// No description provided for @landingWorldTitle.
  ///
  /// In en, this message translates to:
  /// **'Adventure Island'**
  String get landingWorldTitle;

  /// No description provided for @landingWorldBody.
  ///
  /// In en, this message translates to:
  /// **'Follow a path of little challenges and discover what’s around the next corner.'**
  String get landingWorldBody;

  /// No description provided for @landingWorldTag.
  ///
  /// In en, this message translates to:
  /// **'KEEP EXPLORING'**
  String get landingWorldTag;

  /// No description provided for @landingRewardsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'A LITTLE EFFORT DESERVES A BIG HIGH-FIVE'**
  String get landingRewardsEyebrow;

  /// No description provided for @landingRewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Celebrate grit.\nGrow their glow.'**
  String get landingRewardsTitle;

  /// No description provided for @landingRewardsIntro.
  ///
  /// In en, this message translates to:
  /// **'Every small win is a reason to come back. MathQuest makes progress something they can see, collect, and feel proud of.'**
  String get landingRewardsIntro;

  /// No description provided for @landingCoinsTitle.
  ///
  /// In en, this message translates to:
  /// **'Star Coins'**
  String get landingCoinsTitle;

  /// No description provided for @landingCoinsBody.
  ///
  /// In en, this message translates to:
  /// **'A little sparkle for their effort.'**
  String get landingCoinsBody;

  /// No description provided for @landingStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily streaks'**
  String get landingStreakTitle;

  /// No description provided for @landingStreakBody.
  ///
  /// In en, this message translates to:
  /// **'Build a habit, one happy day at a time.'**
  String get landingStreakBody;

  /// No description provided for @landingBadgesTitle.
  ///
  /// In en, this message translates to:
  /// **'Trophies to treasure'**
  String get landingBadgesTitle;

  /// No description provided for @landingBadgesBody.
  ///
  /// In en, this message translates to:
  /// **'Milestones that make them say “look!”'**
  String get landingBadgesBody;

  /// No description provided for @landingWorldsTitle.
  ///
  /// In en, this message translates to:
  /// **'New worlds'**
  String get landingWorldsTitle;

  /// No description provided for @landingWorldsBody.
  ///
  /// In en, this message translates to:
  /// **'Fresh places for curious minds.'**
  String get landingWorldsBody;

  /// No description provided for @landingParentEyebrow.
  ///
  /// In en, this message translates to:
  /// **'FOR THEIR GROWN-UPS'**
  String get landingParentEyebrow;

  /// No description provided for @landingParentTitle.
  ///
  /// In en, this message translates to:
  /// **'Less guesswork.\nMore “look how far you’ve come.”'**
  String get landingParentTitle;

  /// No description provided for @landingParentIntro.
  ///
  /// In en, this message translates to:
  /// **'Stay close to their learning without hovering over every answer. Clear reports help you see their next small step.'**
  String get landingParentIntro;

  /// No description provided for @landingReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress you can understand'**
  String get landingReportTitle;

  /// No description provided for @landingReportBody.
  ///
  /// In en, this message translates to:
  /// **'See accuracy, practice activity, and the skills that could use a little extra love.'**
  String get landingReportBody;

  /// No description provided for @landingProfilesTitle.
  ///
  /// In en, this message translates to:
  /// **'A space for each child'**
  String get landingProfilesTitle;

  /// No description provided for @landingProfilesBody.
  ///
  /// In en, this message translates to:
  /// **'Separate profiles keep every explorer’s progress their own.'**
  String get landingProfilesBody;

  /// No description provided for @landingControlsTitle.
  ///
  /// In en, this message translates to:
  /// **'Healthy boundaries, built in'**
  String get landingControlsTitle;

  /// No description provided for @landingControlsBody.
  ///
  /// In en, this message translates to:
  /// **'Set screen-time limits and keep grown-up settings behind a parent gate.'**
  String get landingControlsBody;

  /// No description provided for @landingGalleryEyebrow.
  ///
  /// In en, this message translates to:
  /// **'MADE FOR LITTLE HANDS'**
  String get landingGalleryEyebrow;

  /// No description provided for @landingGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Take a peek at their next adventure.'**
  String get landingGalleryTitle;

  /// No description provided for @landingGalleryPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous screenshots'**
  String get landingGalleryPrevious;

  /// No description provided for @landingGalleryNext.
  ///
  /// In en, this message translates to:
  /// **'Next screenshots'**
  String get landingGalleryNext;

  /// No description provided for @landingScreenWelcome.
  ///
  /// In en, this message translates to:
  /// **'A warm welcome'**
  String get landingScreenWelcome;

  /// No description provided for @landingScreenProfile.
  ///
  /// In en, this message translates to:
  /// **'Create their hero'**
  String get landingScreenProfile;

  /// No description provided for @landingScreenDaily.
  ///
  /// In en, this message translates to:
  /// **'Little daily quests'**
  String get landingScreenDaily;

  /// No description provided for @landingScreenBlocks.
  ///
  /// In en, this message translates to:
  /// **'See the math'**
  String get landingScreenBlocks;

  /// No description provided for @landingScreenDuel.
  ///
  /// In en, this message translates to:
  /// **'Share the challenge'**
  String get landingScreenDuel;

  /// No description provided for @landingScreenTrophies.
  ///
  /// In en, this message translates to:
  /// **'Celebrate every step'**
  String get landingScreenTrophies;

  /// No description provided for @landingScreenReport.
  ///
  /// In en, this message translates to:
  /// **'Understand their progress'**
  String get landingScreenReport;

  /// No description provided for @landingScreenSettings.
  ///
  /// In en, this message translates to:
  /// **'Make it feel like theirs'**
  String get landingScreenSettings;

  /// No description provided for @landingDownloadEyebrow.
  ///
  /// In en, this message translates to:
  /// **'THE NEXT “I DID IT!” STARTS HERE'**
  String get landingDownloadEyebrow;

  /// No description provided for @landingDownloadTitle.
  ///
  /// In en, this message translates to:
  /// **'Small steps today.\nMath superpowers tomorrow.'**
  String get landingDownloadTitle;

  /// No description provided for @landingDownloadBody.
  ///
  /// In en, this message translates to:
  /// **'Give their curiosity a place to play. Get MathQuest on the App Store and start your family’s next adventure.'**
  String get landingDownloadBody;

  /// No description provided for @landingEmailFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not open your email app. Write to me@christhoval.dev.'**
  String get landingEmailFailure;

  /// No description provided for @landingEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'MathQuest support'**
  String get landingEmailSubject;

  /// No description provided for @landingEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Hello! I need help with MathQuest.'**
  String get landingEmailBody;

  /// No description provided for @landingFooterLine.
  ///
  /// In en, this message translates to:
  /// **'A little practice. A lifetime of possibility.'**
  String get landingFooterLine;

  /// No description provided for @landingFooterCredit.
  ///
  /// In en, this message translates to:
  /// **'Made with care for curious minds.'**
  String get landingFooterCredit;

  /// No description provided for @landingBackToTop.
  ///
  /// In en, this message translates to:
  /// **'Back to top'**
  String get landingBackToTop;

  /// No description provided for @landingCloseMenu.
  ///
  /// In en, this message translates to:
  /// **'Close navigation'**
  String get landingCloseMenu;

  /// No description provided for @landingOpenMenu.
  ///
  /// In en, this message translates to:
  /// **'Open navigation'**
  String get landingOpenMenu;

  /// No description provided for @landingContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact & support'**
  String get landingContactLabel;

  /// No description provided for @landingDownloadAction.
  ///
  /// In en, this message translates to:
  /// **'Download on the App Store'**
  String get landingDownloadAction;

  /// No description provided for @landingDownloadNote.
  ///
  /// In en, this message translates to:
  /// **'Available on the App Store.'**
  String get landingDownloadNote;

  /// No description provided for @landingDownloadFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not open the App Store. Please try again.'**
  String get landingDownloadFailure;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
