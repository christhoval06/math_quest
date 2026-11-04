import 'package:flutter/material.dart';
import 'package:math_quest/features/profile_and_stats/presentation/models/all_badges_state.dart';
import 'package:math_quest/features/profile_and_stats/presentation/widgets/all_badges_widgets.dart';

Future<void> showBadgeDetailBottomSheet(
  BuildContext context,
  BadgeViewData badge,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    constraints: const BoxConstraints(maxWidth: 600),
    builder: (sheetContext) => ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.85,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          24 + MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: BadgeDetailContent(
          badge: badge,
          onClose: () => Navigator.pop(sheetContext),
        ),
      ),
    ),
  );
}
