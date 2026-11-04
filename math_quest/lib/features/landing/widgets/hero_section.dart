import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/landing/theme/landing_theme.dart';
import 'package:math_quest/features/landing/widgets/landing_primitives.dart';
import 'package:math_quest/features/landing/widgets/phone_preview.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onStart,
    required this.onExplore,
  });
  final VoidCallback onStart, onExplore;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ContentWidth(
      vertical: 48,
      child: Column(
        children: [
          SplitLayout(
            gap: 20,
            first: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEED8),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF895100),
                        size: 14,
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Eyebrow(
                          l.landingHeroEyebrow,
                          color: const Color(0xFF895100),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Semantics(
                  header: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.landingHeroLead,
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              fontSize: MediaQuery.sizeOf(context).width < 640
                                  ? 38
                                  : 52,
                            ),
                      ),
                      Text(
                        l.landingHeroAccent,
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              fontSize: MediaQuery.sizeOf(context).width < 640
                                  ? 38
                                  : 52,
                              color: const Color(0xFFD57900),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  l.landingHeroDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 16,
                  children: [
                    LandingButton(
                      key: const Key('hero-action'),
                      label: l.landingStartAction,
                      onPressed: onStart,
                    ),
                    LandingButton(
                      label: l.landingExploreAction,
                      onPressed: onExplore,
                      icon: Icons.sports_esports_outlined,
                      secondary: true,
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                Wrap(
                  spacing: 18,
                  runSpacing: 10,
                  children: [
                    for (final proof in [
                      l.landingProofOffline,
                      l.landingProofAds,
                    ])
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: LandingTheme.mint,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              proof,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            second: const _HeroArtwork(),
          ),
          const SizedBox(height: 52),
          _Facts(),
        ],
      ),
    );
  }
}

class _HeroArtwork extends StatelessWidget {
  const _HeroArtwork();
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, box) => SizedBox(
        height: math.min(530, box.maxWidth * 1.12),
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 470,
            height: 530,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 40,
                  left: 10,
                  child: Container(
                    width: 420,
                    height: 420,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Color(0xFFE1F1FF), Color(0x00E1F1FF)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 5,
                  child: Container(
                    width: 285,
                    height: 390,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEDB).withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  top: 50,
                  child: Transform.rotate(
                    angle: -.10,
                    child: PhonePreview(
                      asset: 'assets/screens/s11.png',
                      label: l.landingScreenBlocks,
                      width: 216,
                    ),
                  ),
                ),
                Positioned(
                  right: 18,
                  top: 12,
                  child: Transform.rotate(
                    angle: .055,
                    child: PhonePreview(
                      asset: 'assets/screens/s5.png',
                      label: l.landingScreenDaily,
                      width: 224,
                    ),
                  ),
                ),
                const Positioned(
                  top: 8,
                  left: 6,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 33,
                    color: LandingTheme.orange,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  child: Container(
                    width: 264,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: LandingTheme.border),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0C131B2E),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF4D4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFE3A000),
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.landingDailyBadge,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: LandingTheme.ink,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                l.landingDailyBadgeDetail,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: LandingTheme.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Facts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final facts = [
      ('4', l.landingStatOperations, const Color(0xFFD57900)),
      ('3', l.landingStatDifficulty, LandingTheme.blue),
      ('4', l.landingStatWorlds, LandingTheme.mint),
      ('0', l.landingStatAds, LandingTheme.ink),
    ];
    return LayoutBuilder(
      builder: (context, box) {
        final columns = box.maxWidth < 640 ? 2 : 4;
        final width = (box.maxWidth - (columns - 1) * 14) / columns;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            for (final fact in facts)
              SizedBox(
                width: width,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 22,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .8),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: LandingTheme.border),
                  ),
                  child: Column(
                    children: [
                      Text(
                        fact.$1,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 31,
                          height: 1.2,
                          color: fact.$3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fact.$2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: LandingTheme.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
