enum MathOperation {
  addition('+', 'Addition'),
  subtraction('-', 'Subtraction'),
  multiplication('×', 'Multiplication'),
  division('÷', 'Division');

  final String symbol;
  final String label;
  const MathOperation(this.symbol, this.label);
}
