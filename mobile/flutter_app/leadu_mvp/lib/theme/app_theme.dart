import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF1F8A70),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F8A70),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1F8A70),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
