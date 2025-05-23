import 'package:adotai/theme/app_theme.dart';
import 'package:flutter/material.dart';

ButtonStyle formButtonStyle({Size size = const Size(220, 50)}) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      fixedSize: size,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      textStyle: const TextStyle(color: Colors.white, fontSize: 18),
    );
  }