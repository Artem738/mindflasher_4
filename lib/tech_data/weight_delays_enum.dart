import 'package:flutter/material.dart';

enum WeightDelaysEnum {
  noDelay(0, 'noDelay', Colors.grey),
  badSmallDelay(1, 'badSmallDelay', Colors.redAccent),
  normMedDelay(7, 'normMedDelay', Colors.yellow),
  goodLongDelay(30, 'goodLongDelay', Colors.green);

  final int value;
  final String name;
  final Color color;

  const WeightDelaysEnum(this.value, this.name, this.color);

  static Color getColor(int? value) { // Принимаем int?, чтобы можно было передавать null
    if (value == null) {
      return WeightDelaysEnum.noDelay.color;
    }
    return WeightDelaysEnum.values.firstWhere(
          (e) => e.value == value,
      orElse: () => WeightDelaysEnum.noDelay, // Значение по умолчанию
    ).color;
  }
}
