import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/badge_grid_card.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/badge_visuals.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/all_badges_state.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class AllBadgesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int unlockedCount;
  final int totalCount;
  final VoidCallback onBack;

  const AllBadgesAppBar({
    super.key,
    required this.unlockedCount,
    required this.totalCount,
    required this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.textPrimary,
        size: 20,
      ),
      onPressed: onBack,
    ),
    title: Text(
      AppLocalizations.of(context)!.allBadgesTitle,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        fontSize: 18,
      ),
    ),
    actions: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.secondaryOrange,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '$unlockedCount / $totalCount',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: Color(0xFFB45309),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class AllBadgesCategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Color primaryColor;
  final ValueChanged<String> onSelected;

  const AllBadgesCategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.primaryColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: categories
          .map((category) {
            final isSelected = selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  AppLocalizations.of(context)!
                      .badgeCategory(category, category),
                ),
                selected: isSelected,
                onSelected: (_) => onSelected(category),
                selectedColor: primaryColor,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            );
          })
          .toList(growable: false),
    ),
  );
}

class AllBadgesGrid extends StatelessWidget {
  final List<BadgeViewData> badges;
  final ValueChanged<BadgeViewData> onBadgeTap;

  const AllBadgesGrid({
    super.key,
    required this.badges,
    required this.onBadgeTap,
  });

  @override
  Widget build(BuildContext context) => badges.isEmpty
      ? Center(
          child: Text(
            AppLocalizations.of(context)!.noCategoryBadges,
            textAlign: TextAlign.center,
          ),
        )
      : LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(1);
            final columns = constraints.maxWidth / textScale < 280 ? 1 : 2;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 252 * textScale,
              ),
              itemCount: badges.length,
              itemBuilder: (context, index) {
                final badge = badges[index];
                return BadgeGridCard(
                  badge: badge,
                  onTap: () => onBadgeTap(badge),
                );
              },
            );
          },
        );
}

class BadgeDetailContent extends StatelessWidget {
  final BadgeViewData badge;
  final VoidCallback onClose;

  const BadgeDetailContent({
    super.key,
    required this.badge,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 8),
      Center(child: BadgeEmblem(badge: badge, size: 88)),
      const SizedBox(height: 20),
      Text(
        AppLocalizations.of(context)!.gameBadgeTitle(badge.id, badge.title),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          height: 1.2,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
      const SizedBox(height: 10),
      BadgeStatus(badge: badge),
      const SizedBox(height: 20),
      BadgeMetadata(badge: badge),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          AppLocalizations.of(context)!
              .gameBadgeDescription(badge.id, badge.description),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ),
      const SizedBox(height: 24),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
        onPressed: onClose,
        child: Text(
          AppLocalizations.of(context)!.gotIt,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    ],
  );
}
