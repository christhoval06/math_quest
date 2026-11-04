import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

import 'package:math_quest/features/landing/theme/landing_theme.dart';
import 'package:math_quest/features/landing/models/landing_screenshot.dart';
import 'package:math_quest/features/landing/widgets/landing_primitives.dart';
import 'package:math_quest/features/landing/widgets/phone_preview.dart';

class ScreenshotGallery extends StatefulWidget {
  const ScreenshotGallery({super.key});
  @override
  State<ScreenshotGallery> createState() => _ScreenshotGalleryState();
}

class _ScreenshotGalleryState extends State<ScreenshotGallery> {
  final _controller = ScrollController();
  bool _atStart = true;
  bool _atEnd = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateBoundaries);
  }

  void _updateBoundaries() {
    if (!_controller.hasClients) return;
    final start = _controller.offset <= 1;
    final end = _controller.offset >= _controller.position.maxScrollExtent - 1;
    if (_atStart != start || _atEnd != end) {
      setState(() {
        _atStart = start;
        _atEnd = end;
      });
    }
  }

  void _move(int direction) {
    final target = (_controller.offset + direction * 464).clamp(
      0.0,
      _controller.position.maxScrollExtent,
    );
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.jumpTo(target);
    } else {
      _controller.animateTo(
        target,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return ContentWidth(
      vertical: 48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            eyebrow: l.landingGalleryEyebrow,
            title: l.landingGalleryTitle,
            center: false,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton.filledTonal(
                key: const Key('gallery-previous'),
                tooltip: l.landingGalleryPrevious,
                onPressed: _atStart ? null : () => _move(-1),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                key: const Key('gallery-next'),
                tooltip: l.landingGalleryNext,
                onPressed: _atEnd ? null : () => _move(1),
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ],
          ),
          const SizedBox(height: 16),
          NotificationListener<ScrollMetricsNotification>(
            onNotification: (_) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _updateBoundaries();
              });
              return false;
            },
            child: SingleChildScrollView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 26),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final shot in LandingScreenshot.values)
                      Padding(
                        padding: EdgeInsets.only(
                          right: shot == LandingScreenshot.values.last ? 0 : 22,
                        ),
                        child: SizedBox(
                          width: 210,
                          child: Column(
                            children: [
                              PhonePreview(
                                asset: shot.asset,
                                label: shot.caption(l),
                                width: 200,
                              ),
                              const SizedBox(height: 22),
                              Text(
                                shot.caption(l),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  height: 1.6,
                                  color: LandingTheme.ink,
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
        ],
      ),
    );
  }
}
