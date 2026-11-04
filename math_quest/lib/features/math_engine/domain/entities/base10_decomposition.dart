class Base10Decomposition {
  final int value;
  final int hundreds;
  final int tens;
  final int ones;

  const Base10Decomposition({
    required this.value,
    required this.hundreds,
    required this.tens,
    required this.ones,
  });

  factory Base10Decomposition.fromNumber(int number) {
    if (number < 0) {
      return const Base10Decomposition(value: 0, hundreds: 0, tens: 0, ones: 0);
    }
    final hundreds = (number ~/ 100);
    final tens = (number % 100) ~/ 10;
    final ones = number % 10;

    return Base10Decomposition(
      value: number,
      hundreds: hundreds,
      tens: tens,
      ones: ones,
    );
  }
}
