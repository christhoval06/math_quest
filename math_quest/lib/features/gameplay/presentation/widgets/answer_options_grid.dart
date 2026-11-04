import 'package:flutter/material.dart';

import 'package:math_quest/features/gameplay/presentation/widgets/option_card.dart';

class AnswerOptionsGrid extends StatelessWidget {
  final List<int> options;
  final int correctAnswer;
  final int? selectedAnswer;
  final bool isEvaluating;
  final bool isExamMode;
  final ValueChanged<int> onAnswer;

  const AnswerOptionsGrid({
    super.key,
    required this.options,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.isEvaluating,
    required this.isExamMode,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['A', 'B', 'C', 'D'];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.1,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return OptionCard(
          label: labels[index],
          value: option,
          isSelected: selectedAnswer == option,
          isEvaluated: isEvaluating && !isExamMode,
          isCorrectAnswer: option == correctAnswer,
          onTap: () => onAnswer(option),
        );
      },
    );
  }
}
