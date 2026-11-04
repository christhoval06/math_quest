import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/core/navigation/app_router.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/create_profile_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/create_profile_widgets.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class CreateProfileScreen extends ConsumerWidget {
  final bool isFromSettings;

  const CreateProfileScreen({super.key, this.isFromSettings = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createProfileProvider);
    final controller = ref.read(createProfileProvider.notifier);

    return Scaffold(
      appBar: isFromSettings
          ? CreateProfileAppBar(onBack: () => Navigator.pop(context))
          : null,
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          key: const Key('create-profile-scroll'),
          child: ResponsiveContainer(
            child: CreateProfileContent(
              state: state,
              isFromSettings: isFromSettings,
              onNameChanged: controller.setName,
              onAvatarSelected: controller.selectAvatar,
              onGradeSelected: controller.selectGrade,
              onSubmit: () => _submit(context, ref),
              onCancel: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    try {
      final profile = await ref.read(createProfileProvider.notifier).submit();
      if (!context.mounted) return;

      if (isFromSettings) {
        final messenger = ScaffoldMessenger.of(context);
        Navigator.pop(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.profileCreated(profile.name),
            ),
            backgroundColor: AppColors.successGreen,
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.profileCreationFailed),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }
}
