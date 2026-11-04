enum MathOperationType { addition, subtraction, multiplication, division }

class MasteryTrack {
  final MathOperationType operation;
  final int level; // e.g., Level 5 "Master!"
  final String title; // e.g., "Master!", "Superhero"
  final int totalSolved; // e.g., 520
  final double accuracy; // e.g., 0.98 (98%)

  const MasteryTrack({
    required this.operation,
    required this.level,
    required this.title,
    required this.totalSolved,
    required this.accuracy,
  });

  MasteryTrack copyWith({
    int? level,
    String? title,
    int? totalSolved,
    double? accuracy,
  }) {
    return MasteryTrack(
      operation: operation,
      level: level ?? this.level,
      title: title ?? this.title,
      totalSolved: totalSolved ?? this.totalSolved,
      accuracy: accuracy ?? this.accuracy,
    );
  }
}
