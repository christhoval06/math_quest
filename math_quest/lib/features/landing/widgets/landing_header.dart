import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/landing/theme/landing_theme.dart';
import 'package:math_quest/features/landing/widgets/landing_primitives.dart';

class LandingHeader extends StatelessWidget {
  const LandingHeader({
    super.key,
    required this.onLocaleChanged,
    required this.onLearning,
    required this.onModes,
    required this.onParents,
    required this.onGallery,
    required this.onStart,
  });
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback onLearning, onModes, onParents, onGallery, onStart;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final links = [
      (l.landingNavLearning, onLearning),
      (l.landingNavModes, onModes),
      (l.landingNavParents, onParents),
      (l.landingNavGallery, onGallery),
    ];
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: LandingTheme.canvas,
        border: Border(bottom: BorderSide(color: LandingTheme.border)),
      ),
      child: ContentWidth(
        vertical: 18,
        child: LayoutBuilder(
          builder: (context, box) => Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/branding/app_icon.png',
                      width: 36,
                      height: 36,
                      excludeFromSemantics: true,
                    ),
                    const SizedBox(width: 9),
                    const Flexible(
                      child: Text(
                        'MathQuest',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: -.6,
                          color: LandingTheme.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (box.maxWidth >= 950 &&
                  MediaQuery.textScalerOf(context).scale(1) <= 1.2)
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      for (var i = 0; i < links.length; i++)
                        Expanded(
                          child: TextButton(
                            key: i == 3 ? const Key('nav-gallery') : null,
                            onPressed: links[i].$2,
                            child: Text(
                              links[i].$1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: LandingTheme.muted,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              else
                PopupMenuButton<int>(
                  tooltip: l.landingOpenMenu,
                  icon: const Icon(Icons.menu_rounded),
                  onSelected: (index) => links[index].$2(),
                  itemBuilder: (_) => [
                    for (var i = 0; i < links.length; i++)
                      PopupMenuItem(value: i, child: Text(links[i].$1)),
                  ],
                ),
              if (box.maxWidth > 1000)
                IconButton(
                  tooltip: l.landingStartAction,
                  onPressed: onStart,
                  icon: const Icon(
                    Icons.rocket_launch_rounded,
                    color: Color(0xFF895100),
                  ),
                ),
              PopupMenuButton<String>(
                key: const Key('language-selector'),
                tooltip: l.landingLanguageLabel,
                onSelected: (code) => onLocaleChanged(Locale(code)),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'en', child: Text('English')),
                  PopupMenuItem(value: 'es', child: Text('Español')),
                  PopupMenuItem(value: 'pt', child: Text('Português')),
                ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.language_rounded, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        Localizations.localeOf(context).languageCode
                            .toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
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
    );
  }
}
