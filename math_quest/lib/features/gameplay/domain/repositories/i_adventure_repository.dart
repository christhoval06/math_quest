import 'package:math_quest/features/gameplay/domain/entities/adventure_progress.dart';

abstract interface class IAdventureRepository {
  AdventureProgress loadProgress();

  Future<void> saveProgress(AdventureProgress progress);

  Future<void> resetProgress();
}
