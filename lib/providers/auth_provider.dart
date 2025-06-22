import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/api.dart';
import 'user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      await _saveToken(token);

      final userJson = Map<String, dynamic>.from(result['user']);
      if (result.containsKey('address') && result['address'] != null) {
        userJson['address'] = result['address'];
      }

      final user = UserModel.fromJson(userJson);

      userProvider.currentUser = user;
      await _saveUser(user);

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
      await _saveToken(token);

      final userJson = Map<String, dynamic>.from(result['user']);
      if (result.containsKey('address') && result['address'] != null) {
        userJson['address'] = result['address'];
      }

      final user = UserModel.fromJson(userJson);

      userProvider.currentUser = user;
      await _saveUser(user);

      userProvider.notifyListeners();

    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _saveToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('token', token);
    } else {
      await prefs.remove('token');
    }
  }

  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString('user', jsonString);
  }

  Future<String?> getTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<UserModel?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user');
    if (jsonString != null) {
      final json = jsonDecode(jsonString);
      return UserModel.fromJson(json);
    }
    return null;
  }

  Future<void> logout() async {
    token = null;
    userProvider.currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    Api().setToken(null);
    notifyListeners();
  }
}
