import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(

    useMaterial3: true,

    colorSchemeSeed: Colors.indigo,

    scaffoldBackgroundColor: Colors.grey.shade100,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 2,
    ),

    cardTheme: CardThemeData(

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(

      style: ElevatedButton.styleFrom(

        minimumSize: const Size.fromHeight(50),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      focusedBorder: OutlineInputBorder(

        borderRadius: BorderRadius.circular(12),

        borderSide: const BorderSide(
          color: Colors.indigo,
          width: 2,
        ),
      ),
    ),

    textTheme: const TextTheme(

      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
      ),
    ),
  );
}