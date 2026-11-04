class ParentGateConfig {
  final String? localizationId;
  final String title;
  final String description;
  final String actionLabel;

  const ParentGateConfig({
    this.localizationId,
    required this.title,
    required this.description,
    required this.actionLabel,
  });

  static const parentSettings = ParentGateConfig(
    localizationId: 'parentSettings',
    title: 'Parent Settings',
    description: 'Confirm you’re a grown-up before opening protected settings.',
    actionLabel: 'Unlock Settings',
  );

  static const screenLimit = ParentGateConfig(
    localizationId: 'screenLimit',
    title: 'Change Screen Limit',
    description: 'Confirm you’re a grown-up before changing daily play time.',
    actionLabel: 'Continue',
  );

  static const learningGoal = ParentGateConfig(
    localizationId: 'learningGoal',
    title: 'Change Learning Goal',
    description:
        'Confirm you’re a grown-up before changing the target math standard.',
    actionLabel: 'Continue',
  );

  static const resetProgress = ParentGateConfig(
    localizationId: 'resetProgress',
    title: 'Reset Adventure Progress',
    description:
        'This is a protected action. Confirm you’re a grown-up to continue.',
    actionLabel: 'Continue',
  );

  static const extraTime = ParentGateConfig(
    localizationId: 'extraTime',
    title: 'Add More Play Time',
    description: 'Confirm you’re a grown-up before adding 15 more minutes.',
    actionLabel: 'Add 15 Minutes',
  );
}
