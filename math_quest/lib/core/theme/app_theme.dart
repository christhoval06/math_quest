import 'package:flutter/material.dart';

class AppColors {
  // Brand & Mascots
  static const Color primaryBlue = Color(0xFF1CB0F6);
  static const Color primaryDarkBlue = Color(0xFF0288D1);
  static const Color secondaryOrange = Color(0xFFFF9600);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Operations
  static const Color opAddition = Color(0xFF0EA5E9);
  static const Color opSubtraction = Color(0xFFF43F5E);
  static const Color opMultiplication = Color(0xFF8B5CF6);
  static const Color opDivision = Color(0xFFF59E0B);

  // Feedback & States
  static const Color successGreen = Color(0xFF00C853);
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color errorRed = Color(0xFFFF4B4B);
  static const Color errorBg = Color(0xFFFFEBEE);

  // Neutrals & Typography
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
}

class AppTypography {
  static const fontFamily = 'Nunito';
  static const TextStyle displayProblem = TextStyle(
    fontFamily: fontFamily,
    fontSize: 44,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayStat = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle optionText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      bottomSheetTheme: const BottomSheetThemeData(
        dragHandleColor: Color(0xFFCBD5E1),
        dragHandleSize: Size(36, 4),
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.secondaryOrange,
        surface: AppColors.surfaceWhite,
        error: AppColors.errorRed,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.borderLight, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successGreen,
          foregroundColor: Colors.white,
          textStyle: AppTypography.buttonText,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
