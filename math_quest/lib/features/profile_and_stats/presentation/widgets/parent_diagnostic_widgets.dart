import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/parent_diagnostic_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/profile_localizations.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/stats_localizations.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class ParentDiagnosticAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;

  const ParentDiagnosticAppBar({super.key, required this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.textPrimary,
        size: 20,
      ),
      onPressed: onBack,
    ),
    title: Text(
      AppLocalizations.of(context)!.parentDiagnosticTitle,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        fontSize: 18,
      ),
    ),
  );
}

class ParentDiagnosticReport extends StatelessWidget {
  final ParentDiagnosticState state;

  const ParentDiagnosticReport({super.key, required this.state});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 16),
      _StudentSummary(state: state),
      const SizedBox(height: 16),
      _ReadinessCard(state: state),
      const SizedBox(height: 24),
      Text(
        AppLocalizations.of(context)!.curriculumBreakdown,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
        ),
      ),
      const SizedBox(height: 12),
      if (state.operations.isEmpty)
        const _EmptyOperations()
      else
        for (final operation in state.operations) ...[
          _OperationDiagnosticTile(operation: operation),
          const SizedBox(height: 10),
        ],
      const SizedBox(height: 20),
      _ObservationsCard(state: state),
      const SizedBox(height: 36),
    ],
  );
}

class _StudentSummary extends StatelessWidget {
  final ParentDiagnosticState state;

  const _StudentSummary({required this.state});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.borderLight),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: const Color(0xFFE0F2FE),
          child: Text(state.avatar, style: const TextStyle(fontSize: 32)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  AppLocalizations.of(context)!.activeStudent,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.successGreen,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.gradeAligned(
                  localizedProfileGrade(
                    AppLocalizations.of(context)!,
                    state.grade,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.reportDate(
                  state.localizedDate(AppLocalizations.of(context)!),
                ),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ReadinessCard extends StatelessWidget {
  final ParentDiagnosticState state;

  const _ReadinessCard({required this.state});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFBFDBFE)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Text(
              AppLocalizations.of(context)!.readinessIndex,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDarkBlue,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              state.localizedReadiness(AppLocalizations.of(context)!),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDarkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: state.readinessProgress,
            minHeight: 12,
            backgroundColor: Colors.white.withValues(alpha: 0.6),
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          state.localizedSummary(AppLocalizations.of(context)!),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A8A),
            height: 1.35,
          ),
        ),
      ],
    ),
  );
}

class _EmptyOperations extends StatelessWidget {
  const _EmptyOperations();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.borderLight),
    ),
    child: Text(
      AppLocalizations.of(context)!.noOperationData,
      style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600),
    ),
  );
}

class _OperationDiagnosticTile extends StatelessWidget {
  final OperationDiagnosticViewData operation;

  const _OperationDiagnosticTile({required this.operation});

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle(operation.status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Text(
                localizedStatsOperation(
                  AppLocalizations.of(context)!,
                  operation.title,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: style.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  operation.localizedStatus(AppLocalizations.of(context)!),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: style.foreground,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                operation.totalSolved == 0
                    ? AppLocalizations.of(context)!.noRoundsCompleted
                    : AppLocalizations.of(context)!
                          .accuracyPercent(operation.accuracyPercent),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: operation.totalSolved > 0
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
              ),
              const Text('•', style: TextStyle(color: AppColors.textMuted)),
              Text(
                AppLocalizations.of(context)!
                    .questionsAnswered(operation.totalSolved),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ObservationsCard extends StatelessWidget {
  final ParentDiagnosticState state;
  const _ObservationsCard({required this.state});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppColors.borderLight),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.psychology_rounded,
              color: AppColors.secondaryOrange,
              size: 22,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.stellaObservations,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _ObservationPoint(
          title: AppLocalizations.of(context)!.identifiedStrength,
          detail: state.localizedStrength(AppLocalizations.of(context)!),
          color: AppColors.successGreen,
        ),
        SizedBox(height: 8),
        _ObservationPoint(
          title: AppLocalizations.of(context)!.recommendedFocus,
          detail: state.localizedFocus(AppLocalizations.of(context)!),
          color: AppColors.secondaryOrange,
        ),
      ],
    ),
  );
}

class _ObservationPoint extends StatelessWidget {
  final String title;
  final String detail;
  final Color color;

  const _ObservationPoint({
    required this.title,
    required this.detail,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(top: 6, right: 10),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            children: [
              TextSpan(
                text: '$title ',
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              TextSpan(text: detail),
            ],
          ),
        ),
      ),
    ],
  );
}

({Color foreground, Color background}) _statusStyle(
  DiagnosticOperationStatus status,
) => switch (status) {
  DiagnosticOperationStatus.pending => (
    foreground: AppColors.textMuted,
    background: const Color(0xFFF1F5F9),
  ),
  DiagnosticOperationStatus.needsPractice => (
    foreground: const Color(0xFFB45309),
    background: const Color(0xFFFEF3C7),
  ),
  DiagnosticOperationStatus.onTrack => (
    foreground: const Color(0xFF0369A1),
    background: const Color(0xFFE0F2FE),
  ),
  DiagnosticOperationStatus.mastered => (
    foreground: const Color(0xFF15803D),
    background: const Color(0xFFDCFCE7),
  ),
};
