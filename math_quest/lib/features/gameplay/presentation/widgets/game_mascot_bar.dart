import 'package:flutter/material.dart';
import 'package:math_quest/l10n/app_localizations.dart';

class GameMascotBar extends StatelessWidget {
  const GameMascotBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text('⭐', style: TextStyle(fontSize: 22)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.sparkyAdvice,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8D6E63),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
