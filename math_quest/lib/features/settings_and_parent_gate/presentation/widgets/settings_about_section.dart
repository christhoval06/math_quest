import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/services/support_email.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/settings_info_sheet.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class SettingsAboutSection extends StatelessWidget {
  final Future<bool> Function(Uri)? openEmail;

  const SettingsAboutSection({super.key, this.openEmail});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            l10n.aboutSectionTitle,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.borderLight),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _AboutRow(
                icon: Icons.info_outline_rounded,
                title: l10n.aboutAppTitle,
                subtitle: l10n.aboutAppSubtitle,
                color: AppColors.primaryDarkBlue,
                onTap: () => showSettingsInfoSheet(
                  context,
                  icon: Icons.auto_stories_outlined,
                  title: l10n.aboutAppTitle,
                  body: l10n.aboutAppStory,
                  items: [
                    SettingsInfoItem(
                      Icons.edit_note_rounded,
                      l10n.aboutPracticeTitle,
                      l10n.aboutPracticeBody,
                    ),
                    SettingsInfoItem(
                      Icons.route_outlined,
                      l10n.aboutPaceTitle,
                      l10n.aboutPaceBody,
                    ),
                    SettingsInfoItem(
                      Icons.favorite_border_rounded,
                      l10n.aboutFamilyTitle,
                      l10n.aboutFamilyBody,
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                indent: 64,
                endIndent: 16,
                color: AppColors.borderLight,
              ),
              _AboutRow(
                icon: Icons.code_rounded,
                title: l10n.aboutDeveloperTitle,
                subtitle: l10n.aboutDeveloperSubtitle,
                color: AppColors.accentPurple,
                onTap: () => showSettingsInfoSheet(
                  context,
                  icon: Icons.code_rounded,
                  title: l10n.aboutDeveloperTitle,
                  body: l10n.aboutDeveloperBio,
                  items: [
                    SettingsInfoItem(
                      Icons.badge_outlined,
                      l10n.developerRoleTitle,
                      l10n.developerRoleBody,
                    ),
                    SettingsInfoItem(
                      Icons.terminal_rounded,
                      l10n.developerStackTitle,
                      l10n.developerStackBody,
                    ),
                    SettingsInfoItem(
                      Icons.design_services_outlined,
                      l10n.developerFocusTitle,
                      l10n.developerFocusBody,
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                indent: 64,
                endIndent: 16,
                color: AppColors.borderLight,
              ),
              _AboutRow(
                icon: Icons.mail_outline_rounded,
                title: l10n.contactSupportTitle,
                subtitle: l10n.contactSupportSubtitle,
                color: AppColors.textSecondary,
                onTap: () => _contact(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _contact(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    var opened = false;
    try {
      opened = await (openEmail ?? SupportEmail.open)(
        SupportEmail.compose(
          subject: l10n.supportEmailSubject,
          body: l10n.supportEmailBody,
        ),
      );
    } catch (_) {
      // Devices without a configured mail app can still copy the address.
    }
    if (opened || !context.mounted) return;
    await showSettingsInfoSheet(
      context,
      icon: Icons.mail_outline_rounded,
      title: l10n.contactSupportTitle,
      body: l10n.supportEmailUnavailable,
      footer: const _SupportAddress(),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AboutRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
            size: 20,
          ),
        ],
      ),
    ),
  );
}

class _SupportAddress extends StatefulWidget {
  const _SupportAddress();

  @override
  State<_SupportAddress> createState() => _SupportAddressState();
}

class _SupportAddressState extends State<_SupportAddress> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        const SelectableText(
          SupportEmail.address,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () async {
            await Clipboard.setData(
              const ClipboardData(text: SupportEmail.address),
            );
            if (mounted) setState(() => _copied = true);
          },
          icon: Icon(
            _copied ? Icons.check_rounded : Icons.copy_rounded,
            size: 18,
          ),
          label: Text(_copied ? l10n.emailCopied : l10n.copyEmail),
        ),
      ],
    );
  }
}
