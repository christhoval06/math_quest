import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/controllers/parent_gate_controller.dart';

void main() {
  const challenge = ParentGateChallenge(firstFactor: 7, secondFactor: 8);

  test('starts ready for an answer', () {
    final controller = ParentGateController(challenge);

    expect(controller.state.answer, isEmpty);
    expect(controller.state.errorMessage, isNull);
    expect(controller.state.isVerified, isFalse);
  });

  test('empty answer does not verify', () {
    final controller = ParentGateController(challenge);

    expect(controller.verify(), isFalse);
    expect(controller.state.errorMessage, 'Enter an answer to continue.');
    expect(controller.state.isVerified, isFalse);
  });

  test('non-numeric and incorrect answers stay locked', () {
    final controller = ParentGateController(challenge);

    controller.setAnswer('hello');
    expect(controller.verify(), isFalse);
    expect(controller.state.errorMessage, 'Use numbers only.');

    controller.setAnswer('55');
    expect(controller.verify(), isFalse);
    expect(controller.state.errorMessage, 'Not quite. Please try again.');
    expect(controller.state.isVerified, isFalse);
  });

  test('editing the answer clears old feedback', () {
    final controller = ParentGateController(challenge);
    controller.setAnswer('55');
    controller.verify();

    controller.setAnswer('56');

    expect(controller.state.answer, '56');
    expect(controller.state.errorMessage, isNull);
  });

  test('correct answer verifies only once', () {
    final controller = ParentGateController(challenge);
    controller.setAnswer(' 56 ');

    expect(controller.verify(), isTrue);
    expect(controller.state.isVerified, isTrue);
    expect(controller.verify(), isFalse);
  });
}
