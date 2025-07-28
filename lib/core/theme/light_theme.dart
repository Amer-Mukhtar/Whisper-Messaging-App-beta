import 'package:flutter/material.dart';
import 'package:whisper/core/theme/theme.dart';
import 'custom_themes/background_theme.dart';
import 'custom_themes/custom_text_theme.dart';

class LightTheme implements AppTheme{
  @override
  ThemeData get theme => ThemeData(
    brightness: Brightness.light,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black,fontSize: 16),
      iconTheme: IconThemeData(
          color: Colors.black),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold, color: Colors.black),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),

      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.black),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),

      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),

      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),

      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
        foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
        padding: WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
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

    extensions: const [
      Background(
          primary: Colors.grey,
          accented: Colors.white
      ),
      CustomText(
          primary: Colors.black,
          accented: Color(0xFF211a23)
      ),
    ],
  );
}