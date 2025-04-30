import 'package:flutter/material.dart';

class AppTheme {
  static const Color gradientStart = Color(0xFF0099DD);
  static const Color gradientEnd = Color(0xFF005277);
  static const Color primaryColor = Color(0xFFEA8420);
  static Color? cinza = Colors.grey[700];
  static Color? cinzaClaro = Colors.grey[300];

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gradientStart, gradientEnd],
  );
}
