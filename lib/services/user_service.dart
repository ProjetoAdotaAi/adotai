import '../models/user_model.dart';
import '../utils/api.dart';

class UserService {
  final Api api = Api();

  Future<String?> registerUser(UserModel user) async {
    try {
      print('Requisição POST /api/users com dados do usuário');
      await api.request('/api/users', method: 'POST', data: user.toJson());
      print('Usuário registrado com sucesso na API');
      return null;
    } catch (e) {
      print('Erro na API ao registrar usuário: $e');
      return e.toString();
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      print('Requisição GET /api/users');
      final json = await api.request('/api/users', method: 'GET');
      final List data = json is List ? json : json['data'];
      print('Usuários obtidos: ${data.length}');
      return data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      print('Erro na API ao obter usuários: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      print('Requisição GET /api/users/$id');
      final json = await api.request('/api/users/$id', method: 'GET');
      print('Dados do usuário recebidos: $json');
      print('Usuário obtido com sucesso');
      return UserModel.fromJson(json['user'] ?? json);
    } catch (e) {
      print('Erro na API ao obter usuário: $e');
      rethrow;
    }
  }

  Future<String?> updateUser(String id, {String? name, String? email, String? password}) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    try {
      print('Requisição PUT /api/users/$id com dados: $data');
      await api.request('/api/users/$id', method: 'PUT', data: data);
      print('Usuário atualizado com sucesso');
      return null;
    } catch (e) {
      print('Erro na API ao atualizar usuário: $e');
      return e.toString();
    }
  }

  Future<String?> deleteUser(String id) async {
    try {
      print('Requisição DELETE /api/users/$id');
      await api.request('/api/users/$id', method: 'DELETE');
      print('Usuário deletado com sucesso');
      return null;
    } catch (e) {
      print('Erro na API ao deletar usuário: $e');
      return e.toString();
    }
  }

  Future<String?> updateProfilePicture(String id, String base64Image) async {
    try {
      print('Requisição PATCH /api/users/$id para atualizar foto de perfil');
      await api.request('/api/users/$id', method: 'PATCH', data: {'profilePicture': base64Image});
      print('Foto de perfil atualizada com sucesso');
      return null;
    } catch (e) {
      print('Erro na API ao atualizar foto de perfil: $e');
      return e.toString();
    }
  }
}
