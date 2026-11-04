import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/landing/theme/landing_theme.dart';
import 'package:math_quest/features/landing/widgets/landing_primitives.dart';
import 'package:math_quest/features/landing/widgets/phone_preview.dart';

class PedagogySection extends StatelessWidget {
  const PedagogySection({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ContentWidth(
      vertical: 48,
      child: Column(
        children: [
          SectionHeading(
            eyebrow: l.landingLearningEyebrow,
            title: l.landingLearningTitle,
            description: l.landingLearningIntro,
            color: LandingTheme.mint,
          ),
          const SizedBox(height: 36),
          SoftCard(
            padding: EdgeInsets.all(
              MediaQuery.sizeOf(context).width < 640 ? 20 : 44,
            ),
            child: SplitLayout(
              first: Column(
                children: [
                  FeatureTile(
                    icon: Icons.grid_view_rounded,
                    title: l.landingBlocksTitle,
                    body: l.landingBlocksBody,
                  ),
                  const SizedBox(height: 16),
                  FeatureTile(
                    icon: Icons.wb_sunny_outlined,
                    title: l.landingEncouragementTitle,
                    body: l.landingEncouragementBody,
                    color: const Color(0xFFA95D00),
                    surface: const Color(0xFFFFF7E9),
                  ),
                  const SizedBox(height: 16),
                  FeatureTile(
                    icon: Icons.psychology_outlined,
                    title: l.landingPaceTitle,
                    body: l.landingPaceBody,
                    color: LandingTheme.mint,
                    surface: const Color(0xFFEDFAF3),
                  ),
                ],
              ),
              second: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F9FF),
                    borderRadius: BorderRadius.circular(140),
                  ),
                  child: PhonePreview(
                    asset: 'assets/screens/s9.png',
                    label: l.landingScreenBlocks,
                    width: 234,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
