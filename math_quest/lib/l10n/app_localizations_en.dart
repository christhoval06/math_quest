// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MathQuest';

  @override
  String get tapToStart => 'Tap to Start Adventure!';

  @override
  String playingAs(String name, String grade) {
    return 'Playing as: $name ($grade)';
  }

  @override
  String dayStreak(int count) {
    return '$count Day Streak!';
  }

  @override
  String get todaysMission => 'TODAY\'S MISSION';

  @override
  String get solveAddition => 'Solve 10 Addition Puzzles';

  @override
  String get continueMission => 'Continue Mission';

  @override
  String get gameModes => 'Game Modes';

  @override
  String get allUnlocked => 'All Unlocked';

  @override
  String get quickPlay => 'Quick Play';

  @override
  String get practiceArena => 'Practice Arena';

  @override
  String get adventureIsland => 'Adventure Island';

  @override
  String get buddyChallenge => 'Buddy Challenge';

  @override
  String get practiceLab => 'PRACTICE LAB';

  @override
  String get customMission => 'Custom Math Mission';

  @override
  String get chooseOperation => 'Choose Operation';

  @override
  String get chooseDifficulty => 'Difficulty (Number of Digits)';

  @override
  String get chooseTimer => 'Choose Timer / Pace';

  @override
  String get funHelpers => 'Fun Helpers';

  @override
  String get visualCountingAids => 'Visual Counting Aids';

  @override
  String get soundEffectsCheering => 'Sound Effects & Cheering';

  @override
  String get launchMission => 'Launch Math Mission! (10 Questions)';

  @override
  String get pickYourAnswer => 'Pick your answer:';

  @override
  String get skip => 'Skip';

  @override
  String get checkAnswer => 'Check Answer!';

  @override
  String get correctTitle => 'Awesome Job! 🌟';

  @override
  String get wrongTitle => 'Not quite right!';

  @override
  String get continueBtn => 'Continue';

  @override
  String get questComplete => 'Quest Complete!';

  @override
  String get roundStats => 'Round Stats';

  @override
  String get correctAnswers => 'Correct Answers';

  @override
  String get averageSpeed => 'Average Speed';

  @override
  String get playAnotherRound => 'Play Another Round';

  @override
  String get reviewMistakes => 'Review Mistakes';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get trophyRoomTitle => 'Trophy Room & Stats';

  @override
  String get weeklyPractice => 'Weekly Practice';

  @override
  String get mathMasteryTracks => 'Math Mastery Tracks';

  @override
  String get recentBadges => 'Recent Badges';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'App Language';

  @override
  String get parentGateTitle => 'Grown-Ups Zone';

  @override
  String parentGatePrompt(int num1, int num2) {
    return 'Please ask a grown-up to solve: What is $num1 × $num2?';
  }

  @override
  String get navPlay => 'Play';

  @override
  String get navPractice => 'Practice';

  @override
  String get navQuest => 'Quest';

  @override
  String get navTrophies => 'Trophies';

  @override
  String get settingsLabel => 'APP SETTINGS';

  @override
  String get personalizeQuest => 'Personalize Quest!';

  @override
  String get settingsDescription =>
      'Adjust sounds, switch profiles & manage parent rules.';

  @override
  String get soundsAndWorld => 'Sounds & Adventure World';

  @override
  String get soundEffects => 'Sound Effects (SFX)';

  @override
  String get gameMelodies => 'Game Melodies';

  @override
  String get voiceReadAloud => 'Voice Read-Aloud';

  @override
  String get voiceReadAloudDescription =>
      'Reads word problems out loud automatically';

  @override
  String get hapticTouch => 'Haptic Touch Buzz';

  @override
  String get hapticTouchDescription =>
      'Feel answer taps and correct or incorrect feedback';

  @override
  String get selectLanguage => '🌐 Select Language';

  @override
  String get responseMode => 'Response Mode';

  @override
  String get responseModeDescription =>
      'Choose how answers are entered throughout the app.';

  @override
  String get responseChoice => 'Choice';

  @override
  String get responseWrite => 'Write';

  @override
  String get responseChoiceDescription => 'Pick from four answers';

  @override
  String get responseWriteDescription => 'Type the answer';

  @override
  String responseModeSemantics(String mode) {
    return '$mode response mode';
  }

  @override
  String get gameVisualTheme => 'Game Visual Theme';

  @override
  String get themeGalaxy => 'Galaxy Quest';

  @override
  String get themeGalaxyDescription => 'Deep space';

  @override
  String get themeCandy => 'Candy Land';

  @override
  String get themeCandyDescription => 'Sweet hills';

  @override
  String get themeDino => 'Dino Math';

  @override
  String get themeDinoDescription => 'Prehistoric';

  @override
  String get themeUnderwater => 'Underwater';

  @override
  String get themeUnderwaterDescription => 'Coral reef';

  @override
  String get whosPlaying => 'Who\'s Playing?';

  @override
  String profileSlotsUsed(int count) {
    return '$count of 3 slots used';
  }

  @override
  String get profilesUnavailable => 'Profiles unavailable';

  @override
  String get addChildProfile => 'Add New Child Profile';

  @override
  String get allProfileSlotsUsed => 'All 3 profile slots in use';

  @override
  String profileLevel(int level) {
    return 'Lvl $level';
  }

  @override
  String get profileActive => 'Active';

  @override
  String get switchProfile => 'Switch';

  @override
  String safeKidsEdition(String version) {
    return 'MathQuest v$version (Safe Kids Edition)';
  }

  @override
  String get localProgressBackup =>
      'All game progress backed up safely in local storage.';

  @override
  String get parentZone => 'Parent Gate Zone';

  @override
  String get parentZoneDescription =>
      'Adults Only: Curriculums, timers & reports';

  @override
  String dailyScreenLimit(String name) {
    return 'Daily Screen Limit ($name)';
  }

  @override
  String get unlimited => 'Unlimited';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get targetMathStandard => 'Target Math Standard';

  @override
  String get gradePreK => 'Pre-K';

  @override
  String get gradeOne => 'Grade 1';

  @override
  String get gradeTwo => 'Grade 2';

  @override
  String get gradeThreePlus => 'Grade 3+';

  @override
  String get resetCurrentHero => 'Reset Adventure Progress for Current Hero';

  @override
  String get resetProgressTitle => 'Reset All Progress?';

  @override
  String get resetProgressDescription =>
      'This will lock all completed stages and worlds, resetting Adventure Island back to Stage 1. Are you sure?';

  @override
  String get cancel => 'Cancel';

  @override
  String get resetNow => 'Reset Now';

  @override
  String get hero => 'Hero';

  @override
  String get profileSwitched => 'Profile switched! 🚀';

  @override
  String switchedToProfile(String name) {
    return 'Switched to $name! 🚀';
  }

  @override
  String screenLimitUpdated(String limit) {
    return 'Screen limit updated to $limit!';
  }

  @override
  String minutesLong(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String targetStandardUpdated(String standard) {
    return 'Target Math Standard set to $standard!';
  }

  @override
  String get adventureProgressReset =>
      '✅ Adventure Island has been reset to Stage 1!';

  @override
  String get settingsUpdateFailed =>
      'Could not update settings. Please try again.';

  @override
  String explorerName(String name) {
    return 'Explorer $name';
  }

  @override
  String get readyForQuest => 'Ready for your quest?';

  @override
  String get starryWaiting => 'Starry is waiting at the Cosmic Summit!';

  @override
  String get streakLabel => 'STREAK';

  @override
  String get starsLabel => 'STARS';

  @override
  String get rankLabel => 'RANK';

  @override
  String daysShort(int count) {
    return '${count}d';
  }

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Days',
      one: '1 Day',
    );
    return '$_temp0';
  }

  @override
  String get quickPlayDuration => '2 Min';

  @override
  String get customModeBadge => 'Custom';

  @override
  String get storyModeBadge => 'Story';

  @override
  String get twoPlayersBadge => '2 Players';

  @override
  String get quickPlayDescription => 'Beat the ticking clock with snappy math!';

  @override
  String get practiceDescription => 'Choose operations, digits & pace.';

  @override
  String get adventureDescription => 'Defeat math monsters & find treasure.';

  @override
  String get buddyDescription => 'Pass & play duel with friends or family.';

  @override
  String get playNowAction => 'Play Now →';

  @override
  String get configureAction => 'Configure →';

  @override
  String get exploreAction => 'Explore →';

  @override
  String get battleAction => 'Battle →';

  @override
  String missionProgress(int current, int total) {
    return '$current of $total completed';
  }

  @override
  String dailyMissionReward(int coins, String badge) {
    return 'Reward: $coins Star Coins & $badge';
  }

  @override
  String get missionCompletedToday => 'Mission Completed for Today! 🎉';

  @override
  String claimMissionReward(int coins) {
    return 'Claim $coins Coins & Badge! 🎁';
  }

  @override
  String missionRewardAdded(int coins, String badge) {
    return '🎁 +$coins Star Coins and $badge added!';
  }

  @override
  String get superpowerTipHeading => 'SUPERPOWER SECRET • Today\'s Tip';

  @override
  String get tryNextChallenge => 'Try it in your next challenge! →';

  @override
  String get missionLabDescription =>
      'Pick your math superpower and challenge rules!';

  @override
  String get practiceMode => '🎮 Practice Mode';

  @override
  String get examChallenge => '📝 Exam Challenge';

  @override
  String get selectOperation => 'Select operation';

  @override
  String get operationAddition => 'Addition';

  @override
  String get operationSubtraction => 'Subtraction';

  @override
  String get operationMultiplication => 'Multiplication';

  @override
  String get operationDivision => 'Division';

  @override
  String get appleCounters => 'Apple counters';

  @override
  String get balloonPops => 'Balloon pops';

  @override
  String get boosters => 'Boosters';

  @override
  String get pizzaSlices => 'Pizza slices';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get easyDigits => '1 Digit (3 + 5)';

  @override
  String get mediumDigits => '2 Digits (24 + 38)';

  @override
  String get hardDigits => '3 Digits (145 + 289)';

  @override
  String get easyDescription => 'Gentle warm-up for beginners';

  @override
  String get mediumDescription => 'Elementary challenge & brain workout';

  @override
  String get hardDescription => 'Math superhero level!';

  @override
  String get noTimer => 'No Timer';

  @override
  String get relaxAndLearn => 'Relax & Learn';

  @override
  String secondsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seconds',
      one: '1 Second',
    );
    return '$_temp0';
  }

  @override
  String get twoMinutes => '2 Minutes';

  @override
  String get rapidDash => 'Rapid Dash';

  @override
  String get standardPace => 'Standard Pace';

  @override
  String get deepFocus => 'Deep Focus';

  @override
  String get visualAidsDescription => 'Show interactive blocks & dot grid';

  @override
  String get soundCheeringDescription => 'Bubbly pops & joyful mascot chimes';

  @override
  String get numberOfQuestions => 'Number of Questions';

  @override
  String questionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Questions',
      one: '1 Question',
    );
    return '$_temp0';
  }

  @override
  String get completionReward =>
      'Reward Upon Completion: +50 Stars & 1 Quest Key';

  @override
  String get missionRewardXp => '100 XP';

  @override
  String launchMissionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Questions',
      one: '1 Question',
    );
    return 'Launch Mission! ($_temp0)';
  }

  @override
  String startExamCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Questions',
      one: '1 Question',
    );
    return 'Start Exam ($_temp0)';
  }

  @override
  String dailyAdditionTitle(int count) {
    return 'Solve $count Addition Puzzles';
  }

  @override
  String dailySubtractionTitle(int count) {
    return 'Solve $count Subtraction Puzzles';
  }

  @override
  String dailyMultiplicationTitle(int count) {
    return 'Solve $count Multiplication Puzzles';
  }

  @override
  String dailyDivisionTitle(int count) {
    return 'Solve $count Division Puzzles';
  }

  @override
  String get spaceDetectiveBadge => 'Space Detective Badge';

  @override
  String get balloonPopperBadge => 'Balloon Popper Badge';

  @override
  String get lightningBoosterBadge => 'Lightning Booster Badge';

  @override
  String get pizzaMasterBadge => 'Pizza Master Badge';

  @override
  String get tipDoublesTitle => 'The \"Doubles + 1\" Trick!';

  @override
  String get tipDoublesDescription =>
      'If you know 6 + 6 = 12, then 6 + 7 is super easy: just add 1 more to reach 13!';

  @override
  String get tipMakeTenTitle => 'The \"Make a 10\" Secret!';

  @override
  String get tipMakeTenDescription =>
      '8 + 5 looks hard? Take 2 from the 5 to turn 8 into 10! Then 10 + 3 = 13!';

  @override
  String get tipSubtractTenTitle => 'The \"Drop to 10\" Trick!';

  @override
  String get tipSubtractTenDescription =>
      'Solving 15 - 7? First drop 5 to hit 10, then drop the remaining 2 to get 8!';

  @override
  String get tipTimesFiveTitle => 'The \"Multiply by 5\" Hack!';

  @override
  String get tipTimesFiveDescription =>
      '6 × 5? Just add a zero to get 60, then take half of that: 30! Works every time!';

  @override
  String get tipNinesTitle => 'The Magic of 9s!';

  @override
  String get tipNinesDescription =>
      'The digits of 9 times table always add up to 9! 9 × 3 = 27 (2+7=9). 9 × 4 = 36 (3+6=9)!';

  @override
  String get tipHalvingTitle => 'Divide by 4 by Halving Twice!';

  @override
  String get tipHalvingDescription =>
      'To divide by 4, just cut the number in half, and then in half again! 28 → 14 → 7!';

  @override
  String get tipZeroTitle => 'The \"Zero Hero\" Rule!';

  @override
  String get tipZeroDescription =>
      'Any number plus zero stays itself, but any number times zero always vanishes to 0!';

  @override
  String get tapCorrectAnswer => 'Tap the correct answer:';

  @override
  String get writeCorrectAnswer => 'Write the correct answer:';

  @override
  String get matchSetup => 'Match Setup';

  @override
  String get questionReview => 'Question Review';

  @override
  String get nextStage => 'Next Stage 🚀';

  @override
  String get playAnotherRoundAction => 'Play Another Round 🔄';

  @override
  String reviewMistakesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mistakes',
      one: '1 Mistake',
    );
    return 'Review $_temp0 🎯';
  }

  @override
  String get backAdventureMap => 'Back to Adventure Map 🏝️';

  @override
  String get backHomeAction => 'Back to Home 🏠';

  @override
  String targetBoss(String name) {
    return 'Target Boss: $name';
  }

  @override
  String worldTitle(int index, String name) {
    return 'World $index: $name';
  }

  @override
  String get switchIsland => 'Switch Island';

  @override
  String get countingHelpers => 'Counting Helpers';

  @override
  String get tensAndOnes => 'Tens & Ones';

  @override
  String numberDecomposition(int value, int tens, int ones) {
    return '$value ($tens Tens, $ones Ones)';
  }

  @override
  String startBuddyChallenge(int points) {
    return 'Start Buddy Challenge! (First to $points Points)';
  }

  @override
  String get buddyRulesDescription =>
      'Choose your players and challenge rules!';

  @override
  String get buddyArena => 'BUDDY ARENA';

  @override
  String get playerOne => 'Player 1';

  @override
  String get playerTwo => 'Player 2';

  @override
  String get playerNames => 'Player Names';

  @override
  String get pointsToWin => 'Points to Win';

  @override
  String pointsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Points',
      one: '1 Point',
    );
    return '$_temp0';
  }

  @override
  String get pointsTargetDescription => 'First player to reach the target wins';

  @override
  String buddyScore(int score1, int score2) {
    return 'P1: $score1  vs  P2: $score2';
  }

  @override
  String firstToPoints(int points) {
    return 'First to $points points';
  }

  @override
  String winnerName(String name) {
    return '$name Wins!';
  }

  @override
  String get outstandingReflexes => 'Outstanding math reflexes!';

  @override
  String get playAgain => 'Play Again';

  @override
  String get changeSettings => 'Change Settings';

  @override
  String get exit => 'Exit';

  @override
  String get champion => 'CHAMPION';

  @override
  String finalScoreSemantics(int score1, int score2) {
    return 'Final score: Player 1, $score1; Player 2, $score2';
  }

  @override
  String get finalScore => 'FINAL SCORE';

  @override
  String correctAnswerExplanation(String answer) {
    return 'The correct answer is $answer. Keep going, explorer!';
  }

  @override
  String get sparkyAdvice =>
      'Sparky says: Take your time and think it through!';

  @override
  String get worldBossDefeated => 'WORLD BOSS DEFEATED!';

  @override
  String welcomeToWorld(String name) {
    return 'Welcome to $name!';
  }

  @override
  String get newIslandDescription =>
      'A new island has appeared on your map with new math challenges and a legendary Boss!';

  @override
  String get exploreNewIsland => 'Explore New Island! 🚀';

  @override
  String starCoinsReward(int count) {
    return '+$count Star Coins';
  }

  @override
  String mathXpReward(int count) {
    return '+$count Math XP';
  }

  @override
  String accuracyPercent(int percent) {
    return '$percent% Accuracy';
  }

  @override
  String averageSecondsItem(double seconds) {
    final intl.NumberFormat secondsNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String secondsString = secondsNumberFormat.format(seconds);

    return '${secondsString}s / item';
  }

  @override
  String elapsedSeconds(double seconds) {
    final intl.NumberFormat secondsNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String secondsString = secondsNumberFormat.format(seconds);

    return '${secondsString}s';
  }

  @override
  String get stellaCoach => 'STAR COACH STELLA';

  @override
  String stellaExcellent(String name) {
    return '\"Outstanding, $name! You totally rocked this mission!\"';
  }

  @override
  String get stellaEncouragement =>
      '\"Great effort, math explorer! Every mistake helps your brain grow!\"';

  @override
  String get tryAgainTitle => 'Try Again!';

  @override
  String get mistakeCorrected => '🎉 Awesome! You corrected your mistake!';

  @override
  String get useCountingBlocks => 'Not quite! Use the blocks to count.';

  @override
  String get close => 'Close';

  @override
  String chosenAnswer(String answer) {
    return 'You chose: $answer';
  }

  @override
  String get noAnswer => 'None';

  @override
  String get retry => 'Retry';

  @override
  String get countingHint =>
      'Hint: Take your time and use the tens and ones blocks!';

  @override
  String get correctedSuccessfully => '🌟 Corrected successfully!';

  @override
  String starsEarned(int count) {
    return '$count OF 3 STARS EARNED';
  }

  @override
  String get newBadgeUnlocked => 'NEW BADGE UNLOCKED!';

  @override
  String get correctAnswerSemantics => 'Correct answer';

  @override
  String get incorrectAnswerSemantics => 'Incorrect answer';

  @override
  String get writtenAnswerSemantics => 'Written answer';

  @override
  String get retryAnswerSemantics => 'Try checking the answer again';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get checkWrittenAnswer => 'Check Answer';

  @override
  String get tryAgainTooltip => 'Try again';

  @override
  String get checkAnswerTooltip => 'Check answer';

  @override
  String get deleteDigit => 'Delete digit';

  @override
  String get checkingAnswer => 'Checking answer';

  @override
  String get checkingStatus => 'Checking…';

  @override
  String examStageLabel(int current, int total) {
    return 'EXAM CHALLENGE ($current/$total)';
  }

  @override
  String operationAdventure(String operation) {
    return '$operation ADVENTURE';
  }

  @override
  String adventureNamePart(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'p0': 'Emerald',
      'p1': 'Sunny',
      'p2': 'Whispering',
      'p3': 'Verdant',
      'p4': 'Golden',
      'p5': 'Atoll',
      'p6': 'Island',
      'p7': 'Shores',
      'p8': 'Meadow',
      'p9': 'Haven',
      'p10': 'Sugarplum',
      'p11': 'Cotton Candy',
      'p12': 'Lollipop',
      'p13': 'Caramel',
      'p14': 'Sweet',
      'p15': 'Canyon',
      'p16': 'Isle',
      'p17': 'Reef',
      'p18': 'Lagoon',
      'p19': 'Kingdom',
      'p20': 'Prehistoric',
      'p21': 'Thunder',
      'p22': 'Jurassic',
      'p23': 'Amber',
      'p24': 'Ancient',
      'p25': 'Jungle',
      'p26': 'Crag',
      'p27': 'Wilds',
      'p28': 'Sanctuary',
      'p29': 'Astral',
      'p30': 'Starfall',
      'p31': 'Starlight',
      'p32': 'Galactic',
      'p33': 'Cosmic',
      'p34': 'Summit',
      'p35': 'Archipelago',
      'p36': 'Peaks',
      'p37': 'Nebula',
      'p38': 'Spire',
      'p39': 'Sunken',
      'p40': 'Azure',
      'p41': 'Tidal',
      'p42': 'Sapphire',
      'p43': 'Aquamarine',
      'p44': 'Cove',
      'p45': 'Cay',
      'p46': 'Abyss',
      'p47': 'Deep',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String adventureLandmark(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      's0': 'Pebble Beach',
      's1': 'Bamboo Grove',
      's2': 'Clover Valley',
      's3': 'Waterfall Ridge',
      's4': 'Golem’s Fortress',
      's5': 'Gummy Shore',
      's6': 'Marshmallow Trail',
      's7': 'Chocolate River',
      's8': 'Lollipop Peak',
      's9': 'Dragon’s Candy Keep',
      's10': 'Fossil Beach',
      's11': 'Fern Canopy',
      's12': 'Raptor Ravine',
      's13': 'Volcano Foothills',
      's14': 'T-Rex Throne Room',
      's15': 'Stardust Basin',
      's16': 'Meteor Bridge',
      's17': 'Aurora Ridge',
      's18': 'Gravity Well',
      's19': 'Titan’s Observatory',
      's20': 'Clownfish Cove',
      's21': 'Shell Cavern',
      's22': 'Sunken Galleon',
      's23': 'Pearl Trench',
      's24': 'Kraken’s Sunken Lair',
      's25': 'Stone Golem',
      's26': 'Sugar Dragon',
      's27': 'T-Rex Math King',
      's28': 'Star Titan',
      's29': 'Kraken Lord',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String gameBadgeTitle(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'speed_counter': 'Speed Counter',
      'lightning_math': 'Lightning Math',
      'quick_thinker': 'Quick Thinker',
      'clean_slate': 'Zero Mistake Hero',
      'sharp_shooter': 'Sharp Shooter',
      'flawless_focus': 'Flawless Focus',
      'early_starter': 'Habit Starter',
      'week_warrior': 'Week Warrior',
      'fortnight_legend': 'Fortnight Titan',
      'half_century': 'First Fifty',
      'century_club': 'Century Club',
      'grand_master_500': 'Math Marathoner',
      'millennium_scholar': 'Millennium Scholar',
      'addition_superhero': 'Sum Hero',
      'minus_ninja': 'Minus Ninja',
      'times_master': 'Times Master',
      'division_champ': 'Fair Share Champ',
      'boss_slayer': 'Island Conqueror',
      'space_detective': 'Space Detective',
      'quad_master': 'Grand Polymath',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String gameBadgeDescription(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'speed_counter': 'Answer 5 questions under 5 seconds each in one round.',
      'lightning_math':
          'Answer 10 correct questions in under 30 seconds total.',
      'quick_thinker': 'Solve your first problem in under 3 seconds.',
      'clean_slate':
          'Score 100% accuracy on a round with at least 10 questions.',
      'sharp_shooter': 'Score 5 correct answers in a row with zero mistakes.',
      'flawless_focus': 'Complete a 15+ question round with 90%+ accuracy.',
      'early_starter': 'Maintain a 3-day active learning streak.',
      'week_warrior': 'Maintain an unstoppable 7-day learning streak.',
      'fortnight_legend': 'Reach a legendary 14-day practice streak.',
      'half_century': 'Solve 50 math problems total across all operations.',
      'century_club': 'Solve 100 math problems total across all operations.',
      'grand_master_500': 'Reach 500 lifetime questions answered.',
      'millennium_scholar': 'Solve an astonishing 1,000 total questions!',
      'addition_superhero': 'Solve 100 addition problems with 90%+ accuracy.',
      'minus_ninja': 'Solve 100 subtraction problems with 85%+ accuracy.',
      'times_master': 'Reach Level 4 in Multiplication Mastery Track.',
      'division_champ': 'Solve 75 division challenges without remainders.',
      'boss_slayer': 'Defeat a World Boss in Adventure Island.',
      'space_detective': 'Complete Today’s Daily Mission.',
      'quad_master': 'Reach at least Level 3 across all 4 math operations.',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String adventureIslandName(String prefix, String suffix) {
    return '$prefix $suffix';
  }

  @override
  String get welcomeAppName => 'Math Quest';

  @override
  String get welcomeTagline => 'Learn, Play & Count!';

  @override
  String get profileSwitchFailed =>
      'Could not switch profiles. Please try again.';

  @override
  String get addChildProfileTitle => 'Add Child Profile';

  @override
  String get createHero => 'Create Your Hero!';

  @override
  String get createHeroDescription =>
      'Pick your avatar and tell us your name to start.';

  @override
  String get chooseAvatar => 'Choose Your Avatar';

  @override
  String get explorerNamePrompt => 'What\'s your name, explorer?';

  @override
  String get enterName => 'Enter name';

  @override
  String get selectGrade => 'Select Your Grade';

  @override
  String get creatingProfile => 'Creating Profile…';

  @override
  String get startMyAdventure => 'Start My Adventure! 🚀';

  @override
  String profileCreated(String name) {
    return '🎉 Welcome $name! Profile created and active.';
  }

  @override
  String get profileCreationFailed =>
      'Unable to create profile. Please try again.';

  @override
  String get profileSwitcherDescription =>
      'Select your profile to continue your adventure!';

  @override
  String get chargingBoosters => 'Charging math boosters...';

  @override
  String get warmingSuperpowers => 'Warming up superpowers...';

  @override
  String get readyForAdventure => 'Ready for Adventure! 🚀';

  @override
  String welcomeGreeting(String name) {
    return 'Hi $name!';
  }

  @override
  String get starMath => 'STAR MATH';

  @override
  String get onboardingWelcomeTitle => 'Welcome to MathQuest!';

  @override
  String get onboardingWelcomeDescription =>
      'Turn arithmetic into a thrilling cosmic adventure where learning feels like play.';

  @override
  String get onboardingBlocksTitle => 'Visual Counting Blocks';

  @override
  String get onboardingBlocksDescription =>
      'See numbers come to life with Base-10 blocks! Counting tens and ones makes carrying easy.';

  @override
  String get onboardingAdventureTitle => 'Defeat Bosses & Win Trophies';

  @override
  String get onboardingAdventureDescription =>
      'Climb Adventure Island, unlock new worlds, collect badges, and battle in 2-Player Duels!';

  @override
  String get getStarted => 'Get Started 🚀';

  @override
  String get next => 'Next';

  @override
  String get gradeKindergarten => 'Kindergarten';

  @override
  String gradeAgeRange(int min, int max) {
    return 'Age $min-$max';
  }

  @override
  String avatarOption(String avatar) {
    return 'Avatar $avatar';
  }

  @override
  String onboardingPage(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get switchProfileAction => 'Switch profile';

  @override
  String get allBadgesTitle => 'All Badges & Trophies';

  @override
  String get badgeUnlockedCaps => '✅ UNLOCKED';

  @override
  String get badgeLockedCaps => '🔒 LOCKED';

  @override
  String get badgeUnlocked => '✅ Unlocked';

  @override
  String get badgeLocked => '🔒 Locked';

  @override
  String get gotIt => 'Got it!';

  @override
  String get awesome => 'Awesome!';

  @override
  String viewAllCount(int count) {
    return 'View All ($count)';
  }

  @override
  String operationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Operations',
      one: '1 Operation',
    );
    return '$_temp0';
  }

  @override
  String get parentDiagnosticTitle => 'Parent Diagnostic Report';

  @override
  String get superMathematician => 'SUPER MATHEMATICIAN!';

  @override
  String get keepShining => 'Keep shining! You\'re crushing your daily goals.';

  @override
  String get totalSolvedLabel => 'TOTAL SOLVED';

  @override
  String get accuracyLabel => 'ACCURACY';

  @override
  String get unstoppable => 'Unstoppable! 🔥';

  @override
  String get trophiesLabel => 'TROPHIES';

  @override
  String badgesRemaining(int count) {
    return '$count left to unlock';
  }

  @override
  String dailyProblemGoal(int count) {
    return 'Daily Goal: $count problems';
  }

  @override
  String get weeklyGoalMet => '🎯 Goal Met!';

  @override
  String get weeklyKeepGoing => 'Keep practicing!';

  @override
  String get noWeeklyData => 'No practice yet';

  @override
  String get noCategoryBadges => 'No badges in this category yet.';

  @override
  String get noMasteryData => 'Start practicing to see your mastery progress.';

  @override
  String shortAccuracy(int percent) {
    return '$percent% Acc';
  }

  @override
  String masteryRank(String icon, String title, int level) {
    return '$icon $title (Level $level)';
  }

  @override
  String masteryProgress(int solved, int remaining, int level) {
    return '$solved solved • $remaining to Level $level';
  }

  @override
  String masteryMaxProgress(int solved) {
    return '$solved solved • Max Level! 👑';
  }

  @override
  String get curriculumBreakdown => 'Curriculum Operations Breakdown';

  @override
  String get activeStudent => 'Active Student';

  @override
  String gradeAligned(String grade) {
    return '$grade • Common Core Aligned';
  }

  @override
  String reportDate(String date) {
    return 'Report Date: $date';
  }

  @override
  String get readinessIndex => 'GRADE READINESS INDEX';

  @override
  String get noOperationData => 'No operation data yet.';

  @override
  String get stellaObservations => 'Teacher & Coach Stella Observations';

  @override
  String get identifiedStrength => 'Identified Strength:';

  @override
  String get recommendedFocus => 'Recommended Focus:';

  @override
  String get baselineGathering => 'Baseline Gathering';

  @override
  String masteryPercent(int percent) {
    return '$percent% Mastery';
  }

  @override
  String readinessStrong(String name) {
    return '$name demonstrates strong foundational number sense and is on track for advanced standards.';
  }

  @override
  String readinessStarting(String name) {
    return '$name has begun building foundational skills. Consistent daily 10-minute sessions are recommended.';
  }

  @override
  String get noRoundsCompleted => 'No rounds completed';

  @override
  String questionsAnswered(int count) {
    return '$count questions answered';
  }

  @override
  String get diagnosticPending => 'Pending Assessment';

  @override
  String get diagnosticNeedsPractice => 'Needs Practice 🎯';

  @override
  String get diagnosticOnTrack => 'On Track ⚡';

  @override
  String get diagnosticMastered => 'Mastered ✅';

  @override
  String get closeParentVerification => 'Close parent verification';

  @override
  String get adultVerificationCaps => 'ADULT VERIFICATION';

  @override
  String get adultVerification => 'Adult verification';

  @override
  String get parentControlsProtected =>
      'This check helps keep grown-up controls protected.';

  @override
  String get parentAnswerSemantics => 'Parent verification answer';

  @override
  String get answer => 'Answer';

  @override
  String get gateAnswerRequired => 'Enter an answer to continue.';

  @override
  String get gateNumbersOnly => 'Use numbers only.';

  @override
  String get gateAnswerIncorrect => 'Not quite. Please try again.';

  @override
  String parentVerificationPrompt(String first, String second) {
    return 'What is $first × $second?';
  }

  @override
  String get timeForRest => 'Time for a Rest!';

  @override
  String get restDescription =>
      'Great job on your math adventure today! Starry is taking a nap. Ask a grown-up if you want to play more.';

  @override
  String get parentUnlock => 'Parent Unlock 🛡️';

  @override
  String get gateSettingsTitle => 'Parent Settings';

  @override
  String get gateSettingsDescription =>
      'Confirm you’re a grown-up before opening protected settings.';

  @override
  String get unlockSettings => 'Unlock Settings';

  @override
  String get gateScreenLimitTitle => 'Change Screen Limit';

  @override
  String get gateScreenLimitDescription =>
      'Confirm you’re a grown-up before changing daily play time.';

  @override
  String get gateLearningTitle => 'Change Learning Goal';

  @override
  String get gateLearningDescription =>
      'Confirm you’re a grown-up before changing the target math standard.';

  @override
  String get gateResetTitle => 'Reset Adventure Progress';

  @override
  String get gateResetDescription =>
      'This is a protected action. Confirm you’re a grown-up to continue.';

  @override
  String get gateExtraTimeTitle => 'Add More Play Time';

  @override
  String get gateExtraTimeDescription =>
      'Confirm you’re a grown-up before adding 15 more minutes.';

  @override
  String get addFifteenMinutes => 'Add 15 Minutes';

  @override
  String badgeCategory(String key, String fallback) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'ALL': 'ALL',
      'SPEED': 'SPEED',
      'ACCURACY': 'ACCURACY',
      'STREAK': 'STREAK',
      'MILESTONE': 'MILESTONE',
      'MASTERY': 'MASTERY',
      'ADVENTURE': 'ADVENTURE',
      'DAILY': 'DAILY',
      'LEGENDARY': 'LEGENDARY',
      'other': '$fallback',
    });
    return '$_temp0';
  }

  @override
  String badgeTier(String key) {
    String _temp0 = intl.Intl.selectLogic(key, {
      'bronze': 'BRONZE',
      'silver': 'SILVER',
      'gold': 'GOLD',
      'diamond': 'DIAMOND',
      'other': '$key',
    });
    return '$_temp0';
  }

  @override
  String masteryTierTitle(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'l1': 'Sprout Explorer',
      'l2': 'Number Cadet',
      'l3': 'Math Adventurer',
      'l4': 'Rising Star',
      'l5': 'Number Wizard',
      'l6': 'Math Superhero',
      'l7': 'Cosmic Champion',
      'l8': 'Mastermind',
      'l9': 'Grand Titan',
      'l10': 'Supreme Math Legend!',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String gateNumberWord(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'n0': 'zero',
      'n1': 'one',
      'n2': 'two',
      'n3': 'three',
      'n4': 'four',
      'n5': 'five',
      'n6': 'six',
      'n7': 'seven',
      'n8': 'eight',
      'n9': 'nine',
      'n10': 'ten',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String weekdayShort(String day) {
    String _temp0 = intl.Intl.selectLogic(day, {
      'd0': 'Mon',
      'd1': 'Tue',
      'd2': 'Wed',
      'd3': 'Thu',
      'd4': 'Fri',
      'd5': 'Sat',
      'd6': 'Sun',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String solvedToday(int count) {
    return '+$count today';
  }

  @override
  String get practiceAccuracy => 'Across practiced operations';

  @override
  String get explorerLabel => 'Explorer';

  @override
  String get observationNeedsPractice =>
      'Complete a practice session to discover strengths.';

  @override
  String get observationBuilding =>
      'Skills are still developing. Keep practicing to build accuracy.';

  @override
  String observationStrength(String operation, int percent, int count) {
    return '$operation: $percent% accuracy across $count answered questions.';
  }

  @override
  String get observationStart =>
      'Try a short practice session to begin the assessment.';

  @override
  String get observationMaintain =>
      'Keep practicing all operations to maintain accuracy.';

  @override
  String observationTry(String operation) {
    return 'Try $operation to gather assessment data.';
  }

  @override
  String observationFocus(String operation, int percent) {
    return 'Practice $operation, currently at $percent% accuracy.';
  }

  @override
  String get appTagline => 'A little practice. A big adventure.';

  @override
  String get aboutSectionTitle => 'ABOUT';

  @override
  String get aboutAppTitle => 'About MathQuest';

  @override
  String get aboutAppSubtitle => 'A small idea, inspired by Dion';

  @override
  String get aboutAppStory =>
      'I created MathQuest to help my son Dion study math. We don’t always have a pencil and paper at hand, so I wanted a simple way to turn any spare moment into a chance to learn together.';

  @override
  String get aboutPracticeTitle => 'Practice anywhere';

  @override
  String get aboutPracticeBody =>
      'A few minutes of math, wherever the day takes you.';

  @override
  String get aboutPaceTitle => 'At their own pace';

  @override
  String get aboutPaceBody =>
      'Different grades and activities make room for every little explorer.';

  @override
  String get aboutFamilyTitle => 'Made for learning together';

  @override
  String get aboutFamilyBody =>
      'A project born at home, to make math part of everyday life.';

  @override
  String get aboutDeveloperTitle => 'About the developer';

  @override
  String get aboutDeveloperSubtitle => 'The person behind MathQuest';

  @override
  String get aboutDeveloperBio =>
      'Hi, I’m @christhoval, a full-stack engineer and Front-End Tech Lead based in Panama. I work with JavaScript and Python, and build CLI tools, npm packages, and mobile apps. I care about useful products, thoughtful UX, and privacy by design. MathQuest grew out of a simple wish: to help Dion enjoy learning math.';

  @override
  String get developerRoleTitle => 'Current role';

  @override
  String get developerRoleBody => 'Full-stack engineer & Front-End Tech Lead.';

  @override
  String get developerStackTitle => 'Main stack';

  @override
  String get developerStackBody =>
      'JavaScript, TypeScript, Python, Flutter, CLI, and npm.';

  @override
  String get developerFocusTitle => 'My focus';

  @override
  String get developerFocusBody =>
      'Product, user experience, and privacy by design.';

  @override
  String get contactSupportTitle => 'Contact / Support';

  @override
  String get contactSupportSubtitle => 'Report a bug or share an idea';

  @override
  String get supportEmailSubject => 'MathQuest — Support';

  @override
  String get supportEmailBody =>
      'Hello Christhoval,\n\nI’m contacting you about MathQuest:\n\n';

  @override
  String get supportEmailUnavailable =>
      'No email app is available. You can write to me at the address below.';

  @override
  String get copyEmail => 'Copy email address';

  @override
  String get emailCopied => 'Email address copied';
}
