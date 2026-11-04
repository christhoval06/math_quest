import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';

class ParentGateState {
  static const _unchanged = Object();

  final ParentGateChallenge challenge;
  final String answer;
  final String? errorMessage;
  final bool isVerified;

  const ParentGateState({
    required this.challenge,
    this.answer = '',
    this.errorMessage,
    this.isVerified = false,
  });

  ParentGateState copyWith({
    String? answer,
    Object? errorMessage = _unchanged,
    bool? isVerified,
  }) {
    return ParentGateState(
      challenge: challenge,
      answer: answer ?? this.answer,
      errorMessage: identical(errorMessage, _unchanged)
          ? this.errorMessage
          : errorMessage as String?,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
