import '../models/pet_model.dart';
import '../utils/api.dart';

class PetService {
  final Api api = Api();

  Future<void> createPet(PetModel pet) async {
    final data = pet.toJson();
    data.remove('id');
    final response = await api.request(
      '/api/pets',
      method: 'POST',
      data: data,
    );
    final statusCode = response['statusCode'] ?? 201;
    if (statusCode != 201) {
      final message = response['message'] ?? 'Status inesperado';
      throw Exception('Erro ao criar pet: $message');
    }
  }

  Future<List<PetModel>> getPets({int page = 1, int limit = 15}) async {
    final response = await api.request('/api/pets?page=$page&limit=$limit', method: 'GET');
    final List data = response['data'];
    return data.map((json) => PetModel.fromJson(json)).toList();
  }

  Future<PetModel> getPetById(String id) async {
    final json = await api.request('/api/pets/$id', method: 'GET');
    return PetModel.fromJson(json);
  }

  Future<void> updatePet(String id, PetModel pet) async {
    await api.request('/api/pets/$id', method: 'PUT', data: pet.toJson());
  }

  Future<void> deletePet(String id) async {
    await api.request('/api/pets/$id', method: 'DELETE');
  }

  Future<List<PetModel>> getPetsByOwner(String ownerId, {int page = 1, int limit = 15}) async {
    final response = await api.request('/api/users/$ownerId/pets?page=$page&limit=$limit', method: 'GET');
    final List data = response['data'];
    return data.map((json) => PetModel.fromJson(json)).toList();
  }

  Future<List<PetModel>> searchPetsByPreferences({
    bool? isOng,
    List<String>? species,
    List<String>? ageCategory,
    List<String>? sex,
    List<String>? size,
    int page = 1,
    int limit = 15,
  }) async {
    final queryParameters = <String, String>{};

    if (isOng != null) queryParameters['isOng'] = isOng.toString();
    if (species != null && species.isNotEmpty) queryParameters['species'] = species.join(',');
    if (ageCategory != null && ageCategory.isNotEmpty) queryParameters['ageCategory'] = ageCategory.join(',');
    if (sex != null && sex.isNotEmpty) queryParameters['sex'] = sex.join(',');
    if (size != null && size.isNotEmpty) queryParameters['size'] = size.join(',');

    queryParameters['page'] = page.toString();
    queryParameters['limit'] = limit.toString();

    final queryString = queryParameters.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final response = await api.request('/api/pets/search?$queryString', method: 'GET');

    final List data = response['data'] ?? [];
    return data.map((json) => PetModel.fromJson(json)).toList();
  }
}
