import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class HomeDashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int starCoins;
  final int streakDays;
  final VoidCallback onSettings;

  const HomeDashboardAppBar({
    super.key,
    required this.starCoins,
    required this.streakDays,
    required this.onSettings,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('⭐', style: TextStyle(fontSize: 20)),
            SizedBox(width: 6),
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      actions: [
        _TopBadge(
          leading: const Text('🪙', style: TextStyle(fontSize: 12)),
          label: '$starCoins',
          color: const Color(0xFFFFFBEB),
          borderColor: const Color(0xFFFDE68A),
          textColor: const Color(0xFFB45309),
        ),
        const SizedBox(width: 6),
        _TopBadge(
          leading: const Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.secondaryOrange,
            size: 14,
          ),
          label: AppLocalizations.of(context)!.daysShort(streakDays),
          color: const Color(0xFFFFF7ED),
          borderColor: const Color(0xFFFFEDD5),
          textColor: AppColors.secondaryOrange,
        ),
        IconButton(
          icon: const Icon(
            Icons.settings_rounded,
            color: AppColors.textSecondary,
            size: 22,
          ),
          onPressed: onSettings,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _TopBadge extends StatelessWidget {
  final Widget leading;
  final String label;
  final Color color;
  final Color borderColor;
  final Color textColor;

  const _TopBadge({
    required this.leading,
    required this.label,
    required this.color,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading,
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
