import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/pet_service.dart';

class PetProvider with ChangeNotifier {
  final PetService _petService = PetService();
  bool isLoading = false;
  String? errorMessage;
  List<PetModel> pets = [];
  int currentPage = 1;
  int limit = 15;
  bool hasMore = true;

  final Set<String> _interactedPetIds = {};

  List<PetModel> get filteredPets =>
      pets.where((pet) => !_interactedPetIds.contains(pet.id)).toList();

  void addInteractedPetId(String id) {
    _interactedPetIds.add(id);
    notifyListeners();
  }

  Future<String?> createPet(PetModel pet) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _petService.createPet(pet);
      await loadPets(reset: true);
      return null;
    } catch (e) {
      errorMessage = 'Erro ao criar pet: ${e.toString()}';
      return errorMessage;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPets({bool reset = false}) async {
    if (isLoading) return;
    if (reset) {
      currentPage = 1;
      hasMore = true;
      pets = [];
      notifyListeners();
    }
    if (!hasMore) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final newPets = await _petService.getPets(page: currentPage, limit: limit);
      if (newPets.length < limit) {
        hasMore = false;
      }
      pets.addAll(newPets);
      currentPage++;
    } catch (e) {
      errorMessage = 'Erro ao carregar pets: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<PetModel?> getPetById(String id) async {
    try {
      return await _petService.getPetById(id);
    } catch (e) {
      errorMessage = 'Erro ao buscar pet: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  Future<String?> updatePet(String id, PetModel pet) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _petService.updatePet(id, pet);
      await loadPets(reset: true);
      return null;
    } catch (e) {
      errorMessage = 'Erro ao atualizar pet: ${e.toString()}';
      return errorMessage;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Remove um pet da lista local (usado após reports bem-sucedidos)
  void removePetById(String id) {
    pets.removeWhere((p) => p.id == id);
    _interactedPetIds.remove(id); // Remove também da lista de interagidos
    notifyListeners();
  }

  Future<String?> deletePet(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _petService.deletePet(id);
      pets.removeWhere((p) => p.id == id);
      notifyListeners();
      return null;
    } catch (e) {
      errorMessage = 'Erro ao deletar pet: ${e.toString()}';
      return errorMessage;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
