import 'package:flutter/material.dart';

import 'background_theme.dart';
import 'custom_text_theme.dart';

extension ThemeContextExtensions on BuildContext {
  Background get background => Theme.of(this).extension<Background>()!;
  CustomText get customText => Theme.of(this).extension<CustomText>()!;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
}
