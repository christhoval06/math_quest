import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_config.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/providers/parent_gate_provider.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/widgets/parent_gate_widgets.dart';

class ParentGateScreen extends ConsumerWidget {
  final ParentGateChallenge challenge;
  final ParentGateConfig config;

  const ParentGateScreen({
    super.key,
    required this.challenge,
    required this.config,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parentGateProvider(challenge));
    final controller = ref.read(parentGateProvider(challenge).notifier);

    return ParentGateView(
      config: config,
      state: state,
      onAnswerChanged: controller.setAnswer,
      onSubmit: () {
        if (controller.verify() && context.mounted) {
          Navigator.pop(context, true);
        }
      },
      onCancel: () => Navigator.pop(context, false),
    );
  }
}
