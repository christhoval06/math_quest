import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/landing/widgets/landing_primitives.dart';

class DownloadSection extends StatelessWidget {
  const DownloadSection({
    super.key,
    required this.onDownload,
    required this.busy,
  });
  final VoidCallback onDownload;
  final bool busy;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ContentWidth(
      vertical: 40,
      child: Container(
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width < 640 ? 28 : 48,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF131B2E), Color(0xFF293348)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19131B2E),
              blurRadius: 25,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: SplitLayout(
          breakpoint: 700,
          gap: 32,
          first: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(l.landingDownloadEyebrow, color: const Color(0xFFFFCB7B)),
              const SizedBox(height: 18),
              Semantics(
                header: true,
                child: Text(
                  l.landingDownloadTitle,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontSize: MediaQuery.sizeOf(context).width < 640 ? 28 : 34,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l.landingDownloadBody,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.8,
                  color: Color(0xFFD8DFEF),
                ),
              ),
              const SizedBox(height: 26),
              LandingButton(
                key: const Key('download-action'),
                label: l.landingDownloadAction,
                icon: Icons.apple_rounded,
                onPressed: busy ? null : onDownload,
              ),
              const SizedBox(height: 16),
              Text(
                l.landingDownloadNote,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.7,
                  color: Color(0xFFBDC7DB),
                ),
              ),
            ],
          ),
          second: Center(
            child: ExcludeSemantics(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .13),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/branding/app_icon.png',
                        width: 136,
                        height: 136,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '+  −  ×  ÷',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 12,
                      color: Color(0xFFFFCB7B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
