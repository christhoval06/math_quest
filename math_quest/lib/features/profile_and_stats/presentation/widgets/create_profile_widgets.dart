import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/create_profile_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/profile_localizations.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class CreateProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;

  const CreateProfileAppBar({super.key, required this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.textPrimary,
        size: 20,
      ),
      onPressed: onBack,
    ),
    title: Text(
      AppLocalizations.of(context)!.addChildProfileTitle,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        fontSize: 18,
      ),
    ),
  );
}

class CreateProfileContent extends StatelessWidget {
  final CreateProfileState state;
  final bool isFromSettings;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onAvatarSelected;
  final ValueChanged<String> onGradeSelected;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const CreateProfileContent({
    super.key,
    required this.state,
    required this.isFromSettings,
    required this.onNameChanged,
    required this.onAvatarSelected,
    required this.onGradeSelected,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 24),
      const Center(child: Text('⭐', style: TextStyle(fontSize: 48))),
      const SizedBox(height: 8),
      Text(
        AppLocalizations.of(context)!.createHero,
        textAlign: TextAlign.center,
        style: AppTypography.titleLarge.copyWith(fontSize: 28),
      ),
      const SizedBox(height: 4),
      Text(
        AppLocalizations.of(context)!.createHeroDescription,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
      const SizedBox(height: 28),
      _SectionTitle(AppLocalizations.of(context)!.chooseAvatar),
      const SizedBox(height: 12),
      Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 6,
        runSpacing: 8,
        children: state.avatars
            .map(
              (avatar) => _AvatarOption(
                avatar: avatar,
                isSelected: state.selectedAvatar == avatar,
                onTap: () => onAvatarSelected(avatar),
              ),
            )
            .toList(growable: false),
      ),
      const SizedBox(height: 24),
      _SectionTitle(AppLocalizations.of(context)!.explorerNamePrompt),
      const SizedBox(height: 10),
      TextFormField(
        key: const Key('create-profile-name'),
        initialValue: state.name,
        enabled: !state.isSubmitting,
        onChanged: onNameChanged,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.enterName,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(
            Icons.person_rounded,
            color: AppColors.primaryBlue,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: AppColors.borderLight,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: AppColors.primaryBlue,
              width: 2,
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
      _SectionTitle(AppLocalizations.of(context)!.selectGrade),
      const SizedBox(height: 12),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
        ),
        itemCount: state.grades.length,
        itemBuilder: (context, index) {
          final grade = state.grades[index];
          return _GradeOption(
            grade: grade,
            isSelected:
                state.selectedGrade ==
                localizedProfileGrade(
                  AppLocalizations.of(context)!,
                  grade.title,
                ),
            onTap: () => onGradeSelected(grade.title),
          );
        },
      ),
      const SizedBox(height: 36),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryOrange,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        onPressed: state.isSubmitting ? null : onSubmit,
        child: Text(
          state.isSubmitting
              ? AppLocalizations.of(context)!.creatingProfile
              : AppLocalizations.of(context)!.startMyAdventure,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      if (isFromSettings) ...[
        const SizedBox(height: 12),
        TextButton(
          onPressed: state.isSubmitting ? null : onCancel,
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
      const SizedBox(height: 24),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
    ),
  );
}

class _AvatarOption extends StatelessWidget {
  final String avatar;
  final bool isSelected;
  final VoidCallback onTap;

  const _AvatarOption({
    required this.avatar,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context)!.avatarOption(avatar),
    button: true,
    selected: isSelected,
    excludeSemantics: true,
    onTap: onTap,
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.borderLight,
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [],
        ),
        child: Text(avatar, style: const TextStyle(fontSize: 32)),
      ),
    ),
  );
}

class _GradeOption extends StatelessWidget {
  final ProfileGradeOption grade;
  final bool isSelected;
  final VoidCallback onTap;

  const _GradeOption({
    required this.grade,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: isSelected,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.borderLight,
            width: isSelected ? 2.5 : 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localizedProfileGrade(AppLocalizations.of(context)!, grade.title),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? AppColors.primaryDarkBlue
                    : AppColors.textPrimary,
              ),
            ),
            Text(
              localizedProfileGradeAge(
                AppLocalizations.of(context)!,
                grade.subtitle,
              ),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
