import 'package:adotai/utils/api.dart';

class ReportService {
  final Api _api = Api();

  Future<void> sendReport({
    required String petId,
    required String userId,
    required String reportText,
  }) async {
    final body = {
      'petId': petId,
      'userId': userId,
      'reportText': reportText,
    };

    // O método request já lança uma ApiException em caso de erro.
    // Se não houver erro, a execução continua normalmente.
    await _api.request(
      '/api/reports',
      method: 'POST',
      data: body,
    );
  }
}  