import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/landing/theme/landing_theme.dart';
import 'package:math_quest/features/landing/widgets/landing_primitives.dart';
import 'package:math_quest/features/landing/widgets/phone_preview.dart';

class ParentsSection extends StatelessWidget {
  const ParentsSection({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ContentWidth(
      vertical: 48,
      child: SoftCard(
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width < 640 ? 22 : 44,
        ),
        child: SplitLayout(
          first: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
              decoration: BoxDecoration(
                color: LandingTheme.lavender,
                borderRadius: BorderRadius.circular(140),
              ),
              child: PhonePreview(
                asset: 'assets/screens/s15.png',
                label: l.landingScreenReport,
                width: 232,
              ),
            ),
          ),
          second: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(
                eyebrow: l.landingParentEyebrow,
                title: l.landingParentTitle,
                description: l.landingParentIntro,
                center: false,
                color: const Color(0xFF7150B5),
              ),
              const SizedBox(height: 24),
              for (final feature in [
                (
                  Icons.insights_rounded,
                  l.landingReportTitle,
                  l.landingReportBody,
                ),
                (
                  Icons.people_outline_rounded,
                  l.landingProfilesTitle,
                  l.landingProfilesBody,
                ),
                (
                  Icons.shield_outlined,
                  l.landingControlsTitle,
                  l.landingControlsBody,
                ),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(feature.$1, color: LandingTheme.blue, size: 21),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature.$2,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: LandingTheme.ink,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              feature.$3,
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.7,
                                color: LandingTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
