import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/parent_diagnostic_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/profile_provider.dart';

final parentDiagnosticProfileSourceProvider =
    Provider.autoDispose<UserProfile?>(
      (ref) => ref.watch(profileNotifierProvider),
    );

final parentDiagnosticClockProvider = Provider.autoDispose<DateTime Function()>(
  (ref) => DateTime.now,
);

final parentDiagnosticDateProvider = Provider.autoDispose<DateTime>(
  (ref) => ref.watch(parentDiagnosticClockProvider)(),
);

final parentDiagnosticProvider = Provider.autoDispose<ParentDiagnosticState>((
  ref,
) {
  return ParentDiagnosticState.fromProfile(
    profile: ref.watch(parentDiagnosticProfileSourceProvider),
    reportDate: ref.watch(parentDiagnosticDateProvider),
  );
});
