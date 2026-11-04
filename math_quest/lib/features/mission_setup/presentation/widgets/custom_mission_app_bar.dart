import 'package:flutter/material.dart';

import 'package:math_quest/l10n/app_localizations.dart';
import 'package:math_quest/core/theme/app_theme.dart';

class CustomMissionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int starCoins;
  final int streakDays;
  final VoidCallback? onBack;

  const CustomMissionAppBar({
    super.key,
    required this.starCoins,
    required this.streakDays,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: onBack == null
          ? null
          : IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: 20,
              ),
              onPressed: onBack,
            ),
      title: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.navPractice,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          _CounterBadge(
            background: const Color(0xFFFFFBEB),
            border: const Color(0xFFFDE68A),
            icon: const Text('🪙', style: TextStyle(fontSize: 14)),
            text: '$starCoins',
            textColor: const Color(0xFFB45309),
          ),
          const SizedBox(width: 8),
          _CounterBadge(
            background: const Color(0xFFFFF7ED),
            border: const Color(0xFFFFEDD5),
            icon: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.secondaryOrange,
              size: 16,
            ),
            text: AppLocalizations.of(context)!.daysShort(streakDays),
            textColor: AppColors.secondaryOrange,
          ),
        ],
      ),
    );
  }
}

class _CounterBadge extends StatelessWidget {
  final Color background;
  final Color border;
  final Widget icon;
  final String text;
  final Color textColor;

  const _CounterBadge({
    required this.background,
    required this.border,
    required this.icon,
    required this.text,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
