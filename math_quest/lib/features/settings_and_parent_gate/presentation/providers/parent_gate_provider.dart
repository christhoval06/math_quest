import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/controllers/parent_gate_controller.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_state.dart';

final parentGateProvider = StateNotifierProvider.autoDispose
    .family<ParentGateController, ParentGateState, ParentGateChallenge>(
      (ref, challenge) => ParentGateController(challenge),
    );
