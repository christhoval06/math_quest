import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_quest/core/theme/app_theme.dart';

enum VisualThemeType {
  galaxyQuest('Galaxy Quest', 'Deep space', '🌌'),
  candyLand('Candy Land', 'Sweet hills', '🍭'),
  dinoMath('Dino Math', 'Prehistoric', '🦖'),
  underwater('Underwater', 'Coral reef', '🐠');

  final String title;
  final String subtitle;
  final String emoji;
  const VisualThemeType(this.title, this.subtitle, this.emoji);
}

class VisualThemePalette {
  final VisualThemeType type;
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  const VisualThemePalette({
    required this.type,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      // All theme headers are pale, including transparent app bars.
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: border, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // Preset Palettes for the 4 Themes
  static VisualThemePalette getPalette(VisualThemeType type) {
    switch (type) {
      case VisualThemeType.galaxyQuest:
        return const VisualThemePalette(
          type: VisualThemeType.galaxyQuest,
          primary: Color(0xFF1CB0F6), // Cosmic Sky Blue
          secondary: Color(0xFFFF9600), // Star Gold
          background: Color(0xFFF7F9FC), // Soft Off-White
          surface: Colors.white,
          border: Color(0xFFE2E8F0),
          textPrimary: Color(0xFF1E293B),
          textSecondary: Color(0xFF64748B),
        );

      case VisualThemeType.candyLand:
        return const VisualThemePalette(
          type: VisualThemeType.candyLand,
          primary: Color(0xFFEC4899), // Bubblegum Pink
          secondary: Color(0xFFF59E0B), // Honey Caramel
          background: Color(0xFFFFF1F2), // Cotton Candy Tint
          surface: Colors.white,
          border: Color(0xFFFECDD3),
          textPrimary: Color(0xFF881337),
          textSecondary: Color(0xFF9F1239),
        );

      case VisualThemeType.dinoMath:
        return const VisualThemePalette(
          type: VisualThemeType.dinoMath,
          primary: Color(0xFF10B981), // Jungle Emerald
          secondary: Color(0xFFD97706), // Prehistoric Amber
          background: Color(0xFFF0FDF4), // Fresh Fern Tint
          surface: Colors.white,
          border: Color(0xFFBBF7D0),
          textPrimary: Color(0xFF064E3B),
          textSecondary: Color(0xFF047857),
        );

      case VisualThemeType.underwater:
        return const VisualThemePalette(
          type: VisualThemeType.underwater,
          primary: Color(0xFF06B6D4), // Deep Cyan Reef
          secondary: Color(0xFFF97316), // Clownfish Coral
          background: Color(0xFFF0FDFA), // Clear Lagoon Tint
          surface: Colors.white,
          border: Color(0xFF99F6E4),
          textPrimary: Color(0xFF164E63),
          textSecondary: Color(0xFF0E7490),
        );
    }
  }
}
