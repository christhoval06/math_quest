import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:math_quest/core/theme/visual_theme_model.dart';

class ThemeNotifier extends StateNotifier<VisualThemePalette> {
  final Box _box;

  ThemeNotifier(this._box)
    : super(VisualThemePalette.getPalette(_loadInitialTheme(_box)));

  static VisualThemeType _loadInitialTheme(Box box) {
    final savedName =
        box.get('selected_theme', defaultValue: 'Galaxy Quest') as String;
    return VisualThemeType.values.firstWhere(
      (t) => t.title == savedName,
      orElse: () => VisualThemeType.galaxyQuest,
    );
  }

  Future<void> setTheme(VisualThemeType type) async {
    state = VisualThemePalette.getPalette(type);
    await _box.put('selected_theme', type.title); // 💾 Saved to disk!
  }
}

final visualThemeProvider =
    StateNotifierProvider<ThemeNotifier, VisualThemePalette>((ref) {
      final box = Hive.box('app_settings_box');
      return ThemeNotifier(box);
    });
