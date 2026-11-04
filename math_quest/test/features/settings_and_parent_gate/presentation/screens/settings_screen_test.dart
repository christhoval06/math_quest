import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_quest/core/audio/i_sound_service.dart';
import 'package:math_quest/core/haptics/i_haptic_service.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/theme/visual_theme_model.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/domain/repositories/i_profile_repository.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/settings_preferences.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/repositories/i_settings_repository.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/controllers/settings_controller.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/settings_state.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/providers/settings_provider.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/screens/settings_screen.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_audio_card.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_language_selector.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_parent_zone.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_profiles_section.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_response_mode_selector.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_theme_selector.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp(
      'math_quest_settings_screen_',
    );
    Hive.init(hiveDirectory.path);
    await Hive.openBox<dynamic>('app_settings_box');
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  testWidgets('renders provider state and delegates unprotected actions', (
    tester,
  ) async {
    final recorder = _ControllerRecorder();
    await tester.pumpWidget(_app(recorder: recorder));
    await tester.pump();

    expect(find.text('875'), findsOneWidget);
    expect(find.text('Leo'), findsOneWidget);
    expect(find.text('45 min'), findsOneWidget);
    expect(find.text('Grade 3+'), findsWidgets);

    tester
        .widget<SettingsProfilesSection>(find.byType(SettingsProfilesSection))
        .onSwitchProfile('mia');
    final audio = tester.widget<SettingsAudioCard>(
      find.byType(SettingsAudioCard),
    );
    audio.onSfxVolumeChanged(0.2);
    audio.onMusicVolumeChanged(0.3);
    audio.onVoiceReadAloudChanged(true);
    audio.onHapticBuzzChanged(true);
    tester
        .widget<SettingsThemeSelector>(find.byType(SettingsThemeSelector))
        .onSelected(VisualThemeType.dinoMath);
    tester
        .widget<SettingsLanguageSelector>(find.byType(SettingsLanguageSelector))
        .onChanged('es');
    tester
        .widget<SettingsResponseModeSelector>(
          find.byType(SettingsResponseModeSelector),
        )
        .onChanged(ResponseMode.write);
    await tester.pumpAndSettle();

    expect(recorder.profileSwitches, ['mia']);
    expect(recorder.repository.sfxValues, [0.2]);
    expect(recorder.repository.musicValues, [0.3]);
    expect(recorder.repository.voiceValues, [true]);
    expect(recorder.repository.hapticValues, [true]);
    expect(recorder.themeChanges, [VisualThemeType.dinoMath]);
    expect(recorder.localeChanges, ['es']);
    expect(recorder.repository.responseModeValues, [ResponseMode.write]);
  });

  testWidgets('add profile navigates with the settings origin flag', (
    tester,
  ) async {
    final recorder = _ControllerRecorder();
    Object? capturedArguments;
    await tester.pumpWidget(
      _app(
        recorder: recorder,
        onRoute: (settings) {
          if (settings.name == AppRoutes.createProfile) {
            capturedArguments = settings.arguments;
          }
        },
      ),
    );
    await tester.pump();

    tester
        .widget<SettingsProfilesSection>(find.byType(SettingsProfilesSection))
        .onAddProfile();
    await tester.pumpAndSettle();

    expect(capturedArguments, isTrue);
  });

  testWidgets('profile failure leaves non-profile settings interactive', (
    tester,
  ) async {
    final recorder = _ControllerRecorder();
    await tester.pumpWidget(
      _app(
        recorder: recorder,
        state: _state(
          profilesStatus: SettingsProfilesStatus.error,
          profiles: const [],
          profilesErrorMessage: 'offline',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Profiles unavailable'), findsOneWidget);
    expect(find.byType(SettingsAudioCard), findsOneWidget);
    expect(find.byType(SettingsThemeSelector), findsOneWidget);
    expect(find.byType(SettingsLanguageSelector), findsOneWidget);
    expect(find.byType(SettingsResponseModeSelector), findsOneWidget);
    expect(find.byType(SettingsParentZone), findsOneWidget);
  });

  testWidgets('cancelled and incorrect gates perform no protected action', (
    tester,
  ) async {
    final recorder = _ControllerRecorder();
    await tester.pumpWidget(_app(recorder: recorder));
    await tester.pump();
    final zone = tester.widget<SettingsParentZone>(
      find.byType(SettingsParentZone),
    );

    zone.onScreenLimitSelected(15);
    await tester.pumpAndSettle();
    expect(find.text('Change Screen Limit'), findsOneWidget);
    await tester.ensureVisible(find.text('Cancel'));
    await tester.pump();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    zone.onTargetStandardSelected('Grade 1');
    await tester.pumpAndSettle();
    expect(find.text('Change Learning Goal'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('parent-gate-answer')), '35');
    await tester.tap(find.byKey(const Key('parent-gate-submit')));
    await tester.pump();
    expect(find.text('Not quite. Please try again.'), findsOneWidget);

    expect(recorder.repository.screenLimitValues, isEmpty);
    expect(recorder.repository.targetStandardValues, isEmpty);
    expect(recorder.resetCount, 0);
  });

  testWidgets('correct gates update settings and confirmed reset runs once', (
    tester,
  ) async {
    final recorder = _ControllerRecorder();
    await tester.pumpWidget(_app(recorder: recorder));
    await tester.pump();
    final zone = tester.widget<SettingsParentZone>(
      find.byType(SettingsParentZone),
    );

    zone.onScreenLimitSelected(15);
    await _answerGate(tester, '36');
    expect(recorder.repository.screenLimitValues, [15]);

    zone.onTargetStandardSelected('Grade 1');
    await _answerGate(tester, '36');
    expect(recorder.repository.targetStandardValues, [('leo', 'Grade 1')]);

    ScaffoldMessenger.of(tester.element(find.byType(SettingsScreen)))
        .clearSnackBars();
    await tester.pumpAndSettle();

    zone.onResetProgress();
    await _answerGate(tester, '36');
    await tester.tap(find.text('Reset Now'));
    await tester.pump();
    expect(recorder.resetCount, 1);
    expect(find.textContaining('reset to Stage 1'), findsOneWidget);
  });

  testWidgets('persistence failures show an error snackbar', (tester) async {
    final recorder = _ControllerRecorder()..repository.throwOnScreen = true;
    await tester.pumpWidget(_app(recorder: recorder));
    await tester.pump();

    tester
        .widget<SettingsParentZone>(find.byType(SettingsParentZone))
        .onScreenLimitSelected(15);
    await _answerGate(tester, '36');

    expect(
      find.text('Could not update settings. Please try again.'),
      findsOneWidget,
    );
  });

  testWidgets('back action pops the settings route', (tester) async {
    final recorder = _ControllerRecorder();
    await tester.pumpWidget(
      _app(recorder: recorder, startOnSettingsRoute: true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsNothing);
    expect(find.text('Home placeholder'), findsOneWidget);
  });

  testWidgets('renders without overflow at 390x844', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(recorder: _ControllerRecorder()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

Future<void> _answerGate(WidgetTester tester, String answer) async {
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('parent-gate-answer')), answer);
  await tester.tap(find.byKey(const Key('parent-gate-submit')));
  await tester.pumpAndSettle();
}

Widget _app({
  required _ControllerRecorder recorder,
  SettingsState? state,
  void Function(RouteSettings settings)? onRoute,
  bool startOnSettingsRoute = false,
}) {
  final profileRepository = _FakeProfileRepository();
  return ProviderScope(
    overrides: [
      settingsProvider.overrideWithValue(state ?? _state()),
      settingsControllerProvider.overrideWithValue(recorder.controller),
      profileRepositoryProvider.overrideWithValue(profileRepository),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: startOnSettingsRoute ? AppRoutes.settings : '/',
      onGenerateRoute: (settings) {
        onRoute?.call(settings);
        if (settings.name == '/') {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => startOnSettingsRoute
                ? const Scaffold(body: Text('Home placeholder'))
                : const SettingsScreen(),
          );
        }
        if (settings.name == AppRoutes.settings) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const SettingsScreen(),
          );
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const Scaffold(body: Text('Created profile')),
        );
      },
    ),
  );
}

SettingsState _state({
  SettingsProfilesStatus profilesStatus = SettingsProfilesStatus.data,
  List<SettingsProfileViewData> profiles = const [_leoView, _miaView],
  String? profilesErrorMessage,
}) {
  return SettingsState(
    preferences: SettingsPreferences(
      sfxVolume: 0.25,
      musicVolume: 0.4,
      voiceReadAloud: false,
      hapticBuzz: false,
      screenLimitMinutes: 45,
      targetMathStandards: const {'leo': 'Grade 3+'},
    ),
    profilesStatus: profilesStatus,
    profiles: profiles,
    profilesErrorMessage: profilesErrorMessage,
    activeProfileId: 'leo',
    starCoins: 875,
    selectedTheme: VisualThemeType.underwater,
    localeCode: 'pt',
    targetMathStandard: 'Grade 3+',
  );
}

class _ControllerRecorder {
  late SettingsPreferences preferences;
  final repository = _FakeSettingsRepository();
  final soundService = _FakeSoundService();
  final List<String> profileSwitches = [];
  final List<VisualThemeType> themeChanges = [];
  final List<String> localeChanges = [];
  final List<int> screenChanges = [];
  int resetCount = 0;

  _ControllerRecorder() {
    preferences = SettingsPreferences(
      sfxVolume: 0.25,
      musicVolume: 0.4,
      screenLimitMinutes: 45,
      targetMathStandards: const {'leo': 'Grade 3+'},
    );
  }

  late final SettingsController controller = SettingsController(
    readPreferences: () => preferences,
    writePreferences: (next) => preferences = next,
    readActiveProfileId: () => 'leo',
    readTheme: () => VisualThemeType.underwater,
    readLocaleCode: () => 'pt',
    repository: repository,
    soundService: soundService,
    hapticService: _FakeHapticService(),
    switchProfileAction: (id) async => profileSwitches.add(id),
    setThemeAction: (type) async => themeChanges.add(type),
    setLocaleAction: (code) async => localeChanges.add(code),
    updateScreenLimitAction: screenChanges.add,
    resetAdventureAction: () async {
      resetCount++;
    },
    parentGateGenerator: ParentGateChallengeGenerator((_) => 0),
  );
}

class _FakeSettingsRepository implements ISettingsRepository {
  final List<double> sfxValues = [];
  final List<double> musicValues = [];
  final List<bool> voiceValues = [];
  final List<bool> hapticValues = [];
  final List<int> screenLimitValues = [];
  final List<(String, String)> targetStandardValues = [];
  final List<ResponseMode> responseModeValues = [];
  bool throwOnScreen = false;

  @override
  SettingsPreferences loadPreferences() => SettingsPreferences();

  @override
  Future<void> saveSfxVolume(double value) async => sfxValues.add(value);

  @override
  Future<void> saveMusicVolume(double value) async => musicValues.add(value);

  @override
  Future<void> saveResponseMode(ResponseMode mode) async =>
      responseModeValues.add(mode);

  @override
  Future<void> saveVoiceReadAloud(bool enabled) async =>
      voiceValues.add(enabled);

  @override
  Future<void> saveHapticBuzz(bool enabled) async => hapticValues.add(enabled);

  @override
  Future<void> saveScreenLimitMinutes(int minutes) async {
    if (throwOnScreen) throw StateError('screen write failed');
    screenLimitValues.add(minutes);
  }

  @override
  Future<void> saveTargetMathStandard(String profileId, String standard) async {
    targetStandardValues.add((profileId, standard));
  }
}

class _FakeSoundService implements ISoundService {
  @override
  Future<void> playCorrect() async {}
  @override
  Future<void> playStar(int starIndex) async {}
  @override
  Future<void> playTap() async {}
  @override
  Future<void> playVictory() async {}
  @override
  Future<void> playWrong() async {}
  @override
  void setMusicVolume(double volume) {}
  @override
  void setSfxVolume(double volume) {}
}

class _FakeHapticService implements IHapticService {
  @override
  void setEnabled(bool enabled) {}

  @override
  Future<void> selection() async {}

  @override
  Future<void> answerSubmitted() async {}

  @override
  Future<void> correctAnswer() async {}

  @override
  Future<void> incorrectAnswer() async {}
}

class _FakeProfileRepository implements IProfileRepository {
  @override
  Future<UserProfile?> getActiveProfile() async => null;
  @override
  Future<List<UserProfile>> getAllProfiles() async => const [];
  @override
  Future<void> saveProfile(UserProfile profile) async {}
  @override
  Future<void> setActiveProfileId(String id) async {}
}

const _leoView = SettingsProfileViewData(
  id: 'leo',
  name: 'Leo',
  gradeLabel: 'Grade 2',
  avatar: '🚀',
  level: 7,
  starCoins: 875,
  isActive: true,
);

const _miaView = SettingsProfileViewData(
  id: 'mia',
  name: 'Mia',
  gradeLabel: 'Grade 1',
  avatar: '🦄',
  level: 3,
  starCoins: 410,
  isActive: false,
);
