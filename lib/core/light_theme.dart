import 'package:flutter/material.dart';
import 'package:flutter/src/material/theme_data.dart';
import 'package:whisper/core/theme.dart';

class LightTheme implements AppTheme{
  @override
  ThemeData get theme => ThemeData(
      brightness: Brightness.light,

      appBarTheme: AppBarTheme(
          backgroundColor: Colors.white
      )
  );
}