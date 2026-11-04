import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'package:math_quest/core/audio/i_sound_service.dart';

class SoundServiceImpl implements ISoundService {
  final AudioPlayer _sfxPlayer = AudioPlayer();
  double _sfxVolume = 0.8;
  double _musicVolume = 0.6;

  SoundServiceImpl() {
    _init();
  }

  Future<void> _init() async {
    // lowLatency mode ensures instant sound on iOS & Android
    await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
    await _sfxPlayer.setVolume(_sfxVolume);
  }

  Future<void> _playSound(String assetFileName) async {
    if (_sfxVolume <= 0) return;
    try {
      // AudioPlayer automatically checks the assets folder
      await _sfxPlayer.stop(); // Stop previous SFX to avoid overlapping lag
      await _sfxPlayer.setVolume(_sfxVolume);
      await _sfxPlayer.play(AssetSource('audio/sfx/$assetFileName'));
    } catch (e) {
      // Graceful fallback: If asset isn't added to disk yet, don't crash
      debugPrint(
        '🎵 [Audio Engine Notice]: Missing or unbundled asset: audio/sfx/$assetFileName',
      );
    }
  }

  @override
  Future<void> playTap() => _playSound('tap_bubble.mp3');

  @override
  Future<void> playCorrect() => _playSound('answer_correct.mp3');

  @override
  Future<void> playWrong() => _playSound('answer_wrong.mp3');

  @override
  Future<void> playStar(int starIndex) {
    // Plays different pitches as stars pop in (1, 2, 3)
    final soundName = 'star_pop_${(starIndex + 1).clamp(1, 3)}.mp3';
    return _playSound(soundName);
  }

  @override
  Future<void> playVictory() => _playSound('quest_victory.mp3');

  @override
  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
    _sfxPlayer.setVolume(_sfxVolume);
  }

  @override
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    // Background music player hooks in here when BGM loop is active
  }
}
