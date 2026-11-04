import 'package:flutter_test/flutter_test.dart';
import 'package:math_quest/features/math_engine/domain/usecases/generate_problem_usecase.dart';
import 'package:math_quest/features/math_engine/presentation/providers/practice_session_notifier.dart';

void main() {
  test('sets visual aids to an explicit repeatable value', () {
    final notifier = PracticeSessionNotifier(
      generateProblemUseCase: GenerateProblemUseCase(),
    );

    notifier.setVisualAidsEnabled(false);
    notifier.setVisualAidsEnabled(false);
    expect(notifier.state.showVisualAids, isFalse);

    notifier.setVisualAidsEnabled(true);
    expect(notifier.state.showVisualAids, isTrue);
  });
}
