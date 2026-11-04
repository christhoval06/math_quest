import 'dart:collection';

import 'package:math_quest/features/profile_and_stats/domain/entities/mastery_track.dart';
import 'package:math_quest/features/profile_and_stats/domain/entities/user_profile.dart';

enum DiagnosticOperationStatus { pending, needsPractice, onTrack, mastered }

class OperationDiagnosticViewData {
  final String title;
  final int totalSolved;
  final int accuracyPercent;
  final DiagnosticOperationStatus status;

  const OperationDiagnosticViewData({
    required this.title,
    required this.totalSolved,
    required this.accuracyPercent,
    required this.status,
  });

  String get accuracyLabel =>
      totalSolved == 0 ? 'No rounds completed' : '$accuracyPercent% Accuracy';
  String get questionsLabel => '$totalSolved questions answered';

  String get statusLabel => switch (status) {
    DiagnosticOperationStatus.pending => 'Pending Assessment',
    DiagnosticOperationStatus.needsPractice => 'Needs Practice 🎯',
    DiagnosticOperationStatus.onTrack => 'On Track ⚡',
    DiagnosticOperationStatus.mastered => 'Mastered ✅',
  };
}

class ParentDiagnosticState {
  final String name;
  final String grade;
  final String avatar;
  final DateTime? reportDate;
  final bool usesGeneratedCopy;
  final String reportDateLabel;
  final int totalSolved;
  final double overallAccuracy;
  final double readinessProgress;
  final String readinessLabel;
  final String readinessSummary;
  final List<OperationDiagnosticViewData> operations;

  ParentDiagnosticState({
    this.reportDate,
    this.usesGeneratedCopy = false,
    required this.name,
    required this.grade,
    required this.avatar,
    required this.reportDateLabel,
    required this.totalSolved,
    required this.overallAccuracy,
    required this.readinessProgress,
    required this.readinessLabel,
    required this.readinessSummary,
    required List<OperationDiagnosticViewData> operations,
  }) : operations = UnmodifiableListView(List.of(operations));

  OperationDiagnosticViewData? get strongestOperation {
    final active = operations
        .where((op) => op.totalSolved > 0 && op.accuracyPercent >= 70)
        .toList();
    active.sort((a, b) => b.accuracyPercent.compareTo(a.accuracyPercent));
    return active.isEmpty ? null : active.first;
  }

  OperationDiagnosticViewData? get focusOperation {
    final active = operations
        .where((op) => op.totalSolved > 0 && op.accuracyPercent < 90)
        .toList();
    active.sort((a, b) => a.accuracyPercent.compareTo(b.accuracyPercent));
    if (active.isNotEmpty) return active.first;
    for (final operation in operations) {
      if (operation.totalSolved == 0) return operation;
    }
    return null;
  }

  factory ParentDiagnosticState.fromProfile({
    required UserProfile? profile,
    required DateTime reportDate,
  }) {
    final name = profile?.name ?? 'Leo';
    final tracks = profile?.masteryTracks.values ?? const <MasteryTrack>[];
    final operations = tracks.map(_mapTrack).toList(growable: false);
    final totalSolved = operations.fold<int>(
      0,
      (sum, operation) => sum + operation.totalSolved,
    );
    final activeTracks = operations
        .where((operation) => operation.totalSolved > 0)
        .toList(growable: false);
    final overallAccuracy = activeTracks.isEmpty
        ? 0.0
        : activeTracks.fold<double>(
                0,
                (sum, operation) => sum + operation.accuracyPercent / 100,
              ) /
              activeTracks.length;

    return ParentDiagnosticState(
      reportDate: reportDate,
      usesGeneratedCopy: true,
      name: name,
      grade: profile?.gradeLabel ?? 'Grade 2',
      avatar: profile?.avatar ?? '👦',
      reportDateLabel:
          '${reportDate.month}/${reportDate.day}/${reportDate.year}',
      totalSolved: totalSolved,
      overallAccuracy: overallAccuracy,
      readinessProgress: totalSolved > 0 ? overallAccuracy : 0.1,
      readinessLabel: totalSolved > 0
          ? '${(overallAccuracy * 100).toInt()}% Mastery'
          : 'Baseline Gathering',
      readinessSummary: totalSolved > 50
          ? '$name demonstrates strong foundational number sense and is on track for advanced standards.'
          : '$name has begun building foundational skills. Consistent daily 10-minute sessions are recommended.',
      operations: operations,
    );
  }

  static OperationDiagnosticViewData _mapTrack(MasteryTrack track) {
    final totalSolved = track.totalSolved < 0 ? 0 : track.totalSolved;
    final normalizedAccuracy = track.accuracy.isFinite
        ? track.accuracy.clamp(0.0, 1.0).toDouble()
        : 0.0;
    final accuracyPercent = (normalizedAccuracy * 100).toInt();
    final status = totalSolved == 0
        ? DiagnosticOperationStatus.pending
        : accuracyPercent >= 90
        ? DiagnosticOperationStatus.mastered
        : accuracyPercent >= 70
        ? DiagnosticOperationStatus.onTrack
        : DiagnosticOperationStatus.needsPractice;

    return OperationDiagnosticViewData(
      title: switch (track.operation) {
        MathOperationType.addition => 'ADDITION',
        MathOperationType.subtraction => 'SUBTRACTION',
        MathOperationType.multiplication => 'MULTIPLICATION',
        MathOperationType.division => 'DIVISION',
      },
      totalSolved: totalSolved,
      accuracyPercent: accuracyPercent,
      status: status,
    );
  }
}
