import '../models/pet_model.dart';
import '../utils/api.dart';

class InteractionService {
  final Api api = Api();

  Future<void> createInteraction({
    required String petId,
    required String type,
  }) async {
    try {
      await api.request(
        '/api/interactions',
        method: 'POST',
        data: {
          'petId': petId,
          'type': type,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PetModel>> getPetsForUser({
    int page = 1,
    int limit = 15,
    List<String>? species,
    List<String>? ageCategory,
    List<String>? sex,
    List<String>? size,
    bool? isOng,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    if (species != null && species.isNotEmpty) {
      queryParams['species'] = species.join(',');
    }
    if (ageCategory != null && ageCategory.isNotEmpty) {
      queryParams['ageCategory'] = ageCategory.join(',');
    }
    if (sex != null && sex.isNotEmpty) {
      queryParams['sex'] = sex.join(',');
    }
    if (size != null && size.isNotEmpty) {
      queryParams['size'] = size.join(',');
    }
    if (isOng != null) {
      queryParams['isOng'] = isOng.toString();
    }

    final uri = Uri(path: '/api/interactions', queryParameters: queryParams).toString();

    try {
      final response = await api.request(uri, method: 'GET');
      final List data = response['data'];
      return data.map((json) => PetModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PetModel>> getUserInteractions({
    required String type,
    int page = 1,
    int limit = 15,
  }) async {
    final uri = Uri(
      path: '/api/interactions/list',
      queryParameters: {
        'type': type,
        'page': page.toString(),
        'limit': limit.toString(),
      },
    ).toString();

    try {
      final response = await api.request(uri, method: 'GET');
      final List data = response['data'];
      return data.map((json) => PetModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
