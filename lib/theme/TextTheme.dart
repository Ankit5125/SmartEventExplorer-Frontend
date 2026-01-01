import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextTheme {
  // ignore: non_constant_identifier_names
  static TextStyle HeadingStyle({Color color = Colors.white}) {
    return GoogleFonts.josefinSans(
      fontSize: 35,
      color: color,
      fontWeight: .bold,
    );
  }

  static TextStyle NormalStyle({Color color = Colors.white}) {
    return GoogleFonts.josefinSans(
      fontSize: 18,
      color: color,
      fontWeight: .normal,
    );
  }

  static TextStyle BigStyle({Color color = Colors.white}) {
    return GoogleFonts.josefinSans(
      fontSize: 25,
      color: color,
      fontWeight: .bold,
    );
  }

  static TextStyle smallStyle({Color color = Colors.white}) {
    return GoogleFonts.josefinSans(
      fontSize: 12,
      color: color,
      fontWeight: .bold,
    );
  }
}
