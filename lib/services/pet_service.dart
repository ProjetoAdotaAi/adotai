import 'dart:convert';
import '../models/pet_model.dart';
import '../utils/api.dart';

class PetService {
  final Api api = Api();

  Future<String?> createPet(PetModel pet) async {
    try {
      final response = await api.post('/api/pets', pet.toJson());
      if (response.statusCode == 201) return null;
      return 'Erro ao criar pet: ${response.statusCode}';
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<PetModel>> getPets({int page = 1, int limit = 15}) async {
    final query = '?page=$page&limit=$limit';
    final response = await api.get('/api/pets$query');
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      return data.map((json) => PetModel.fromJson(json)).toList();
    }
    throw Exception('Erro ao buscar pets');
  }

  Future<PetModel?> getPetById(String id) async {
    final response = await api.get('/api/pets/$id');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PetModel.fromJson(json);
    }
    return null;
  }

  Future<String?> updatePet(String id, PetModel pet) async {
    try {
      final response = await api.put('/api/pets/$id', pet.toJson());
      if (response.statusCode == 200) return null;
      return 'Erro ao atualizar pet: ${response.statusCode}';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deletePet(String id) async {
    try {
      final response = await api.delete('/api/pets/$id');
      if (response.statusCode == 200) return null;
      return 'Erro ao deletar pet: ${response.statusCode}';
    } catch (e) {
      return e.toString();
    }
  }
}
