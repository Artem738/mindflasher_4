enum WeightDelaysEnum {
  noDelay(0, 'noDelay'),
  badSmallDelay(1, 'badSmallDelay'),
  normMedDelay(7, 'normMedDelay'),
  goodLongDelay(30, 'goodLongDelay');

  final int value;
  final String name;

  const WeightDelaysEnum(this.value, this.name);
}
