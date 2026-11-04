class ParentGateChallenge {
  static const _numberWords = [
    'zero',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
  ];

  final int firstFactor;
  final int secondFactor;

  const ParentGateChallenge({
    required this.firstFactor,
    required this.secondFactor,
  }) : assert(firstFactor >= 0 && firstFactor <= 10),
       assert(secondFactor >= 0 && secondFactor <= 10);

  String get prompt =>
      'What is ${_numberWords[firstFactor]} × ${_numberWords[secondFactor]}?';

  bool accepts(String input) {
    return int.tryParse(input.trim()) == firstFactor * secondFactor;
  }
}

class ParentGateChallengeGenerator {
  final int Function(int max) _nextInt;

  const ParentGateChallengeGenerator(this._nextInt);

  ParentGateChallenge generate() {
    return ParentGateChallenge(
      firstFactor: _nextInt(5) + 6,
      secondFactor: _nextInt(5) + 6,
    );
  }
}
