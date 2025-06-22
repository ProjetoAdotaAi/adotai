import '../models/pet_model.dart';
import '../utils/api.dart';

class PetService {
  final Api api = Api();

  Future<void> createPet(PetModel pet) async {
    final response = await api.request(
      '/api/pets',
      method: 'POST',
      data: pet.toJson(),
    );

    if (response['statusCode'] != 201) {
      throw Exception('Erro ao criar pet: ${response['message'] ?? 'Status inesperado'}');
    }
  }

  Future<List<PetModel>> getPets({int page = 1, int limit = 15}) async {
    final response = await api.request('/api/pets?page=$page&limit=$limit', method: 'GET');
    final List data = response['data'];
    return data.map((json) => PetModel.fromJson(json)).toList();
  }

  Future<PetModel> getPetById(String id) async {
    final json = await api.request('/api/pets/$id', method: 'GET');
    final pet = PetModel.fromJson(json);
    return pet;
  }

  Future<void> updatePet(String id, PetModel pet) async {
    await api.request('/api/pets/$id', method: 'PUT', data: pet.toJson());
  }

  Future<void> deletePet(String id) async {
    await api.request('/api/pets/$id', method: 'DELETE');
  }
}
