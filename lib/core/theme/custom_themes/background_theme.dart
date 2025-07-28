import 'package:flutter/material.dart';

@immutable
class Background extends ThemeExtension<Background> {
  final Color primary;
  final Color accented;

  const Background({
    required this.primary,
    required this.accented,
  });

  @override
  Background copyWith({
    Color? primary,
    Color? accented,
  }) {
    return Background(
      primary: primary ?? this.primary,
      accented: accented ?? this.accented,
    );
  }

  @override
  Background lerp(ThemeExtension<Background>? other, double t) {
    if (other is! Background) return this;
    return Background(
      primary: Color.lerp(primary, other.primary, t)!,
      accented: Color.lerp(accented, other.accented, t)!,
    );
  }
}
