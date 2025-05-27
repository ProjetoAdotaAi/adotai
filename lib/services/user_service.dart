import 'dart:convert';
import '../models/user_model.dart';
import '../utils/api.dart';

class UserService {
  final Api api = Api();

  Future<String?> registerUser(UserModel user) async {
    try {
      final response = await api.post('/api/users', user.toJson());
      print('POST /api/users => ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 201) return null;
    } on ApiException catch (e) {
      print('Error on registerUser: ${e.message}');
      return e.message;
    }
    return 'Erro desconhecido';
  }

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await api.get('/api/users');
      print('GET /api/users => ${response.statusCode}');
      print('Response body: ${response.body}');
      final List data = jsonDecode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } on ApiException catch (e) {
      print('Error on getUsers: ${e.message}');
      rethrow;
    }
  }

  Future<UserModel?> getUserById(int id) async {
    try {
      final response = await api.get('/api/users/$id');
      print('GET /api/users/$id => ${response.statusCode}');
      print('Response body: ${response.body}');
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json['user']);
    } on ApiException catch (e) {
      print('Error on getUserById: ${e.message}');
      return null;
    }
  }

  Future<String?> updateUser(int id, {String? name, String? email, String? password}) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;

    try {
      final response = await api.put('/api/users/$id', data);
      print('PUT /api/users/$id => ${response.statusCode}');
      print('Request data: $data');
      print('Response body: ${response.body}');
      return null;
    } on ApiException catch (e) {
      print('Error on updateUser: ${e.message}');
      return e.message;
    }
  }

  Future<String?> deleteUser(int id) async {
    try {
      final response = await api.delete('/api/users/$id');
      print('DELETE /api/users/$id => ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    } on ApiException catch (e) {
      print('Error on deleteUser: ${e.message}');
      return e.message;
    }
  }

  Future<String?> updateProfilePicture(int id, String base64Image) async {
    try {
      final response = await api.patch('/api/users/$id', {"profilePicture": base64Image});
      print('PATCH /api/users/$id => ${response.statusCode}');
      print('Request data: ${{"profilePicture": base64Image}}');
      print('Response body: ${response.body}');
      return null;
    } on ApiException catch (e) {
      print('Error on updateProfilePicture: ${e.message}');
      return e.message;
    }
  }
}
