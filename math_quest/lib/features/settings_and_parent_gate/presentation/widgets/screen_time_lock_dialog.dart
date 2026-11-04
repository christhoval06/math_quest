import 'package:flutter/material.dart';
import 'package:math_quest/core/theme/app_theme.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class ScreenTimeLockDialog extends StatefulWidget {
  final Future<void> Function() onParentUnlock;

  const ScreenTimeLockDialog({super.key, required this.onParentUnlock});

  static void show(
    BuildContext context,
    Future<void> Function() onParentUnlock,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ScreenTimeLockDialog(onParentUnlock: onParentUnlock),
    );
  }

  @override
  State<ScreenTimeLockDialog> createState() => _ScreenTimeLockDialogState();
}

class _ScreenTimeLockDialogState extends State<ScreenTimeLockDialog> {
  bool _isUnlocking = false;

  Future<void> _unlock() async {
    if (_isUnlocking) return;
    setState(() => _isUnlocking = true);
    try {
      await widget.onParentUnlock();
    } finally {
      if (mounted) setState(() => _isUnlocking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('😴', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.timeForRest,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.restDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: _isUnlocking ? null : _unlock,
              icon: const Icon(
                Icons.lock_open_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                AppLocalizations.of(context)!.parentUnlock,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
