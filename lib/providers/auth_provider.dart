import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/api.dart';
import 'user_provider.dart';

class AuthProvider with ChangeNotifier {
  final AuthService authService;
  final UserProvider userProvider;

  String? token;
  String? errorMessage;
  bool isLoading = false;

  AuthProvider({required this.authService, required this.userProvider});

  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await authService.login(email, password);
      token = result['token'];

      Api().setToken(token);

      final userJson = result['user'];
      final user = UserModel.fromJson(userJson);

      userProvider.currentUser = user;
      userProvider.notifyListeners();

    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await authService.loginGoogle();
      token = result['token'];

      Api().setToken(token);

      final userJson = result['user'];
      final user = UserModel.fromJson(userJson);

      userProvider.currentUser = user;
      userProvider.notifyListeners();

    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
