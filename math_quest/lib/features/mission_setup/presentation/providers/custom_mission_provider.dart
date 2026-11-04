import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/math_engine/domain/entities/difficulty_level.dart';
import 'package:math_quest/features/math_engine/domain/entities/math_operation.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_notifier.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';

class CustomMissionState {
  final Set<MathOperation> selectedOperations;
  final bool isExamMode;
  final DifficultyLevel selectedDifficulty;
  final int selectedTimerSeconds;
  final int selectedQuestionCount;
  final bool visualAidsEnabled;
  final bool soundEnabled;
  final int starCoins;
  final int streakDays;

  CustomMissionState({
    Set<MathOperation> selectedOperations = const {MathOperation.addition},
    this.isExamMode = false,
    this.selectedDifficulty = DifficultyLevel.medium,
    this.selectedTimerSeconds = 60,
    this.selectedQuestionCount = 10,
    this.visualAidsEnabled = true,
    this.soundEnabled = true,
    this.starCoins = 340,
    this.streakDays = 5,
  }) : selectedOperations = Set.unmodifiable(selectedOperations);

  String get launchButtonLabel => isExamMode
      ? 'Start Exam ($selectedQuestionCount Questions)'
      : 'Launch Mission! ($selectedQuestionCount Questions)';

  CustomMissionState copyWith({
    Set<MathOperation>? selectedOperations,
    bool? isExamMode,
    DifficultyLevel? selectedDifficulty,
    int? selectedTimerSeconds,
    int? selectedQuestionCount,
    bool? visualAidsEnabled,
    bool? soundEnabled,
    int? starCoins,
    int? streakDays,
  }) {
    return CustomMissionState(
      selectedOperations: selectedOperations ?? this.selectedOperations,
      isExamMode: isExamMode ?? this.isExamMode,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
      selectedTimerSeconds: selectedTimerSeconds ?? this.selectedTimerSeconds,
      selectedQuestionCount:
          selectedQuestionCount ?? this.selectedQuestionCount,
      visualAidsEnabled: visualAidsEnabled ?? this.visualAidsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      starCoins: starCoins ?? this.starCoins,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}

class PreparedCustomMission {
  final List<MathOperation> allowedOperations;
  final DifficultyLevel difficulty;
  final int timerSeconds;
  final bool isExamMode;
  final int totalQuestions;
  final bool visualAidsEnabled;
  final bool soundEnabled;

  PreparedCustomMission({
    required List<MathOperation> allowedOperations,
    required this.difficulty,
    required this.timerSeconds,
    required this.isExamMode,
    required this.totalQuestions,
    required this.visualAidsEnabled,
    required this.soundEnabled,
  }) : allowedOperations = List.unmodifiable(allowedOperations);
}

class CustomMissionController {
  final CustomMissionState Function() readState;
  final void Function(CustomMissionState) writeState;
  final void Function({
    required MathOperation operation,
    required DifficultyLevel difficulty,
    required bool visualAidsEnabled,
  })
  prepareSessionAction;

  CustomMissionController({
    required this.readState,
    required this.writeState,
    required this.prepareSessionAction,
  });

  void setExamMode(bool enabled) {
    writeState(
      readState().copyWith(isExamMode: enabled, visualAidsEnabled: !enabled),
    );
  }

  void toggleOperation(MathOperation operation) {
    final state = readState();
    final operations = Set<MathOperation>.from(state.selectedOperations);
    if (operations.contains(operation)) {
      if (operations.length == 1) return;
      operations.remove(operation);
    } else {
      operations.add(operation);
    }
    writeState(state.copyWith(selectedOperations: operations));
  }

  void selectDifficulty(DifficultyLevel difficulty) {
    writeState(readState().copyWith(selectedDifficulty: difficulty));
  }

  void selectTimer(int seconds) {
    if (!const {0, 30, 60, 120}.contains(seconds)) {
      throw ArgumentError.value(seconds, 'seconds', 'Unsupported timer');
    }
    writeState(readState().copyWith(selectedTimerSeconds: seconds));
  }

  void setVisualAidsEnabled(bool enabled) {
    final state = readState();
    if (state.isExamMode && enabled) return;
    writeState(state.copyWith(visualAidsEnabled: enabled));
  }

  void setSoundEnabled(bool enabled) {
    writeState(readState().copyWith(soundEnabled: enabled));
  }

  void selectQuestionCount(int count) {
    if (count < 10 || count > 50 || count % 5 != 0) {
      throw ArgumentError.value(count, 'count', 'Unsupported question count');
    }
    writeState(readState().copyWith(selectedQuestionCount: count));
  }

  PreparedCustomMission prepareMission() {
    final state = readState();
    final operations = state.selectedOperations.toList(growable: false);
    prepareSessionAction(
      operation: operations.first,
      difficulty: state.selectedDifficulty,
      visualAidsEnabled: state.visualAidsEnabled,
    );
    return PreparedCustomMission(
      allowedOperations: operations,
      difficulty: state.selectedDifficulty,
      timerSeconds: state.selectedTimerSeconds,
      isExamMode: state.isExamMode,
      totalQuestions: state.selectedQuestionCount,
      visualAidsEnabled: state.visualAidsEnabled,
      soundEnabled: state.soundEnabled,
    );
  }
}

class _CustomMissionFormNotifier extends StateNotifier<CustomMissionState> {
  _CustomMissionFormNotifier() : super(CustomMissionState());

  void replace(CustomMissionState next) => state = next;
}

final _customMissionFormProvider =
    StateNotifierProvider<_CustomMissionFormNotifier, CustomMissionState>((
      ref,
    ) {
      return _CustomMissionFormNotifier();
    });

final customMissionProvider = Provider<CustomMissionState>((ref) {
  final form = ref.watch(_customMissionFormProvider);
  final profile = ref.watch(profileNotifierProvider);
  return form.copyWith(
    starCoins: profile?.starCoins ?? 340,
    streakDays: profile?.currentStreak ?? 5,
  );
});

final customMissionControllerProvider = Provider<CustomMissionController>((
  ref,
) {
  final notifier = ref.watch(_customMissionFormProvider.notifier);
  return CustomMissionController(
    readState: () => ref.read(_customMissionFormProvider),
    writeState: notifier.replace,
    prepareSessionAction:
        ({
          required operation,
          required difficulty,
          required visualAidsEnabled,
        }) {
          final session = ref.read(practiceSessionProvider.notifier);
          session.resetSession(operation: operation, difficulty: difficulty);
          session.setVisualAidsEnabled(visualAidsEnabled);
        },
  );
});
