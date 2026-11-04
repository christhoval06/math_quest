abstract class IHapticService {
  Future<void> selection();

  Future<void> answerSubmitted();

  Future<void> correctAnswer();

  Future<void> incorrectAnswer();

  void setEnabled(bool enabled);
}
