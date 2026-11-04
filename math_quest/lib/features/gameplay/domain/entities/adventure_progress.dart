import 'dart:collection';

class AdventureProgress {
  final int highestWorldIndex;
  final Map<int, int> completedLevelStars;

  AdventureProgress({
    required this.highestWorldIndex,
    required Map<int, int> completedLevelStars,
  }) : completedLevelStars = UnmodifiableMapView(
         Map<int, int>.from(completedLevelStars),
       );

  AdventureProgress.empty()
    : highestWorldIndex = 1,
      completedLevelStars = UnmodifiableMapView(const <int, int>{});
}
