import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/core/theme/theme_provider.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/controllers/settings_controller.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_config.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/navigation/parent_gate_launcher.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/providers/settings_provider.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/reset_progress_dialog.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_app_bar.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_app_header.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_about_section.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_audio_card.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_banner.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_footer.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_language_selector.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_parent_zone.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_profiles_section.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_response_mode_selector.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_theme_selector.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(visualThemeProvider);
    final state = ref.watch(settingsProvider);
    final controller = ref.read(settingsControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: SettingsAppBar(
        starCoins: state.starCoins,
        onBack: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const SettingsAppHeader(),
                const SizedBox(height: 8),
                const SettingsBanner(),
                const SizedBox(height: 20),
                SettingsProfilesSection(
                  status: state.profilesStatus,
                  profiles: state.profiles,
                  errorMessage: state.profilesErrorMessage,
                  onSwitchProfile: (profileId) {
                    final profileName = state.profiles
                        .where((profile) => profile.id == profileId)
                        .map((profile) => profile.name)
                        .firstOrNull;
                    unawaited(
                      _runAction(
                        context,
                        () => controller.switchProfile(profileId),
                        successMessage: profileName == null
                            ? AppLocalizations.of(context)!.profileSwitched
                            : AppLocalizations.of(context)!
                                  .switchedToProfile(profileName),
                      ),
                    );
                  },
                  onAddProfile: () => Navigator.pushNamed(
                    context,
                    AppRoutes.createProfile,
                    arguments: true,
                  ),
                ),
                const SizedBox(height: 24),
                SettingsAudioCard(
                  sfxVolume: state.sfxVolume,
                  musicVolume: state.musicVolume,
                  voiceReadAloud: state.voiceReadAloud,
                  hapticBuzz: state.hapticBuzz,
                  onSfxVolumeChanged: (value) => unawaited(
                    _runAction(context, () => controller.setSfxVolume(value)),
                  ),
                  onMusicVolumeChanged: (value) => unawaited(
                    _runAction(context, () => controller.setMusicVolume(value)),
                  ),
                  onVoiceReadAloudChanged: (enabled) => unawaited(
                    _runAction(
                      context,
                      () => controller.setVoiceReadAloud(enabled),
                    ),
                  ),
                  onHapticBuzzChanged: (enabled) => unawaited(
                    _runAction(
                      context,
                      () => controller.setHapticBuzz(enabled),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SettingsThemeSelector(
                  selectedTheme: state.selectedTheme,
                  activePalette: theme,
                  onSelected: (type) => unawaited(
                    _runAction(context, () => controller.setTheme(type)),
                  ),
                ),
                const SizedBox(height: 28),
                SettingsLanguageSelector(
                  localeCode: state.localeCode,
                  onChanged: (code) => unawaited(
                    _runAction(context, () => controller.setLocale(code)),
                  ),
                ),
                const SizedBox(height: 24),
                SettingsResponseModeSelector(
                  selectedMode: state.responseMode,
                  onChanged: (mode) => unawaited(
                    _runAction(context, () => controller.setResponseMode(mode)),
                  ),
                ),
                const SizedBox(height: 24),
                SettingsParentZone(
                  activeProfileName:
                      state.activeProfile?.name ??
                      AppLocalizations.of(context)!.hero,
                  screenLimitMinutes: state.screenLimitMinutes,
                  targetMathStandard: state.targetMathStandard,
                  primaryColor: theme.primary,
                  onScreenLimitSelected: (minutes) => unawaited(
                    _updateScreenLimit(context, controller, minutes),
                  ),
                  onTargetStandardSelected: (standard) => unawaited(
                    _updateTargetStandard(context, controller, standard),
                  ),
                  onResetProgress: () =>
                      unawaited(_resetProgress(context, controller)),
                ),
                const SizedBox(height: 20),
                const SettingsAboutSection(),
                const SizedBox(height: 24),
                const SettingsFooter(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateScreenLimit(
    BuildContext context,
    SettingsController controller,
    int minutes,
  ) async {
    if (!await _passesParentGate(
      context,
      controller,
      ParentGateConfig.screenLimit,
    )) {
      return;
    }
    if (!context.mounted) return;
    await _runAction(
      context,
      () => controller.setScreenLimitMinutes(minutes),
      successMessage: AppLocalizations.of(context)!.screenLimitUpdated(
        minutes == 0
            ? AppLocalizations.of(context)!.unlimited
            : AppLocalizations.of(context)!.minutesLong(minutes),
      ),
    );
  }

  Future<void> _updateTargetStandard(
    BuildContext context,
    SettingsController controller,
    String standard,
  ) async {
    if (!await _passesParentGate(
      context,
      controller,
      ParentGateConfig.learningGoal,
    )) {
      return;
    }
    if (!context.mounted) return;
    await _runAction(
      context,
      () => controller.setTargetMathStandard(standard),
      successMessage: AppLocalizations.of(context)!
          .targetStandardUpdated(_localizedStandard(context, standard)),
    );
  }

  Future<void> _resetProgress(
    BuildContext context,
    SettingsController controller,
  ) async {
    if (!await _passesParentGate(
      context,
      controller,
      ParentGateConfig.resetProgress,
    )) {
      return;
    }
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ResetProgressDialog(),
    );
    if (confirmed != true || !context.mounted) return;
    await _runAction(
      context,
      controller.resetAdventureProgress,
      successMessage: AppLocalizations.of(context)!.adventureProgressReset,
    );
  }

  Future<bool> _passesParentGate(
    BuildContext context,
    SettingsController controller,
    ParentGateConfig config,
  ) async {
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
    final challenge = controller.createParentGateChallenge();
    return ParentGateLauncher.requestAccess(
      context,
      challenge: challenge,
      config: config,
    );
  }

  String _localizedStandard(BuildContext context, String standard) {
    final l10n = AppLocalizations.of(context)!;
    return switch (standard) {
      'Pre-K' => l10n.gradePreK,
      'Grade 1' => l10n.gradeOne,
      'Grade 2' => l10n.gradeTwo,
      'Grade 3+' => l10n.gradeThreePlus,
      _ => standard,
    };
  }

  Future<void> _runAction(
    BuildContext context,
    Future<void> Function() action, {
    String? successMessage,
  }) async {
    try {
      await action();
      if (!context.mounted || successMessage == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.settingsUpdateFailed),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }
}
