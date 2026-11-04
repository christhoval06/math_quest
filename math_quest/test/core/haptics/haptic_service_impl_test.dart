import 'package:flutter_test/flutter_test.dart';

import 'package:math_quest/core/haptics/haptic_service_impl.dart';

void main() {
  test('semantic methods invoke only their matching platform action', () async {
    final events = <String>[];
    final service = HapticServiceImpl(
      selectionAction: () async => events.add('selection'),
      answerSubmittedAction: () async => events.add('submitted'),
      correctAnswerAction: () async => events.add('correct'),
      incorrectAnswerAction: () async => events.add('incorrect'),
    );

    await service.selection();
    await service.answerSubmitted();
    await service.correctAnswer();
    await service.incorrectAnswer();

    expect(events, ['selection', 'submitted', 'correct', 'incorrect']);
  });

  test(
    'disabled service suppresses every event and can be re-enabled',
    () async {
      var calls = 0;
      Future<void> count() async => calls++;
      final service = HapticServiceImpl(
        selectionAction: count,
        answerSubmittedAction: count,
        correctAnswerAction: count,
        incorrectAnswerAction: count,
      );

      service.setEnabled(false);
      await service.selection();
      await service.answerSubmitted();
      await service.correctAnswer();
      await service.incorrectAnswer();
      expect(calls, 0);

      service.setEnabled(true);
      await service.selection();
      expect(calls, 1);
    },
  );

  test('platform failures never escape the service boundary', () async {
    final service = HapticServiceImpl(
      selectionAction: () async => throw StateError('platform unavailable'),
    );

    await expectLater(service.selection(), completes);
  });
}
