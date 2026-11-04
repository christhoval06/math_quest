import 'package:flutter/material.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/badge_item.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/all_badges_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/badge_detail_bottom_sheet.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/badge_grid_card.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class BadgeShowcaseSection extends StatelessWidget {
  final List<String> unlockedBadgeIds;
  final Color primaryColor;

  const BadgeShowcaseSection({
    super.key,
    required this.unlockedBadgeIds,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final all = BadgeItem.allBadges;
    final recent = all
        .take(4)
        .map(
          (badge) => BadgeViewData.fromItem(
            badge,
            isUnlocked: unlockedBadgeIds.contains(badge.id),
          ),
        )
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.recentBadges,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.allBadges),
              style: TextButton.styleFrom(foregroundColor: primaryColor),
              child: Text(
                AppLocalizations.of(context)!.viewAllCount(all.length),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < recent.length; index += 2) ...[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (
                  var column = 0;
                  column < 2 && index + column < recent.length;
                  column++
                ) ...[
                  if (column > 0) const SizedBox(width: 10),
                  Expanded(
                    child: BadgeGridCard(
                      badge: recent[index + column],
                      onTap: () => showBadgeDetailBottomSheet(
                        context,
                        recent[index + column],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (index + 2 < recent.length) const SizedBox(height: 10),
        ],
      ],
    );
  }
}
