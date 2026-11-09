enum TextScalePreset {
  small(0.90, 'Pequeño'),
  normal(1.00, 'Normal'),
  large(1.25, 'Grande'),
  extraLarge(1.50, 'Muy grande');

  const TextScalePreset(this.factor, this.label);

  final double factor;
  final String label;

  static TextScalePreset fromStorage(String? value) =>
      values.firstWhere((preset) => preset.name == value, orElse: () => normal);
}
