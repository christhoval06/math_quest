import 'package:flutter/material.dart';

abstract final class LandingTheme {
  static const canvas = Color(0xFFFAF8FF);
  static const ink = Color(0xFF131B2E);
  static const muted = Color(0xFF536078);
  static const orange = Color(0xFFFF9F1C);
  static const blue = Color(0xFF006399);
  static const mint = Color(0xFF006C49);
  static const lavender = Color(0xFFF2F3FF);
  static const border = Color(0xFFE6E8F2);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Plus Jakarta Sans',
    scaffoldBackgroundColor: canvas,
    colorScheme: ColorScheme.fromSeed(
      seedColor: orange,
      surface: canvas,
      onSurface: ink,
      primary: const Color(0xFF895100),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 52,
        height: 1.12,
        fontWeight: FontWeight.w800,
        letterSpacing: -2.2,
        color: ink,
      ),
      headlineLarge: TextStyle(
        fontSize: 34,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.1,
        color: ink,
      ),
      headlineMedium: TextStyle(
        fontSize: 25,
        height: 1.25,
        fontWeight: FontWeight.w800,
        letterSpacing: -.6,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        height: 1.3,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.7,
        fontWeight: FontWeight.w500,
        color: muted,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.6,
        fontWeight: FontWeight.w500,
        color: muted,
      ),
      labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: ink,
      ),
    ),
    dividerTheme: const DividerThemeData(color: border, space: 1),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    tooltipTheme: const TooltipThemeData(
      waitDuration: Duration(milliseconds: 400),
    ),
  );
}
