import 'package:flutter/material.dart';

/// Screenshot already includes the system status bar; no duplicate notch.
class PhonePreview extends StatelessWidget {
  const PhonePreview({
    super.key,
    required this.asset,
    required this.label,
    this.width = 220,
    this.elevated = true,
  });
  final String asset;
  final String label;
  final double width;
  final bool elevated;
  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: label,
    child: Container(
      width: width,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF131721),
        borderRadius: BorderRadius.circular(29),
        border: Border.all(color: const Color(0xFF343A46), width: 1.5),
        boxShadow: elevated
            ? const [
                BoxShadow(
                  color: Color(0x24131B2E),
                  blurRadius: 25,
                  offset: Offset(0, 16),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Image.asset(
          asset,
          excludeFromSemantics: true,
          cacheWidth: (width * MediaQuery.devicePixelRatioOf(context)).ceil(),
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ),
    ),
  );
}
