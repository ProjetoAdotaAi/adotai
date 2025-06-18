import 'package:flutter/material.dart';
import '../services/forgotPassword_service.dart'; 

class OtpProvider extends ChangeNotifier {
  final SendOtpProvider _service = SendOtpProvider();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> sendOtp(String email) async {
    _setLoading(true);
    final error = await _service.sendOtp(email);
    _setLoading(false);

    if (error != null) {
      _setError(error);
      return false;
    }

    _setError(null);
    return true;
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    _setLoading(true);
    final error = await _service.verifyOtpAndResetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    _setLoading(false);

    if (error != null) {
      _setError(error);
      return false;
    }

    _setError(null);
    return true;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }
}
