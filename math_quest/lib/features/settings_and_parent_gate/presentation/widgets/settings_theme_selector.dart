import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/core/theme/visual_theme_model.dart';

class SettingsThemeSelector extends StatelessWidget {
  final VisualThemeType selectedTheme;
  final VisualThemePalette activePalette;
  final ValueChanged<VisualThemeType> onSelected;

  const SettingsThemeSelector({
    super.key,
    required this.selectedTheme,
    required this.activePalette,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.gameVisualTheme,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        for (var row = 0; row < 2; row++) ...[
          Row(
            children: [
              for (var column = 0; column < 2; column++) ...[
                if (column > 0) const SizedBox(width: 10),
                Expanded(
                  child: _ThemeCard(
                    type: VisualThemeType.values[row * 2 + column],
                    isSelected:
                        selectedTheme ==
                        VisualThemeType.values[row * 2 + column],
                    activePalette: activePalette,
                    onTap: onSelected,
                  ),
                ),
              ],
            ],
          ),
          if (row == 0) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final VisualThemeType type;
  final bool isSelected;
  final VisualThemePalette activePalette;
  final ValueChanged<VisualThemeType> onTap;

  const _ThemeCard({
    required this.type,
    required this.isSelected,
    required this.activePalette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () => onTap(type),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? activePalette.background : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activePalette.primary : AppColors.borderLight,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(type.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    switch (type) {
                      VisualThemeType.galaxyQuest => l10n.themeGalaxy,
                      VisualThemeType.candyLand => l10n.themeCandy,
                      VisualThemeType.dinoMath => l10n.themeDino,
                      VisualThemeType.underwater => l10n.themeUnderwater,
                    },
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? activePalette.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    switch (type) {
                      VisualThemeType.galaxyQuest =>
                        l10n.themeGalaxyDescription,
                      VisualThemeType.candyLand => l10n.themeCandyDescription,
                      VisualThemeType.dinoMath => l10n.themeDinoDescription,
                      VisualThemeType.underwater =>
                        l10n.themeUnderwaterDescription,
                    },
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
