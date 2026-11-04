import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/landing/services/landing_actions.dart';
import 'package:math_quest/features/landing/widgets/download_section.dart';
import 'package:math_quest/features/landing/widgets/hero_section.dart';
import 'package:math_quest/features/landing/widgets/landing_footer.dart';
import 'package:math_quest/features/landing/widgets/landing_header.dart';
import 'package:math_quest/features/landing/widgets/modes_section.dart';
import 'package:math_quest/features/landing/widgets/parents_section.dart';
import 'package:math_quest/features/landing/widgets/pedagogy_section.dart';
import 'package:math_quest/features/landing/widgets/progress_section.dart';
import 'package:math_quest/features/landing/widgets/screenshot_gallery.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, required this.onLocaleChanged, this.actions});
  final ValueChanged<Locale> onLocaleChanged;
  final LandingActions? actions;
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _top = GlobalKey();
  final _learning = GlobalKey();
  final _modes = GlobalKey();
  final _parents = GlobalKey();
  final _gallery = GlobalKey();
  bool _busy = false;

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _openLink(Uri destination, {required bool support}) async {
    if (_busy) return;
    final actions = widget.actions ?? const UrlLandingActions();
    setState(() => _busy = true);
    var opened = false;
    try {
      opened = await actions.open(destination);
    } catch (_) {
      opened = false;
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (!opened) {
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            support ? l.landingEmailFailure : l.landingDownloadFailure,
          ),
        ),
      );
    }
  }

  void _downloadApp() => _openLink(LandingLinks.appStore, support: false);

  void _contactSupport() {
    final l = AppLocalizations.of(context)!;
    _openLink(
      LandingLinks.support(
        subject: l.landingEmailSubject,
        body: l.landingEmailBody,
      ),
      support: true,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SelectionArea(
      child: SingleChildScrollView(
        key: const Key('landing-scroll'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LandingHeader(
              key: _top,
              onLocaleChanged: widget.onLocaleChanged,
              onLearning: () => _scrollTo(_learning),
              onModes: () => _scrollTo(_modes),
              onParents: () => _scrollTo(_parents),
              onGallery: () => _scrollTo(_gallery),
              onStart: _downloadApp,
            ),
            HeroSection(
              onStart: _downloadApp,
              onExplore: () => _scrollTo(_modes),
            ),
            PedagogySection(key: _learning),
            ModesSection(key: _modes),
            const ProgressSection(),
            ParentsSection(key: _parents),
            ScreenshotGallery(key: _gallery),
            DownloadSection(onDownload: _downloadApp, busy: _busy),
            LandingFooter(
              onTop: () => _scrollTo(_top),
              onParents: () => _scrollTo(_parents),
              onContact: _contactSupport,
            ),
          ],
        ),
      ),
    ),
  );
}
