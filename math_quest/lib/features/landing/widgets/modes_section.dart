import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/landing/theme/landing_theme.dart';
import 'package:math_quest/features/landing/widgets/landing_primitives.dart';
import 'package:math_quest/features/landing/widgets/phone_preview.dart';

class ModesSection extends StatelessWidget {
  const ModesSection({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final modes = [
      (
        l.landingPracticeTitle,
        l.landingPracticeBody,
        l.landingPracticeTag,
        's11',
        Icons.edit_outlined,
        const Color(0xFFEAF6FF),
        LandingTheme.blue,
      ),
      (
        l.landingDuelTitle,
        l.landingDuelBody,
        l.landingDuelTag,
        's7',
        Icons.people_outline_rounded,
        const Color(0xFFFFF0F3),
        const Color(0xFFAD3556),
      ),
      (
        l.landingMissionTitle,
        l.landingMissionBody,
        l.landingMissionTag,
        's8',
        Icons.tune_rounded,
        const Color(0xFFFFF6E7),
        const Color(0xFFA95D00),
      ),
      (
        l.landingWorldTitle,
        l.landingWorldBody,
        l.landingWorldTag,
        's6',
        Icons.explore_outlined,
        const Color(0xFFEDFAF3),
        LandingTheme.mint,
      ),
    ];
    return ContentWidth(
      vertical: 48,
      child: Column(
        children: [
          SectionHeading(
            eyebrow: l.landingModesEyebrow,
            title: l.landingModesTitle,
            description: l.landingModesIntro,
          ),
          const SizedBox(height: 36),
          LayoutBuilder(
            builder: (context, box) {
              final columns = box.maxWidth >= 950
                  ? 4
                  : box.maxWidth >= 550
                  ? 2
                  : 1;
              final width = (box.maxWidth - (columns - 1) * 16) / columns;
              return Wrap(
                spacing: 16,
                runSpacing: 20,
                children: [
                  for (final mode in modes)
                    SizedBox(
                      width: width,
                      child: SoftCard(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 262,
                              width: double.infinity,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: mode.$6,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: OverflowBox(
                                alignment: Alignment.topCenter,
                                maxHeight: 420,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 22),
                                  child: PhonePreview(
                                    asset: 'assets/screens/${mode.$4}.png',
                                    label: mode.$1,
                                    width: 157,
                                    elevated: false,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(mode.$5, size: 18, color: mode.$7),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(
                                    mode.$1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              mode.$2,
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.7,
                                color: LandingTheme.muted,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              mode.$3,
                              style: TextStyle(
                                fontSize: 9,
                                height: 1.5,
                                letterSpacing: .7,
                                fontWeight: FontWeight.w800,
                                color: mode.$7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
