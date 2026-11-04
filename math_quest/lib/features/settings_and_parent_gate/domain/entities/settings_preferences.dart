import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';

class SettingsPreferences {
  static const supportedScreenLimits = {0, 15, 30, 45};
  static const supportedTargetMathStandards = {
    'Pre-K',
    'Grade 1',
    'Grade 2',
    'Grade 3+',
  };

  final double sfxVolume;
  final double musicVolume;
  final bool voiceReadAloud;
  final bool hapticBuzz;
  final int screenLimitMinutes;
  final ResponseMode responseMode;
  final Map<String, String> targetMathStandards;

  SettingsPreferences({
    this.sfxVolume = 0.8,
    this.musicVolume = 0.6,
    this.voiceReadAloud = true,
    this.hapticBuzz = true,
    this.screenLimitMinutes = 30,
    this.responseMode = ResponseMode.choice,
    Map<String, String> targetMathStandards = const {},
  }) : targetMathStandards = Map.unmodifiable(
         Map<String, String>.from(targetMathStandards),
       );

  SettingsPreferences copyWith({
    double? sfxVolume,
    double? musicVolume,
    bool? voiceReadAloud,
    bool? hapticBuzz,
    int? screenLimitMinutes,
    ResponseMode? responseMode,
    Map<String, String>? targetMathStandards,
  }) {
    return SettingsPreferences(
      sfxVolume: sfxVolume ?? this.sfxVolume,
      musicVolume: musicVolume ?? this.musicVolume,
      voiceReadAloud: voiceReadAloud ?? this.voiceReadAloud,
      hapticBuzz: hapticBuzz ?? this.hapticBuzz,
      screenLimitMinutes: screenLimitMinutes ?? this.screenLimitMinutes,
      responseMode: responseMode ?? this.responseMode,
      targetMathStandards: targetMathStandards ?? this.targetMathStandards,
    );
  }

  String targetMathStandardFor(String profileId, String gradeFallback) {
    final stored = targetMathStandards[profileId];
    if (stored != null && supportedTargetMathStandards.contains(stored)) {
      return stored;
    }
    return gradeFallback == 'Kindergarten' ? 'Pre-K' : gradeFallback;
  }
}
