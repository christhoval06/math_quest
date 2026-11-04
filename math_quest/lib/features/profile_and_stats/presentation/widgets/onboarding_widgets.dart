import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/core/widgets/typewriter_text.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/onboarding_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/profile_localizations.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class OnboardingTopBar extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardingTopBar({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '🚀 MathQuest',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: onSkip,
          child: Text(
            AppLocalizations.of(context)!.skip,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    ),
  );
}

class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideViewData slide;

  const OnboardingSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: slide.accentColor.withValues(alpha: 0.3),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: slide.accentColor.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(slide.icon, style: const TextStyle(fontSize: 64)),
        ),
        const SizedBox(height: 36),
        Text(
          slide.localizedTitle(AppLocalizations.of(context)!),
          textAlign: TextAlign.center,
          style: AppTypography.titleLarge.copyWith(fontSize: 26),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: Semantics(
            label: slide.localizedDescription(AppLocalizations.of(context)!),
            child: ExcludeSemantics(
              child: TypewriterText(
                key: ValueKey(
                  slide.localizedDescription(AppLocalizations.of(context)!),
                ),
                text: slide.localizedDescription(AppLocalizations.of(context)!),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class OnboardingFooter extends StatelessWidget {
  final OnboardingState state;
  final VoidCallback onNext;

  const OnboardingFooter({
    super.key,
    required this.state,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Semantics(
          label: AppLocalizations.of(context)!
              .onboardingPage(state.currentPage + 1, state.slides.length),
          child: ExcludeSemantics(
            child: Row(
              children: List.generate(state.slides.length, (index) {
                final isSelected = state.currentPage == index;
                return AnimatedContainer(
                  key: Key(
                    isSelected
                        ? 'onboarding-dot-$index-selected'
                        : 'onboarding-dot-$index',
                  ),
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(right: 6),
                  width: isSelected ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? state.currentSlide.accentColor
                        : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: state.currentSlide.accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: onNext,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    state.isLastPage
                        ? AppLocalizations.of(context)!.getStarted
                        : AppLocalizations.of(context)!.next,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (!state.isLastPage) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
