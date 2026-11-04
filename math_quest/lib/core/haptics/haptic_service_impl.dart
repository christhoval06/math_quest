import 'package:flutter/services.dart';

import 'package:math_quest/core/haptics/i_haptic_service.dart';

typedef HapticAction = Future<void> Function();

class HapticServiceImpl implements IHapticService {
  final HapticAction _selectionAction;
  final HapticAction _answerSubmittedAction;
  final HapticAction _correctAnswerAction;
  final HapticAction _incorrectAnswerAction;
  bool _enabled = true;

  HapticServiceImpl({
    HapticAction? selectionAction,
    HapticAction? answerSubmittedAction,
    HapticAction? correctAnswerAction,
    HapticAction? incorrectAnswerAction,
  }) : _selectionAction = selectionAction ?? HapticFeedback.selectionClick,
       _answerSubmittedAction =
           answerSubmittedAction ?? HapticFeedback.mediumImpact,
       _correctAnswerAction = correctAnswerAction ?? HapticFeedback.lightImpact,
       _incorrectAnswerAction =
           incorrectAnswerAction ?? HapticFeedback.heavyImpact;

  @override
  Future<void> selection() => _run(_selectionAction);

  @override
  Future<void> answerSubmitted() => _run(_answerSubmittedAction);

  @override
  Future<void> correctAnswer() => _run(_correctAnswerAction);

  @override
  Future<void> incorrectAnswer() => _run(_incorrectAnswerAction);

  @override
  void setEnabled(bool enabled) => _enabled = enabled;

  Future<void> _run(HapticAction action) async {
    if (!_enabled) return;
    try {
      await action();
    } catch (_) {
      // Haptics are enhancement-only and must never interrupt gameplay.
    }
  }
}
