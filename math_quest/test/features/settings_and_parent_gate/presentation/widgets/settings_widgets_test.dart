import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/core/theme/visual_theme_model.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/settings_state.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/reset_progress_dialog.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_app_bar.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_audio_card.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_banner.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_footer.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_language_selector.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_parent_zone.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_profiles_section.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_response_mode_selector.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_theme_selector.dart';
import 'package:math_quest/l10n/app_localizations.dart';

void main() {
  testWidgets('app bar renders active coins and invokes back', (tester) async {
    var backCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: SettingsAppBar(starCoins: 875, onBack: () => backCount++),
        ),
      ),
    );

    expect(find.text('875'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    expect(backCount, 1);
  });

  testWidgets('banner and footer preserve current copy', (tester) async {
    await tester.pumpWidget(
      _app(const Column(children: [SettingsBanner(), SettingsFooter()])),
    );

    expect(find.text('Personalize Quest!'), findsOneWidget);
    expect(find.textContaining('Adjust sounds'), findsOneWidget);
    expect(find.text('MathQuest v1.0.0 (Safe Kids Edition)'), findsOneWidget);
    expect(find.textContaining('backed up safely'), findsOneWidget);
  });

  testWidgets('profiles section renders states and delivers callbacks', (
    tester,
  ) async {
    String? switchedId;
    var addCount = 0;

    await tester.pumpWidget(
      _app(
        SettingsProfilesSection(
          status: SettingsProfilesStatus.loading,
          profiles: const [],
          onSwitchProfile: (id) => switchedId = id,
          onAddProfile: () => addCount++,
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpWidget(
      _app(
        SettingsProfilesSection(
          status: SettingsProfilesStatus.error,
          profiles: const [],
          errorMessage: 'offline',
          onSwitchProfile: (id) => switchedId = id,
          onAddProfile: () => addCount++,
        ),
      ),
    );
    expect(find.text('Profiles unavailable'), findsOneWidget);

    await tester.pumpWidget(
      _app(
        SettingsProfilesSection(
          status: SettingsProfilesStatus.data,
          profiles: const [_leo, _mia],
          onSwitchProfile: (id) => switchedId = id,
          onAddProfile: () => addCount++,
        ),
      ),
    );
    expect(find.text('Leo'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    await tester.tap(find.text('Switch'));
    await tester.tap(find.text('Add New Child Profile'));
    expect(switchedId, 'mia');
    expect(addCount, 1);

    await tester.pumpWidget(
      _app(
        SettingsProfilesSection(
          status: SettingsProfilesStatus.data,
          profiles: const [_leo, _mia, _max],
          onSwitchProfile: (id) => switchedId = id,
          onAddProfile: () => addCount++,
        ),
      ),
    );
    expect(find.text('All 3 profile slots in use'), findsOneWidget);
  });

  testWidgets('audio card reports both volumes and switches', (tester) async {
    double? sfx;
    double? music;
    bool? voice;
    bool? haptic;
    await tester.pumpWidget(
      _app(
        SettingsAudioCard(
          sfxVolume: 0.8,
          musicVolume: 0.6,
          voiceReadAloud: true,
          hapticBuzz: true,
          onSfxVolumeChanged: (value) => sfx = value,
          onMusicVolumeChanged: (value) => music = value,
          onVoiceReadAloudChanged: (value) => voice = value,
          onHapticBuzzChanged: (value) => haptic = value,
        ),
      ),
    );

    final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
    sliders[0].onChanged!(0.2);
    sliders[1].onChanged!(0.3);
    final switches = tester
        .widgetList<SwitchListTile>(find.byType(SwitchListTile))
        .toList();
    switches[0].onChanged!(false);
    switches[1].onChanged!(false);

    expect(sfx, 0.2);
    expect(music, 0.3);
    expect(voice, isFalse);
    expect(haptic, isFalse);
    expect(find.text('80%'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
  });

  testWidgets('theme selector renders four themes and reports selection', (
    tester,
  ) async {
    VisualThemeType? selected;
    await tester.pumpWidget(
      _app(
        SettingsThemeSelector(
          selectedTheme: VisualThemeType.galaxyQuest,
          activePalette: VisualThemePalette.getPalette(
            VisualThemeType.galaxyQuest,
          ),
          onSelected: (value) => selected = value,
        ),
      ),
    );

    expect(find.text('Galaxy Quest'), findsOneWidget);
    expect(find.text('Candy Land'), findsOneWidget);
    expect(find.text('Dino Math'), findsOneWidget);
    expect(find.text('Underwater'), findsOneWidget);
    await tester.tap(find.text('Underwater'));
    expect(selected, VisualThemeType.underwater);
  });

  testWidgets(
    'language selector renders three languages and reports selection',
    (tester) async {
      String? selected;
      await tester.pumpWidget(
        _app(
          SettingsLanguageSelector(
            localeCode: 'en',
            onChanged: (value) => selected = value,
          ),
        ),
      );

      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      expect(dropdown.items, hasLength(3));
      dropdown.onChanged!('pt');
      expect(selected, 'pt');
    },
  );

  testWidgets('response mode selector renders and reports selection', (
    tester,
  ) async {
    ResponseMode? selected;
    await tester.pumpWidget(
      _app(
        SettingsResponseModeSelector(
          selectedMode: ResponseMode.choice,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    expect(find.text('Response Mode'), findsOneWidget);
    expect(find.text('Choice'), findsOneWidget);
    expect(find.text('Write'), findsOneWidget);
    expect(find.text('Pick from four answers'), findsOneWidget);
    expect(find.text('Type the answer'), findsOneWidget);

    await tester.tap(find.text('Write'));

    expect(selected, ResponseMode.write);
  });

  testWidgets('parent zone reports protected action taps', (tester) async {
    int? minutes;
    String? standard;
    var resetCount = 0;
    await tester.pumpWidget(
      _app(
        SettingsParentZone(
          activeProfileName: 'Leo',
          screenLimitMinutes: 30,
          targetMathStandard: 'Grade 2',
          primaryColor: Colors.indigo,
          onScreenLimitSelected: (value) => minutes = value,
          onTargetStandardSelected: (value) => standard = value,
          onResetProgress: () => resetCount++,
        ),
      ),
    );

    await tester.tap(find.text('45 min'));
    await tester.tap(find.text('Grade 3+'));
    await tester.tap(find.text('Reset Adventure Progress for Current Hero'));

    expect(minutes, 45);
    expect(standard, 'Grade 3+');
    expect(resetCount, 1);
  });

  testWidgets('reset dialog returns confirmation or cancellation', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      _dialogApp(
        onOpen: (context) async {
          result = await showDialog<bool>(
            context: context,
            builder: (_) => const ResetProgressDialog(),
          );
        },
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset Now'));
    await tester.pumpAndSettle();
    expect(result, isTrue);

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });
}

Widget _app(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}

Widget _dialogApp({
  required Future<void> Function(BuildContext context) onOpen,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () => onOpen(context),
          child: const Text('Open'),
        ),
      ),
    ),
  );
}

const _leo = SettingsProfileViewData(
  id: 'leo',
  name: 'Leo',
  gradeLabel: 'Grade 2',
  avatar: '🚀',
  level: 7,
  starCoins: 875,
  isActive: true,
);

const _mia = SettingsProfileViewData(
  id: 'mia',
  name: 'Mia',
  gradeLabel: 'Grade 1',
  avatar: '🦄',
  level: 3,
  starCoins: 410,
  isActive: false,
);

const _max = SettingsProfileViewData(
  id: 'max',
  name: 'Max',
  gradeLabel: 'Pre-K',
  avatar: '🦖',
  level: 2,
  starCoins: 200,
  isActive: false,
);
