import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/interaction_type.dart';
import '../services/interacctions_service.dart';

class InteractionProvider with ChangeNotifier {
  final InteractionService _interactionService = InteractionService();

  bool isLoading = false;
  String? errorMessage;
  List<PetModel> pets = [];

  Future<String?> createInteraction({
    required String petId,
    required InteractionType type,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _interactionService.createInteraction(
        petId: petId,
        type: type.name,
      );
      return null;
    } catch (e) {
      errorMessage = 'Erro ao criar interação: ${e.toString()}';
      return errorMessage;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserInteractions(InteractionType type) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      pets = await _interactionService.getUserInteractions(type: type.name);
    } catch (e) {
      errorMessage = 'Erro ao carregar interações: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
