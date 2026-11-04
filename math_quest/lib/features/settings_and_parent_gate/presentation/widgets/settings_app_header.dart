import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class SettingsAppHeader extends StatefulWidget {
  const SettingsAppHeader({super.key});

  @override
  State<SettingsAppHeader> createState() => _SettingsAppHeaderState();
}

class _SettingsAppHeaderState extends State<SettingsAppHeader> {
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x181CB0F6),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.asset(
                'assets/images/branding/app_icon.png',
                width: 80,
                height: 80,
                excludeFromSemantics: true,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(l10n.appTitle, style: AppTypography.titleLarge),
          FutureBuilder<PackageInfo>(
            future: _packageInfo,
            builder: (context, snapshot) {
              final info = snapshot.data;
              if (info == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'v${info.version} (${info.buildNumber})',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            l10n.appTagline,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
