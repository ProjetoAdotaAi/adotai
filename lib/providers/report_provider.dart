import 'package:adotai/utils/api.dart';
import 'package:flutter/material.dart';
import '../services/report_service.dart';

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> sendReport({
    required String petId,
    required String userId,
    required String reportText,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _reportService.sendReport(
        petId: petId,
        userId: userId,
        reportText: reportText,
      );
      // Se chegou aqui, a requisição foi um sucesso (nenhuma exceção lançada)
      return true;
    } on ApiException catch (e) {
      _errorMessage = 'Erro ${e.statusCode}: ${e.message}';
      return false;
    } catch (e) {
      _errorMessage = 'Ocorreu um erro inesperado: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 