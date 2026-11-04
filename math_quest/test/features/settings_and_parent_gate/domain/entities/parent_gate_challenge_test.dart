import 'package:flutter_test/flutter_test.dart';

import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';

void main() {
  test('generator maps injected values to factors from 6 through 10', () {
    final values = [0, 4];
    var index = 0;
    final generator = ParentGateChallengeGenerator((max) {
      expect(max, 5);
      return values[index++];
    });

    final challenge = generator.generate();

    expect(challenge.firstFactor, 6);
    expect(challenge.secondFactor, 10);
  });

  test('prompt uses number words and a multiplication sign', () {
    const challenge = ParentGateChallenge(firstFactor: 6, secondFactor: 10);

    expect(challenge.prompt, 'What is six × ten?');
  });

  test('trimmed numeric input validates the product', () {
    const challenge = ParentGateChallenge(firstFactor: 7, secondFactor: 8);

    expect(challenge.accepts(' 56 '), isTrue);
  });

  test('empty non-numeric and incorrect input fail validation', () {
    const challenge = ParentGateChallenge(firstFactor: 9, secondFactor: 9);

    expect(challenge.accepts(''), isFalse);
    expect(challenge.accepts('eighty-one'), isFalse);
    expect(challenge.accepts('80'), isFalse);
  });
}
