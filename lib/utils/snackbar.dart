import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SnackBarUtil {
  static const Duration _duration = Duration(seconds: 3);
  static const TextStyle _textStyle = TextStyle(color: Colors.white);

  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(context, message, AppTheme.gradientStart);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackbar(context, message, AppTheme.primaryColor);
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.red);
  }

  static void _showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: _textStyle),
        backgroundColor: color,
        duration: _duration,
      ),
    );
  }
}
