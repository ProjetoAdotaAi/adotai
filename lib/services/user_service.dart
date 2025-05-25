import 'dart:convert';
import '../models/user_model.dart';
import '../utils/api.dart';

class UserService {
  final Api api = Api();

  Future<String?> registerUser(UserModel user) async {
    try {
      final response = await api.post('/api/users', user.toJson());
      if (response.statusCode == 201) return null;
    } on ApiException catch (e) {
      return e.message;
    }
    return 'Erro desconhecido';
  }

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await api.get('/api/users');
      final List data = jsonDecode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    }
  }

  Future<UserModel?> getUserById(int id) async {
    try {
      final response = await api.get('/api/users/$id');
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json['user']);
    } on ApiException {
      return null;
    }
  }

  Future<String?> updateUser(int id, {String? name, String? email, String? password}) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;

    try {
      await api.put('/api/users/$id', data);
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<String?> deleteUser(int id) async {
    try {
      await api.delete('/api/users/$id');
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  Future<String?> updateProfilePicture(int id, String base64Image) async {
    try {
      await api.patch('/api/users/$id', {"profilePicture": base64Image});
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }
}
