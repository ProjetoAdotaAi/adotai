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
    try {
      print('[GET PETS] Requesting page=$page, limit=$limit');
      final response = await api.request('/api/pets?page=$page&limit=$limit', method: 'GET');

      print('[GET PETS] Response status: ${response['status'] ?? 'unknown'}');
      print('[GET PETS] Response data: ${response['data']}');

      final List data = response['data'];
      return data.map((json) => PetModel.fromJson(json)).toList();
    } catch (e, stacktrace) {
      print('[GET PETS] Error occurred: $e');
      print('[GET PETS] Stacktrace: $stacktrace');
      rethrow;
    }
  }

  Future<PetModel> getPetById(String id) async {
    try {
      print('Requesting pet with id: $id');
      final json = await api.request('/api/pets/$id', method: 'GET');
      print('Response JSON: $json');

      final pet = PetModel.fromJson(json);
      print('Parsed PetModel: $pet');

      return pet;
    } catch (e, stack) {
      print('Error fetching pet with id $id: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }

  Future<void> updatePet(String id, PetModel pet) async {
    await api.request('/api/pets/$id', method: 'PUT', data: pet.toJson());
  }

  Future<void> deletePet(String id) async {
    await api.request('/api/pets/$id', method: 'DELETE');
  }
}
