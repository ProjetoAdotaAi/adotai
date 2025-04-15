import 'package:flutter/material.dart';

class AppTheme {
  static const Color gradientStart = Color(0xFF0099DD);
  static const Color gradientEnd = Color(0xFF005277);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gradientStart, gradientEnd],
  );
}
