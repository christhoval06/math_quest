import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/create_profile_state.dart';

class CreateProfileController extends StateNotifier<CreateProfileState> {
  final Future<void> Function(UserProfile profile) createProfileAction;
  final Future<void> Function() completeOnboardingAction;
  final DateTime Function() now;
  final String Function(DateTime timestamp) createId;
  Future<UserProfile>? _submission;
  UserProfile? _createdProfileAwaitingOnboarding;

  CreateProfileController({
    required this.createProfileAction,
    required this.completeOnboardingAction,
    required this.now,
    required this.createId,
  }) : super(CreateProfileState.initial());

  void setName(String name) => state = state.copyWith(name: name);

  void selectAvatar(String avatar) {
    if (!state.avatars.contains(avatar)) {
      throw ArgumentError.value(avatar, 'avatar', 'Unsupported avatar');
    }
    state = state.copyWith(selectedAvatar: avatar);
  }

  void selectGrade(String grade) {
    if (!state.grades.any((option) => option.title == grade)) {
      throw ArgumentError.value(grade, 'grade', 'Unsupported grade');
    }
    state = state.copyWith(selectedGrade: grade);
  }

  Future<UserProfile> submit() => _submission ??= _performSubmission();

  Future<UserProfile> _performSubmission() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    final existingProfile = _createdProfileAwaitingOnboarding;
    final profile = existingProfile ?? _buildProfile(now());

    try {
      if (existingProfile == null) {
        await createProfileAction(profile);
        _createdProfileAwaitingOnboarding = profile;
      }
      await completeOnboardingAction();
      _createdProfileAwaitingOnboarding = null;
      if (mounted) {
        state = state.copyWith(isSubmitting: false, errorMessage: null);
      }
      return profile;
    } catch (error, stackTrace) {
      if (mounted) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: error.toString(),
        );
      }
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      _submission = null;
    }
  }

  UserProfile _buildProfile(DateTime timestamp) {
    final trimmedName = state.name.trim();
    return UserProfile(
      id: createId(timestamp),
      name: trimmedName.isEmpty ? 'Explorer' : trimmedName,
      gradeLabel: state.selectedGrade,
      avatar: state.selectedAvatar,
      level: 1,
      starCoins: 100,
      xp: 0,
      currentStreak: 1,
      lastActiveDate: timestamp,
      dailyGoal: 10,
      masteryTracks: const {
        'addition': MasteryTrack(
          operation: MathOperationType.addition,
          level: 1,
          title: 'Sprout Explorer',
          totalSolved: 0,
          accuracy: 0,
        ),
        'subtraction': MasteryTrack(
          operation: MathOperationType.subtraction,
          level: 1,
          title: 'Sprout Explorer',
          totalSolved: 0,
          accuracy: 0,
        ),
        'multiplication': MasteryTrack(
          operation: MathOperationType.multiplication,
          level: 1,
          title: 'Sprout Explorer',
          totalSolved: 0,
          accuracy: 0,
        ),
        'division': MasteryTrack(
          operation: MathOperationType.division,
          level: 1,
          title: 'Sprout Explorer',
          totalSolved: 0,
          accuracy: 0,
        ),
      },
      unlockedBadgeIds: const [],
    );
  }
}
