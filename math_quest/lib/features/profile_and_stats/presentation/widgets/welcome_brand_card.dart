import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class WelcomeBrandCard extends StatelessWidget {
  final double floatOffset;
  final String logoAssetPath;

  const WelcomeBrandCard({
    super.key,
    required this.floatOffset,
    this.logoAssetPath = 'assets/images/branding/splash_logo.png',
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      key: const Key('welcome-brand-float'),
      offset: Offset(0, floatOffset),
      child: Container(
        width: 175,
        height: 175,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: const Color(0xFFFDE68A), width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryOrange.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logoAssetPath,
              width: 90,
              height: 90,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  const Text('⭐', style: TextStyle(fontSize: 68)),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppLocalizations.of(context)!.starMath,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFB45309),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
