import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:math_quest/core/widgets/responsive_container.dart';
import 'package:math_quest/features/profile_and_stats/presentation/providers/parent_diagnostic_provider.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/parent_diagnostic_widgets.dart';

class ParentDiagnosticScreen extends ConsumerWidget {
  const ParentDiagnosticScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parentDiagnosticProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: ParentDiagnosticAppBar(onBack: () => Navigator.pop(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveContainer(
            child: ParentDiagnosticReport(state: state),
          ),
        ),
      ),
    );
  }
}
