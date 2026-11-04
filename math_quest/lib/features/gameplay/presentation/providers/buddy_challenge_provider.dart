import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_quest/core/haptics/haptic_provider.dart';
import 'package:math_quest/features/gameplay/presentation/controllers/buddy_challenge_controller.dart';
import 'package:math_quest/features/gameplay/presentation/models/buddy_challenge_state.dart';
import 'package:math_quest/features/math_engine/domain/usecases/generate_problem_usecase.dart';

final buddyChallengeStateProvider =
    StateNotifierProvider.autoDispose<
      BuddyChallengeController,
      BuddyChallengeState
    >((ref) {
      final generator = GenerateProblemUseCase();
      final random = Random();
      final haptics = ref.read(hapticServiceProvider);
      return BuddyChallengeController(
        problemFactory: ({required operation, required difficulty}) =>
            generator.execute(operation: operation, difficulty: difficulty),
        operationPicker: (operations) =>
            operations[random.nextInt(operations.length)],
        hapticSubmittedAction: () => unawaited(haptics.answerSubmitted()),
        hapticCorrectAction: () => unawaited(haptics.correctAnswer()),
        hapticIncorrectAction: () => unawaited(haptics.incorrectAnswer()),
      );
    });

final buddyChallengeProvider = Provider.autoDispose<BuddyChallengeState>((ref) {
  return ref.watch(buddyChallengeStateProvider);
});

final buddyChallengeControllerProvider =
    Provider.autoDispose<BuddyChallengeController>((ref) {
      return ref.watch(buddyChallengeStateProvider.notifier);
    });
