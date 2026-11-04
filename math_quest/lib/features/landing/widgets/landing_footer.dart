import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/landing/theme/landing_theme.dart';
import 'package:math_quest/features/landing/widgets/landing_primitives.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({
    super.key,
    required this.onTop,
    required this.onParents,
    required this.onContact,
  });
  final VoidCallback onTop, onParents, onContact;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ContentWidth(
      vertical: 36,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 28),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 48,
            runSpacing: 20,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MathQuest',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: LandingTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l.landingFooterLine,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: onParents,
                    child: Text(l.landingNavParents),
                  ),
                  TextButton(
                    key: const Key('contact-action'),
                    onPressed: onContact,
                    child: Text(l.landingContactLabel),
                  ),
                  TextButton.icon(
                    onPressed: onTop,
                    icon: const Icon(Icons.arrow_upward_rounded, size: 15),
                    label: Text(l.landingBackToTop),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            '© ${DateTime.now().year} MathQuest. ${l.landingFooterCredit}',
            style: const TextStyle(fontSize: 10, height: 1.7),
          ),
        ],
      ),
    );
  }
}
