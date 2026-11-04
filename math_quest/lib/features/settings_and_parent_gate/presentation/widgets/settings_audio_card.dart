import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class SettingsAudioCard extends StatelessWidget {
  final double sfxVolume;
  final double musicVolume;
  final bool voiceReadAloud;
  final bool hapticBuzz;
  final ValueChanged<double> onSfxVolumeChanged;
  final ValueChanged<double> onMusicVolumeChanged;
  final ValueChanged<bool> onVoiceReadAloudChanged;
  final ValueChanged<bool> onHapticBuzzChanged;

  const SettingsAudioCard({
    super.key,
    required this.sfxVolume,
    required this.musicVolume,
    required this.voiceReadAloud,
    required this.hapticBuzz,
    required this.onSfxVolumeChanged,
    required this.onMusicVolumeChanged,
    required this.onVoiceReadAloudChanged,
    required this.onHapticBuzzChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.soundsAndWorld,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Material(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.borderLight),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _VolumeSlider(
                  label: AppLocalizations.of(context)!.soundEffects,
                  icon: '🔔',
                  value: sfxVolume,
                  onChanged: onSfxVolumeChanged,
                ),
                const Divider(height: 20),
                _VolumeSlider(
                  label: AppLocalizations.of(context)!.gameMelodies,
                  icon: '🎵',
                  value: musicVolume,
                  onChanged: onMusicVolumeChanged,
                ),
                const Divider(height: 20),
                SwitchListTile(
                  value: voiceReadAloud,
                  onChanged: onVoiceReadAloudChanged,
                  title: Text(
                    AppLocalizations.of(context)!.voiceReadAloud,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!.voiceReadAloudDescription,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  activeThumbColor: AppColors.successGreen,
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(height: 10),
                SwitchListTile(
                  value: hapticBuzz,
                  onChanged: onHapticBuzzChanged,
                  title: Text(
                    AppLocalizations.of(context)!.hapticTouch,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!.hapticTouchDescription,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  activeThumbColor: AppColors.successGreen,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _VolumeSlider extends StatelessWidget {
  final String label;
  final String icon;
  final double value;
  final ValueChanged<double> onChanged;

  const _VolumeSlider({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryBlue,
          inactiveColor: const Color(0xFFE2E8F0),
        ),
      ],
    );
  }
}
