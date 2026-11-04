import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_config.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_localizations.dart';
import 'package:math_quest/features/settings_and_parent_gate/presentation/models/parent_gate_state.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class ParentGateView extends StatelessWidget {
  final ParentGateConfig config;
  final ParentGateState state;
  final ValueChanged<String> onAnswerChanged;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const ParentGateView({
    super.key,
    required this.config,
    required this.state,
    required this.onAnswerChanged,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F8FF),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        tooltip: AppLocalizations.of(context)!.closeParentVerification,
        onPressed: onCancel,
        icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
      ),
    ),
    body: SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SecurityEmblem(),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.adultVerificationCaps,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    config.localizedTitle(AppLocalizations.of(context)!),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    config.localizedDescription(AppLocalizations.of(context)!),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 26),
                  _ChallengeCard(
                    state: state,
                    onAnswerChanged: onAnswerChanged,
                    onSubmitted: onSubmit,
                  ),
                  const SizedBox(height: 20),
                  Semantics(
                    button: true,
                    label: config.localizedAction(
                      AppLocalizations.of(context)!,
                    ),
                    child: ElevatedButton.icon(
                      key: const Key('parent-gate-submit'),
                      onPressed: state.isVerified ? null : onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDarkBlue,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.primaryDarkBlue
                            .withValues(alpha: 0.55),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.lock_open_rounded, size: 20),
                      label: Text(
                        config.localizedAction(AppLocalizations.of(context)!),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onCancel,
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 15,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.parentControlsProtected,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _SecurityEmblem extends StatelessWidget {
  const _SecurityEmblem();

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.primaryDarkBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.shield_rounded, color: Colors.white, size: 46),
    ),
  );
}

class _ChallengeCard extends StatelessWidget {
  final ParentGateState state;
  final ValueChanged<String> onAnswerChanged;
  final VoidCallback onSubmitted;

  const _ChallengeCard({
    required this.state,
    required this.onAnswerChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: const Color(0xFFDCE6F5)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.06),
          blurRadius: 22,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          AppLocalizations.of(context)!.adultVerification,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppLocalizations.of(context)!.parentVerificationPrompt(
            AppLocalizations.of(context)!
                .gateNumberWord('n${state.challenge.firstFactor}'),
            AppLocalizations.of(context)!
                .gateNumberWord('n${state.challenge.secondFactor}'),
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 18),
        Semantics(
          label: AppLocalizations.of(context)!.parentAnswerSemantics,
          textField: true,
          child: TextFormField(
            key: const Key('parent-gate-answer'),
            initialValue: state.answer,
            enabled: !state.isVerified,
            autofocus: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            onChanged: onAnswerChanged,
            onFieldSubmitted: (_) => onSubmitted(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.answer,
              errorText: localizedParentGateError(
                AppLocalizations.of(context)!,
                state.errorMessage,
              ),
              errorMaxLines: 2,
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primaryBlue,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.errorRed,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.errorRed,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
