import 'package:flutter/material.dart';

@immutable
class CustomText extends ThemeExtension<CustomText> {
  final Color primary;
  final Color accented;

  const CustomText({
    required this.primary,
    required this.accented,
  });

  @override
  CustomText copyWith({
    Color? primary,
    Color? accented,
  }) {
    return CustomText(
      primary: primary ?? this.primary,
      accented: accented ?? this.accented,
    );
  }

  @override
  CustomText lerp(ThemeExtension<CustomText>? other, double t) {
    if (other is! CustomText) return this;
    return CustomText(
      primary: Color.lerp(primary, other.primary, t)!,
      accented: Color.lerp(accented, other.accented, t)!,
    );
  }
}
