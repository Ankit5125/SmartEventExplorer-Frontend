import 'package:flutter/material.dart';

class Apptheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueAccent,
      errorContainer: Colors.redAccent,
      primary: Colors.blueAccent,
      secondary: Colors.lightBlue,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: Brightness.dark,
      errorContainer: Colors.redAccent,
      secondary: Colors.grey,
      primary: Colors.black,
    ),
  );
}
