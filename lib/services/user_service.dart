import '../models/user_model.dart';
import '../utils/api.dart';

class UserService {
  final Api api = Api();

  Future<String?> registerUser(UserModel user) async {
    try {
      await api.request('/api/users', method: 'POST', data: user.toJson());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      final json = await api.request('/api/users', method: 'GET');
      final List data = json is List ? json : json['data'];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      print('Requesting user with id: $id');
      final json = await api.request('/api/users/$id', method: 'GET');
      print('Response JSON: $json');

      if (json == null) {
        print('Response JSON is null, returning null');
        return null;
      }

      final user = UserModel.fromJson(json);
      print('Parsed UserModel: $user');

      return user;
    } catch (e, stack) {
      print('Error fetching user with id $id: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }

  Future<String?> updateUser(String id, Map<String, dynamic> updatedData) async {
    try {
      await api.request('/api/users/$id', method: 'PUT', data: updatedData);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteUser(String id) async {
    try {
      await api.request('/api/users/$id', method: 'DELETE');
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateProfilePicture(String id, String base64Image) async {
    try {
      await api.request('/api/users/$id', method: 'PATCH', data: {'profilePicture': base64Image});
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
