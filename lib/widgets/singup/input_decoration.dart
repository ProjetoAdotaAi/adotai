import 'package:flutter/material.dart';
import 'package:adotai/theme/app_theme.dart';

InputBorder _inputBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );
}

InputDecoration customInputDecoration(String labelText, {Widget? suffixIcon}) {
  return InputDecoration(
    labelText: labelText,
    border: _inputBorder(Colors.black),
    enabledBorder: _inputBorder(Colors.black),
    focusedBorder: _inputBorder(AppTheme.primaryColor),
    suffixIcon: suffixIcon,
  );
}