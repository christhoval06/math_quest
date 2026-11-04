import 'package:flutter/material.dart';
import 'package:math_quest/features/gameplay/domain/entities/adventure_level.dart';
import 'package:math_quest/features/gameplay/presentation/models/adventure_island_state.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/adventure_path_connector.dart';
import 'package:math_quest/features/gameplay/presentation/widgets/level_node_widget.dart';

class AdventureLevelMap extends StatelessWidget {
  final List<AdventureLevelViewData> levels;
  final ValueChanged<AdventureLevelViewData> onLevelSelected;

  const AdventureLevelMap({
    super.key,
    required this.levels,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < levels.length; index++) ...[
          Align(
            alignment: _alignment(levels[index].pathPosition),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LevelNodeWidget(
                level: _toDomainLevel(levels[index]),
                onTap: () => onLevelSelected(levels[index]),
              ),
            ),
          ),
          if (index < levels.length - 1) const AdventurePathConnector(),
        ],
      ],
    );
  }

  Alignment _alignment(AdventurePathPosition position) {
    return switch (position) {
      AdventurePathPosition.center => Alignment.center,
      AdventurePathPosition.right => Alignment.centerRight,
      AdventurePathPosition.left => Alignment.centerLeft,
    };
  }

  AdventureLevel _toDomainLevel(AdventureLevelViewData level) {
    return AdventureLevel(
      levelNumber: level.levelNumber,
      title: level.title,
      worldName: '',
      status: level.status,
      stars: level.stars,
      operation: level.operation,
      difficulty: level.difficulty,
      isBoss: level.isBoss,
    );
  }
}
