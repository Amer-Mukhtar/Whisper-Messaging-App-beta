import 'package:flutter/material.dart';
import 'package:flutter/src/material/theme_data.dart';
import 'package:whisper/core/theme.dart';

class DarkTheme implements AppTheme{
  @override
  ThemeData get theme => ThemeData(
    brightness: Brightness.dark,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white
    )
  );
}