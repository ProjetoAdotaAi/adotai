import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/adress_model.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _currentUser;
  bool isLoading = false;
  String? errorMessage;

  UserModel? get currentUser => _currentUser;

  set currentUser(UserModel? user) {
    _currentUser = user;
    _saveUserToPrefs(user);
    notifyListeners();
  }

  String? get userId => _currentUser?.id;

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user');
    if (jsonString != null) {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      _currentUser = UserModel.fromJson(json);
      notifyListeners();
    }
  }

  Future<void> _saveUserToPrefs(UserModel? user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      final jsonString = jsonEncode(user.toJson());
      await prefs.setString('user', jsonString);
    } else {
      await prefs.remove('user');
    }
  }

  Future<String?> registerUser({
    required String name,
    required String phone,
    required String instagram,
    required String email,
    required String password,
    required String cep,
    required String city,
    required String state,
    required bool isOng,
  }) async {
    try {
      final result = await _userService.registerUser(
        UserModel(
          id: '',
          firebaseId: '',
          name: name,
          phone: phone,
          instagram: instagram,
          email: email,
          password: password,
          address: AddressModel(
            id: '',
            cep: cep,
            city: city,
            state: state,
            userId: '',
          ),
          isOng: isOng,
          profilePicture: null,
          pets: [],
        ),
      );
      return result;
    } catch (e) {
      return 'Erro: $e';
    }
  }
  
  Future<void> loadUser(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _userService.getUserById(id);
      if (user == null) {
        errorMessage = 'Usuário não encontrado';
        _currentUser = null;
        await _saveUserToPrefs(null);
      } else {
        _currentUser = user;
        await _saveUserToPrefs(user);
      }
    } catch (e) {
      errorMessage = 'Erro ao carregar usuário: $e';
      _currentUser = null;
      await _saveUserToPrefs(null);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> updateUser({
    required String id,
    String? name,
    String? email,
    String? phone,
    String? instagram,
    String? addressCep,
    String? addressCity,
    String? addressState,
  }) async {
    isLoading = true;
    notifyListeners();

    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (instagram != null) data['instagram'] = instagram;

    final address = <String, dynamic>{};
    if (addressCep != null) address['cep'] = addressCep;
    if (addressCity != null) address['city'] = addressCity;
    if (addressState != null) address['state'] = addressState;
    if (address.isNotEmpty) data['address'] = address;

    final error = await _userService.updateUser(id, data);

    if (error == null) {
      await loadUser(id);
    } else {
      errorMessage = error;
    }

    isLoading = false;
    notifyListeners();
    return error;
  }

  Future<String?> deleteUser(String id) async {
    isLoading = true;
    notifyListeners();

    final error = await _userService.deleteUser(id);

    if (error != null) {
      errorMessage = error;
    } else {
      _currentUser = null;
      await _saveUserToPrefs(null);
    }

    isLoading = false;
    notifyListeners();
    return error;
  }

  Future<String?> updateProfilePicture(String id, String base64Image) async {
    isLoading = true;
    notifyListeners();

    final error = await _userService.updateProfilePicture(id, base64Image);

    if (error == null) {
      await loadUser(id);
    } else {
      errorMessage = error;
    }

    isLoading = false;
    notifyListeners();
    return error;
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final users = await _userService.getUsers();
      return users;
    } catch (e) {
      errorMessage = 'Erro ao carregar usuários: $e';
      notifyListeners();
      return [];
    }
  }
}
