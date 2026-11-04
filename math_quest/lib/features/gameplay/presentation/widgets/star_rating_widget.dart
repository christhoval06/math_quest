import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class StarRatingWidget extends StatefulWidget {
  final int starsEarned; // 0 to 3

  const StarRatingWidget({super.key, required this.starsEarned});

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isEarned = index < widget.starsEarned;
            final delay = index * 0.25;

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final progress = (_controller.value - delay).clamp(0.0, 1.0);
                final scale = isEarned
                    ? Curves.elasticOut.transform(progress)
                    : 1.0;

                return Transform.scale(
                  scale: scale,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Icon(
                      Icons.star_rounded,
                      size: index == 1 ? 72 : 54, // Center star is larger
                      color: isEarned
                          ? AppColors.secondaryOrange
                          : AppColors.borderLight,
                    ),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.starsEarned(widget.starsEarned),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            color: AppColors.secondaryOrange,
          ),
        ),
      ],
    );
  }
}
