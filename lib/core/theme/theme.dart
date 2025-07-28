import 'package:flutter/material.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

abstract class AppTheme {
  ThemeData get theme;

  static final lightTheme = LightTheme();
  static final darkTheme = DarkTheme();
}
