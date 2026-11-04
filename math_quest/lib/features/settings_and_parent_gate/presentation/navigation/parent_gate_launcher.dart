import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/settings_and_parent_gate/domain/entities/parent_gate_challenge.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_config.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/screens/parent_gate_screen.dart';

abstract final class ParentGateLauncher {
  static final Expando<bool> _requestInProgress = Expando<bool>();

  static Future<bool> requestAccess(
    BuildContext context, {
    required ParentGateChallenge challenge,
    required ParentGateConfig config,
  }) async {
    final navigator = Navigator.of(context);
    if (_requestInProgress[navigator] ?? false) return false;

    _requestInProgress[navigator] = true;
    try {
      final result = await navigator.push<bool>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => ProviderScope(
            child: ParentGateScreen(challenge: challenge, config: config),
          ),
        ),
      );
      return result ?? false;
    } finally {
      _requestInProgress[navigator] = false;
    }
  }
}
