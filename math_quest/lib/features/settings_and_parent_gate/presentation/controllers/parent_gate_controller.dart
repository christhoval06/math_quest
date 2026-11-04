import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_state.dart';

class ParentGateController extends StateNotifier<ParentGateState> {
  ParentGateController(ParentGateChallenge challenge)
    : super(ParentGateState(challenge: challenge));

  void setAnswer(String answer) {
    if (state.isVerified) return;
    state = state.copyWith(answer: answer, errorMessage: null);
  }

  bool verify() {
    if (state.isVerified) return false;

    final answer = state.answer.trim();
    if (answer.isEmpty) {
      state = state.copyWith(errorMessage: 'Enter an answer to continue.');
      return false;
    }
    if (int.tryParse(answer) == null) {
      state = state.copyWith(errorMessage: 'Use numbers only.');
      return false;
    }
    if (!state.challenge.accepts(answer)) {
      state = state.copyWith(errorMessage: 'Not quite. Please try again.');
      return false;
    }

    state = state.copyWith(errorMessage: null, isVerified: true);
    return true;
  }
}
