import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class OnboardingSlideViewData {
  final String? localizationId;
  final String icon;
  final String title;
  final String description;
  final Color accentColor;
  final Color backgroundTint;

  const OnboardingSlideViewData({
    this.localizationId,
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.backgroundTint,
  });
}

class OnboardingState {
  static const defaultSlides = [
    OnboardingSlideViewData(
      icon: '⭐',
      localizationId: 'welcome',
      title: 'Welcome to MathQuest!',
      description: 'Turn arithmetic into a thrilling cosmic adventure where learning feels like play.',
      accentColor: AppColors.secondaryOrange,
      backgroundTint: Color(0xFFFFFBEB),
    ),
    OnboardingSlideViewData(
      icon: '🧱',
      localizationId: 'blocks',
      title: 'Visual Counting Blocks',
      description: 'See numbers come to life with Base-10 blocks! Counting tens and ones makes carrying easy.',
      accentColor: AppColors.primaryBlue,
      backgroundTint: Color(0xFFEFF6FF),
    ),
    OnboardingSlideViewData(
      icon: '👑',
      localizationId: 'adventure',
      title: 'Defeat Bosses & Win Trophies',
      description: 'Climb Adventure Island, unlock new worlds, collect badges, and battle in 2-Player Duels!',
      accentColor: AppColors.successGreen,
      backgroundTint: Color(0xFFF0FDF4),
    ),
  ];

  final int currentPage;
  final List<OnboardingSlideViewData> slides;

  OnboardingState({
    required this.currentPage,
    required List<OnboardingSlideViewData> slides,
  }) : slides = UnmodifiableListView(List.of(slides)) {
    RangeError.checkValidIndex(currentPage, slides, 'currentPage');
  }

  factory OnboardingState.initial() =>
      OnboardingState(currentPage: 0, slides: defaultSlides);

  OnboardingSlideViewData get currentSlide => slides[currentPage];
  bool get isLastPage => currentPage == slides.length - 1;
  String get primaryActionLabel => isLastPage ? 'Get Started 🚀' : 'Next';

  OnboardingState withPage(int page) =>
      OnboardingState(currentPage: page, slides: slides);
}
