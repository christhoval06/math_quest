import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/gameplay/presentation/models/adventure_island_state.dart';
import 'package:math_quest/features/gameplay/presentation/models/gameplay_localizations.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class AdventureIslandAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int activeWorldIndex;
  final String currentWorldTitle;
  final String currentWorldEmoji;
  final List<AdventureWorldOptionViewData> worlds;
  final ValueChanged<int> onWorldSelected;

  const AdventureIslandAppBar({
    super.key,
    required this.activeWorldIndex,
    required this.currentWorldTitle,
    required this.currentWorldEmoji,
    required this.worlds,
    required this.onWorldSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Text(currentWorldEmoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              AppLocalizations.of(context)!.worldTitle(
                activeWorldIndex,
                localizedAdventureWorld(
                  AppLocalizations.of(context)!,
                  currentWorldTitle,
                ),
              ),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 17,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (worlds.length > 1)
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.map_rounded,
              color: AppColors.primaryDarkBlue,
            ),
            tooltip: AppLocalizations.of(context)!.switchIsland,
            onSelected: onWorldSelected,
            itemBuilder: (context) => worlds
                .map(
                  (world) => PopupMenuItem<int>(
                    value: world.worldIndex,
                    child: Row(
                      children: [
                        Text(world.emoji),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.worldTitle(
                              world.worldIndex,
                              localizedAdventureWorld(
                                AppLocalizations.of(context)!,
                                world.title,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: world.isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
