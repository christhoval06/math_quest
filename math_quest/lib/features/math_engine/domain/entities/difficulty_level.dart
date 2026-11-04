enum DifficultyLevel {
  easy('Easy', 'Ages 4-6'),
  medium('Medium', 'Ages 7-8'),
  hard('Hard', 'Ages 9-10');

  final String label;
  final String targetAge;
  const DifficultyLevel(this.label, this.targetAge);
}
