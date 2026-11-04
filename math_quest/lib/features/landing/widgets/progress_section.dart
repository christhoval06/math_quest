import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/landing/theme/landing_theme.dart';
import 'package:math_quest/features/landing/widgets/landing_primitives.dart';
import 'package:math_quest/features/landing/widgets/phone_preview.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final rewards = [
      (
        Icons.star_outline_rounded,
        l.landingCoinsTitle,
        l.landingCoinsBody,
        const Color(0xFFA95D00),
      ),
      (
        Icons.local_fire_department_outlined,
        l.landingStreakTitle,
        l.landingStreakBody,
        LandingTheme.mint,
      ),
      (
        Icons.emoji_events_outlined,
        l.landingBadgesTitle,
        l.landingBadgesBody,
        LandingTheme.blue,
      ),
      (
        Icons.public_rounded,
        l.landingWorldsTitle,
        l.landingWorldsBody,
        const Color(0xFF7150B5),
      ),
    ];
    return ContentWidth(
      vertical: 56,
      child: SplitLayout(
        first: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeading(
              eyebrow: l.landingRewardsEyebrow,
              title: l.landingRewardsTitle,
              description: l.landingRewardsIntro,
              center: false,
              color: const Color(0xFFA95D00),
            ),
            const SizedBox(height: 26),
            LayoutBuilder(
              builder: (context, box) => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final reward in rewards)
                    SizedBox(
                      width: box.maxWidth < 370
                          ? box.maxWidth
                          : (box.maxWidth - 12) / 2,
                      child: SoftCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(reward.$1, color: reward.$4, size: 24),
                            const SizedBox(height: 10),
                            Text(
                              reward.$2,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: LandingTheme.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              reward.$3,
                              style: const TextStyle(
                                fontSize: 11,
                                height: 1.6,
                                color: LandingTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        second: LayoutBuilder(
          builder: (context, box) => SizedBox(
            height: 520,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 470,
                height: 530,
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 0,
                      child: Container(
                        width: 460,
                        height: 430,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0D9),
                          borderRadius: BorderRadius.circular(150),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 4,
                      top: 0,
                      child: Transform.rotate(
                        angle: -.035,
                        child: PhonePreview(
                          asset: 'assets/screens/s13.png',
                          label: l.landingScreenTrophies,
                          width: 217,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 42,
                      child: Transform.rotate(
                        angle: .035,
                        child: PhonePreview(
                          asset: 'assets/screens/s14.png',
                          label: l.landingScreenTrophies,
                          width: 217,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
