import 'package:math_quest/features/settings_and_parent_gate/domain/entities/response_mode.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/settings_preferences.dart';

abstract class ISettingsRepository {
  SettingsPreferences loadPreferences();

  Future<void> saveSfxVolume(double value);

  Future<void> saveMusicVolume(double value);

  Future<void> saveVoiceReadAloud(bool enabled);

  Future<void> saveHapticBuzz(bool enabled);

  Future<void> saveScreenLimitMinutes(int minutes);

  Future<void> saveResponseMode(ResponseMode mode);

  Future<void> saveTargetMathStandard(String profileId, String standard);
}
