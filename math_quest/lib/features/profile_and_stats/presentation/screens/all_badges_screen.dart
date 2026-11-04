import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/core/theme/theme_provider.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/badge_detail_bottom_sheet.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/all_badges_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/all_badges_widgets.dart';

class AllBadgesScreen extends ConsumerWidget {
  const AllBadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(visualThemeProvider);
    final state = ref.watch(allBadgesProvider);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AllBadgesAppBar(
        unlockedCount: state.unlockedCount,
        totalCount: state.totalCount,
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: ResponsiveContainer(
          maxWidth: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              AllBadgesCategoryFilter(
                categories: state.categories,
                selectedCategory: state.selectedCategory,
                primaryColor: theme.primary,
                onSelected: ref.read(allBadgesProvider.notifier).selectCategory,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: AllBadgesGrid(
                  badges: state.visibleBadges,
                  onBadgeTap: (badge) =>
                      showBadgeDetailBottomSheet(context, badge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
