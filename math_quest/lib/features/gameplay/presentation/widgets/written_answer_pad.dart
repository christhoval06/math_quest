import 'dart:async';

import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/l10n/app_localizations.dart';

enum WrittenAnswerFeedback { neutral, correct, incorrect }

class WrittenAnswerPad extends StatefulWidget {
  final int digitCount;
  final bool enabled;
  final Color accentColor;
  final WrittenAnswerFeedback feedback;
  final bool compact;
  final bool showDeleteButton;
  final bool showCheckButton;
  final bool showCheckingStatus;
  final VoidCallback? onInputFeedback;
  final Future<void> Function(int answer) onSubmit;

  const WrittenAnswerPad({
    super.key,
    required this.digitCount,
    this.enabled = true,
    required this.accentColor,
    this.feedback = WrittenAnswerFeedback.neutral,
    this.compact = false,
    this.showDeleteButton = false,
    this.showCheckButton = false,
    this.showCheckingStatus = false,
    this.onInputFeedback,
    required this.onSubmit,
  }) : assert(digitCount > 0);

  @override
  State<WrittenAnswerPad> createState() => _WrittenAnswerPadState();
}

class _WrittenAnswerPadState extends State<WrittenAnswerPad> {
  static const _autoCheckDelay = Duration(milliseconds: 450);
  static const _checkingStatusDelay = Duration(milliseconds: 250);

  String _digits = '';
  bool _hasSubmitted = false;
  bool _isSubmitting = false;
  bool _isCheckingStatusVisible = false;
  bool _submissionFailed = false;
  Timer? _autoSubmitTimer;
  Timer? _checkingStatusTimer;

  bool get _canEdit => widget.enabled && !_hasSubmitted;
  bool get _canSubmit => _canEdit && _digits.length == widget.digitCount;
  bool get _shouldShowCheckingStatus =>
      widget.showCheckingStatus && _isSubmitting && _isCheckingStatusVisible;

  void _addDigit(int digit) {
    if (!_canEdit || _digits.length >= widget.digitCount) return;
    setState(() {
      _digits += '$digit';
      _submissionFailed = false;
    });
    widget.onInputFeedback?.call();
    if (_digits.length == widget.digitCount) {
      _scheduleAutoSubmit();
    }
  }

  void _deleteDigit() {
    if (!_canEdit || _digits.isEmpty) return;
    _cancelAutoSubmit();
    setState(() {
      _digits = _digits.substring(0, _digits.length - 1);
      _submissionFailed = false;
    });
    widget.onInputFeedback?.call();
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    _cancelAutoSubmit();
    setState(() {
      _hasSubmitted = true;
      _isSubmitting = true;
      _isCheckingStatusVisible = false;
      _submissionFailed = false;
    });
    _scheduleCheckingStatus();
    try {
      await widget.onSubmit(int.parse(_digits));
    } catch (_) {
      _cancelCheckingStatus();
      if (mounted) {
        setState(() {
          _hasSubmitted = false;
          _isSubmitting = false;
          _isCheckingStatusVisible = false;
          _submissionFailed = true;
        });
      }
      return;
    }
    _cancelCheckingStatus();
    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _isCheckingStatusVisible = false;
      });
    }
  }

  void _scheduleCheckingStatus() {
    _cancelCheckingStatus();
    if (!widget.showCheckingStatus) return;
    _checkingStatusTimer = Timer(_checkingStatusDelay, () {
      _checkingStatusTimer = null;
      if (!mounted || !_isSubmitting || !widget.showCheckingStatus) return;
      setState(() => _isCheckingStatusVisible = true);
    });
  }

  void _cancelCheckingStatus() {
    _checkingStatusTimer?.cancel();
    _checkingStatusTimer = null;
  }

  void _scheduleAutoSubmit() {
    _cancelAutoSubmit();
    _autoSubmitTimer = Timer(_autoCheckDelay, () {
      _autoSubmitTimer = null;
      unawaited(_submit());
    });
  }

  void _cancelAutoSubmit() {
    _autoSubmitTimer?.cancel();
    _autoSubmitTimer = null;
  }

  @override
  void didUpdateWidget(covariant WrittenAnswerPad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled || widget.digitCount != oldWidget.digitCount) {
      _cancelAutoSubmit();
    }
    if (widget.enabled &&
        !oldWidget.enabled &&
        widget.digitCount == oldWidget.digitCount &&
        _canSubmit &&
        !_submissionFailed) {
      _scheduleAutoSubmit();
    }
    if (!widget.showCheckingStatus && oldWidget.showCheckingStatus) {
      _cancelCheckingStatus();
      _isCheckingStatusVisible = false;
    } else if (widget.showCheckingStatus &&
        !oldWidget.showCheckingStatus &&
        _isSubmitting) {
      _scheduleCheckingStatus();
    }
  }

  @override
  void dispose() {
    _cancelAutoSubmit();
    _cancelCheckingStatus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final feedbackColor = switch (widget.feedback) {
      WrittenAnswerFeedback.correct => AppColors.successGreen,
      WrittenAnswerFeedback.incorrect => AppColors.errorRed,
      WrittenAnswerFeedback.neutral => widget.accentColor,
    };
    final feedbackLabel = switch (widget.feedback) {
      WrittenAnswerFeedback.correct => AppLocalizations.of(
        context,
      )!.correctAnswerSemantics,
      WrittenAnswerFeedback.incorrect => AppLocalizations.of(
        context,
      )!.incorrectAnswerSemantics,
      WrittenAnswerFeedback.neutral => AppLocalizations.of(
        context,
      )!.writtenAnswerSemantics,
    };

    return Semantics(
      label: feedbackLabel,
      liveRegion: widget.feedback != WrittenAnswerFeedback.neutral,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            key: const Key('written-answer-panel'),
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 10 : 16,
              vertical: widget.compact ? 8 : 12,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(widget.compact ? 16 : 22),
              border: Border.all(
                color: widget.feedback == WrittenAnswerFeedback.neutral
                    ? widget.accentColor.withValues(alpha: 0.2)
                    : feedbackColor.withValues(alpha: 0.45),
                width: 1.25,
              ),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: List.generate(widget.digitCount, (index) {
                final digit = index < _digits.length ? _digits[index] : '';
                final hasDigit = digit.isNotEmpty;
                final hasResult =
                    widget.feedback != WrittenAnswerFeedback.neutral;
                final slotColor = hasResult
                    ? feedbackColor.withValues(alpha: 0.12)
                    : hasDigit
                    ? widget.accentColor.withValues(alpha: 0.12)
                    : colorScheme.surfaceContainerHighest;
                final borderColor = hasResult
                    ? feedbackColor
                    : hasDigit
                    ? widget.accentColor
                    : colorScheme.outlineVariant;
                return AnimatedContainer(
                  key: Key('written-slot-$index'),
                  duration: const Duration(milliseconds: 160),
                  width: widget.compact ? 38 : 50,
                  height: widget.compact ? 40 : 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: slotColor,
                    borderRadius: BorderRadius.circular(
                      widget.compact ? 11 : 14,
                    ),
                    border: Border.all(
                      color: borderColor,
                      width: hasDigit || hasResult ? 2 : 1.25,
                    ),
                  ),
                  child: Text(
                    digit,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: widget.compact ? 20 : 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: widget.compact ? 6 : 10),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: widget.compact ? 310 : 320),
            child: Container(
              key: const Key('written-keypad-panel'),
              padding: EdgeInsets.all(widget.compact ? 7 : 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(widget.compact ? 16 : 22),
                border: Border.all(color: colorScheme.outlineVariant, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: widget.compact ? 12 : 20,
                    offset: Offset(0, widget.compact ? 4 : 8),
                  ),
                ],
              ),
              child: widget.compact
                  ? _buildCompactKeypad(colorScheme, feedbackColor)
                  : _buildStandardKeypad(colorScheme, feedbackColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardKeypad(ColorScheme colorScheme, Color feedbackColor) {
    final canAddDigit = _canEdit && _digits.length < widget.digitCount;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2,
          children: [
            for (var digit = 1; digit <= 9; digit++)
              _DigitButton(
                digit: digit,
                enabled: canAddDigit,
                accentColor: widget.accentColor,
                onPressed: _addDigit,
              ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: widget.showDeleteButton
              ? Row(
                  children: [
                    Expanded(child: _buildDeleteButton(colorScheme)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildZeroButton(canAddDigit)),
                  ],
                )
              : _buildZeroButton(canAddDigit),
        ),
        if (widget.showCheckButton) ...[
          const SizedBox(height: 10),
          _buildStandardConfirm(colorScheme, feedbackColor),
        ] else if (_shouldShowCheckingStatus || _submissionFailed) ...[
          const SizedBox(height: 10),
          _buildDetachedStatus(colorScheme, feedbackColor),
        ],
      ],
    );
  }

  Widget _buildZeroButton(bool enabled) => _DigitButton(
    digit: 0,
    enabled: enabled,
    accentColor: widget.accentColor,
    onPressed: _addDigit,
  );

  Widget _buildStandardConfirm(ColorScheme colorScheme, Color feedbackColor) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Semantics(
        label: _submissionFailed
            ? AppLocalizations.of(context)!.retryAnswerSemantics
            : null,
        button: _submissionFailed,
        child: FilledButton(
          key: const Key('written-confirm'),
          onPressed: _canSubmit ? _submit : null,
          style: _confirmStyle(colorScheme, feedbackColor),
          child: _shouldShowCheckingStatus
              ? _CheckingContent(
                  showLabel: true,
                  color: _foregroundFor(feedbackColor),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _submissionFailed
                          ? Icons.refresh_rounded
                          : Icons.check_circle_rounded,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _submissionFailed
                          ? AppLocalizations.of(context)!.tryAgain
                          : AppLocalizations.of(context)!.checkWrittenAnswer,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCompactKeypad(ColorScheme colorScheme, Color feedbackColor) {
    final canAddDigit = _canEdit && _digits.length < widget.digitCount;
    final usesSimplifiedGrid =
        !widget.showDeleteButton && !widget.showCheckButton;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.count(
          crossAxisCount: usesSimplifiedGrid ? 5 : 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          mainAxisExtent: 44,
          children: [
            for (var digit = 1; digit <= 9; digit++)
              _DigitButton(
                digit: digit,
                enabled: canAddDigit,
                accentColor: widget.accentColor,
                onPressed: _addDigit,
              ),
            if (widget.showDeleteButton) _buildDeleteButton(colorScheme),
            _buildZeroButton(canAddDigit),
            if (widget.showCheckButton)
              _buildCompactConfirm(colorScheme, feedbackColor),
          ],
        ),
        if (!widget.showCheckButton &&
            (_shouldShowCheckingStatus || _submissionFailed)) ...[
          const SizedBox(height: 8),
          _buildDetachedStatus(colorScheme, feedbackColor),
        ],
      ],
    );
  }

  Widget _buildCompactConfirm(ColorScheme colorScheme, Color feedbackColor) {
    return Semantics(
      label: _submissionFailed
          ? AppLocalizations.of(context)!.retryAnswerSemantics
          : null,
      button: _submissionFailed,
      child: IconButton.filled(
        key: const Key('written-confirm'),
        tooltip: _submissionFailed
            ? AppLocalizations.of(context)!.tryAgainTooltip
            : AppLocalizations.of(context)!.checkAnswerTooltip,
        onPressed: _canSubmit ? _submit : null,
        style: IconButton.styleFrom(
          backgroundColor: feedbackColor,
          foregroundColor: _foregroundFor(feedbackColor),
          disabledBackgroundColor: _isSubmitting
              ? feedbackColor
              : colorScheme.surfaceContainerHighest,
          disabledForegroundColor: _isSubmitting
              ? _foregroundFor(feedbackColor)
              : colorScheme.onSurface.withValues(alpha: 0.38),
          side: BorderSide(
            color: _canSubmit ? feedbackColor : colorScheme.outlineVariant,
          ),
        ),
        icon: _shouldShowCheckingStatus
            ? _CheckingContent(
                showLabel: false,
                color: _foregroundFor(feedbackColor),
              )
            : Icon(
                _submissionFailed ? Icons.refresh_rounded : Icons.check_rounded,
              ),
      ),
    );
  }

  Widget _buildDetachedStatus(ColorScheme colorScheme, Color feedbackColor) {
    if (_submissionFailed) {
      return SizedBox(
        width: double.infinity,
        height: widget.compact ? 44 : 52,
        child: Semantics(
          container: true,
          excludeSemantics: true,
          label: AppLocalizations.of(context)!.retryAnswerSemantics,
          button: true,
          enabled: _canSubmit,
          onTap: _canSubmit ? _submit : null,
          child: FilledButton.icon(
            key: const Key('written-confirm'),
            onPressed: _canSubmit ? _submit : null,
            style: _confirmStyle(colorScheme, feedbackColor),
            icon: const Icon(Icons.refresh_rounded),
            label: Text(AppLocalizations.of(context)!.tryAgain),
          ),
        ),
      );
    }

    final foreground = _foregroundFor(feedbackColor);
    return Container(
      key: const Key('written-checking-status'),
      width: double.infinity,
      height: widget.compact ? 44 : 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: feedbackColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _CheckingContent(showLabel: true, color: foreground),
    );
  }

  Widget _buildDeleteButton(ColorScheme colorScheme) {
    return IconButton.filledTonal(
      key: const Key('written-delete'),
      tooltip: AppLocalizations.of(context)!.deleteDigit,
      onPressed: _canEdit && _digits.isNotEmpty ? _deleteDigit : null,
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHigh,
        foregroundColor: colorScheme.onSurfaceVariant,
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
        disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: const Icon(Icons.backspace_rounded),
    );
  }

  ButtonStyle _confirmStyle(ColorScheme colorScheme, Color feedbackColor) {
    return FilledButton.styleFrom(
      backgroundColor: feedbackColor,
      foregroundColor: _foregroundFor(feedbackColor),
      disabledBackgroundColor: _isSubmitting
          ? feedbackColor
          : colorScheme.surfaceContainerHighest,
      disabledForegroundColor: _isSubmitting
          ? _foregroundFor(feedbackColor)
          : colorScheme.onSurface.withValues(alpha: 0.38),
      side: BorderSide(
        color: _canSubmit ? feedbackColor : colorScheme.outlineVariant,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
    );
  }

  Color _foregroundFor(Color background) {
    final blackContrast = (background.computeLuminance() + 0.05) / 0.05;
    final whiteContrast = 1.05 / (background.computeLuminance() + 0.05);
    return blackContrast >= whiteContrast ? Colors.black : Colors.white;
  }
}

class _DigitButton extends StatelessWidget {
  final int digit;
  final bool enabled;
  final Color accentColor;
  final ValueChanged<int> onPressed;

  const _DigitButton({
    required this.digit,
    required this.enabled,
    required this.accentColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final playfulBackground = Color.alphaBlend(
      accentColor.withValues(alpha: 0.18),
      colorScheme.surfaceContainerHighest,
    );
    return FilledButton.tonal(
      key: Key('written-digit-$digit'),
      onPressed: enabled ? () => onPressed(digit) : null,
      style: FilledButton.styleFrom(
        backgroundColor: playfulBackground,
        foregroundColor: colorScheme.onSurface,
        disabledBackgroundColor: colorScheme.surfaceContainerHighest,
        disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
        side: BorderSide(color: accentColor.withValues(alpha: 0.5), width: 1.5),
        elevation: 2,
        shadowColor: accentColor.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
      ),
      child: Text('$digit'),
    );
  }
}

class _CheckingContent extends StatelessWidget {
  final bool showLabel;
  final Color color;

  const _CheckingContent({required this.showLabel, required this.color});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: AppLocalizations.of(context)!.checkingAnswer,
      liveRegion: true,
      child: ExcludeSemantics(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: color),
            ),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.checkingStatus,
                style: TextStyle(color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
