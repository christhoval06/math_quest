import 'dart:collection';

class ProfileGradeOption {
  final String title;
  final String subtitle;

  const ProfileGradeOption({required this.title, required this.subtitle});
}

class CreateProfileState {
  static const defaultAvatars = [
    '👦',
    '👧',
    '🚀',
    '🦊',
    '🦁',
    '🐼',
    '🐯',
    '🐨',
    '🐸',
    '🦉',
  ];
  static const defaultGrades = [
    ProfileGradeOption(title: 'Kindergarten', subtitle: 'Age 4-5'),
    ProfileGradeOption(title: 'Grade 1', subtitle: 'Age 6-7'),
    ProfileGradeOption(title: 'Grade 2', subtitle: 'Age 7-8'),
    ProfileGradeOption(title: 'Grade 3+', subtitle: 'Age 8-10'),
  ];

  final String name;
  final String selectedAvatar;
  final String selectedGrade;
  final List<String> avatars;
  final List<ProfileGradeOption> grades;
  final bool isSubmitting;
  final String? errorMessage;

  CreateProfileState({
    required this.name,
    required this.selectedAvatar,
    required this.selectedGrade,
    required List<String> avatars,
    required List<ProfileGradeOption> grades,
    required this.isSubmitting,
    required this.errorMessage,
  }) : avatars = UnmodifiableListView(List.of(avatars)),
       grades = UnmodifiableListView(List.of(grades));

  factory CreateProfileState.initial() => CreateProfileState(
    name: '',
    selectedAvatar: '👦',
    selectedGrade: 'Grade 2',
    avatars: defaultAvatars,
    grades: defaultGrades,
    isSubmitting: false,
    errorMessage: null,
  );

  CreateProfileState copyWith({
    String? name,
    String? selectedAvatar,
    String? selectedGrade,
    bool? isSubmitting,
    Object? errorMessage = _unset,
  }) {
    return CreateProfileState(
      name: name ?? this.name,
      selectedAvatar: selectedAvatar ?? this.selectedAvatar,
      selectedGrade: selectedGrade ?? this.selectedGrade,
      avatars: avatars,
      grades: grades,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const _unset = Object();
