import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/interaction_type.dart';
import '../services/interacctions_service.dart';

class InteractionProvider with ChangeNotifier {
  final InteractionService _interactionService = InteractionService();

  bool isLoading = false;
  String? errorMessage;

  List<PetModel> favoritedPets = [];
  List<PetModel> discardedPets = [];

  Set<String> get interactedPetIds {
    final ids = <String>{};
    ids.addAll(favoritedPets.map((p) => p.id!));
    ids.addAll(discardedPets.map((p) => p.id!));
    return ids;
  }

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
      if (type == InteractionType.FAVORITED) {
        favoritedPets = await _interactionService.getUserInteractions(type: type.name);
      } else if (type == InteractionType.DISCARDED) {
        discardedPets = await _interactionService.getUserInteractions(type: type.name);
      }
    } catch (e) {
      errorMessage = 'Erro ao carregar interações: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllUserInteractions() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      favoritedPets = await _interactionService.getUserInteractions(type: InteractionType.FAVORITED.name);
      discardedPets = await _interactionService.getUserInteractions(type: InteractionType.DISCARDED.name);
    } catch (e) {
      errorMessage = 'Erro ao carregar interações: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
