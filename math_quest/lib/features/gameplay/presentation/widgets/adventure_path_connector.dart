import 'package:flutter/material.dart';

class AdventurePathConnector extends StatelessWidget {
  const AdventurePathConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            key: Key('adventure-path-dot-$index'),
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(vertical: 2.5),
            decoration: const BoxDecoration(
              color: Color(0xFFCBD5E1),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
