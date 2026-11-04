import 'package:flutter/material.dart';

import 'package:math_quest/features/landing/theme/landing_theme.dart';

class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.vertical = 0});
  final Widget child;
  final double vertical;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.sizeOf(context).width < 640 ? 20 : 40,
      vertical: vertical,
    ),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: SizedBox(width: double.infinity, child: child),
      ),
    ),
  );
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = LandingTheme.blue});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 10,
      letterSpacing: 1.6,
      height: 1.6,
      fontWeight: FontWeight.w800,
      color: color,
    ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.description,
    this.center = true,
    this.color = LandingTheme.blue,
  });
  final String eyebrow;
  final String title;
  final String? description;
  final bool center;
  final Color color;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start,
    children: [
      Eyebrow(eyebrow, color: color),
      const SizedBox(height: 12),
      Semantics(
        header: true,
        child: Text(
          title,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: MediaQuery.sizeOf(context).width < 640
              ? Theme.of(context).textTheme.headlineMedium
              : Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      if (description != null) ...[
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Text(
            description!,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    ],
  );
}

class LandingButton extends StatelessWidget {
  const LandingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.rocket_launch_rounded,
    this.secondary = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool secondary;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      boxShadow: [
        BoxShadow(
          color: secondary ? const Color(0x0C131B2E) : const Color(0xFFDC850D),
          offset: Offset(0, secondary ? 3 : 4),
          blurRadius: secondary ? 12 : 0,
        ),
      ],
    ),
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(label, textAlign: TextAlign.center),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: secondary ? Colors.white : LandingTheme.orange,
        foregroundColor: secondary ? LandingTheme.ink : const Color(0xFF392000),
        disabledBackgroundColor: LandingTheme.border,
        minimumSize: const Size(48, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
        side: secondary
            ? const BorderSide(color: LandingTheme.border)
            : BorderSide.none,
      ),
    ),
  );
}

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(24),
  });
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: LandingTheme.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x06131B2E),
          offset: Offset(0, 4),
          blurRadius: 16,
        ),
      ],
    ),
    child: child,
  );
}

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.color = LandingTheme.blue,
    this.surface = LandingTheme.lavender,
  });
  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final Color surface;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .09),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 23),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  height: 1.4,
                  color: LandingTheme.ink,
                ),
              ),
              const SizedBox(height: 5),
              Text(body),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Wraps instead of squeezing columns, including when text is enlarged.
class SplitLayout extends StatelessWidget {
  const SplitLayout({
    super.key,
    required this.first,
    required this.second,
    this.gap = 56,
    this.breakpoint = 780,
  });
  final Widget first;
  final Widget second;
  final double gap;
  final double breakpoint;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      if (box.maxWidth < breakpoint) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            first,
            SizedBox(height: gap),
            second,
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: first),
          SizedBox(width: gap),
          Expanded(child: second),
        ],
      );
    },
  );
}
