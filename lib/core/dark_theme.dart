import 'package:flutter/material.dart';
import 'package:flutter/src/material/theme_data.dart';
import 'package:whisper/core/theme.dart';

class DarkTheme implements AppTheme{
  @override
  ThemeData get theme => ThemeData(
    brightness: Brightness.dark,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white,fontSize: 16),
      iconTheme: IconThemeData(
        color: Colors.white),
    ),

        textTheme: const TextTheme(

          displayMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          displayLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
          displaySmall: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
      prefixStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    ),


  );
}