abstract class ISoundService {
  Future<void> playTap();
  Future<void> playCorrect();
  Future<void> playWrong();
  Future<void> playStar(int starIndex);
  Future<void> playVictory();

  void setSfxVolume(double volume);
  void setMusicVolume(double volume);
}
