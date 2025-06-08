import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/pet_service.dart';

class PetProvider with ChangeNotifier {
  final PetService _petService = PetService();

  List<PetModel> pets = [];
  PetModel? selectedPet;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadPets({int page = 1, int limit = 15}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      pets = await _petService.getPets(page: page, limit: limit);
    } catch (_) {
      errorMessage = 'Erro ao carregar pets';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadPetById(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      selectedPet = await _petService.getPetById(id);
      if (selectedPet == null) errorMessage = 'Pet não encontrado';
    } catch (_) {
      errorMessage = 'Erro ao carregar pet';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> createPet(PetModel pet) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _petService.createPet(pet);
      await loadPets();
      return null;
    } catch (e) {
      errorMessage = 'Erro ao criar pet: ${e.toString()}';
      return errorMessage;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> updatePet(String id, PetModel pet) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _petService.updatePet(id, pet);
      await loadPetById(id);
      await loadPets();
      return null;
    } catch (e) {
      errorMessage = 'Erro ao atualizar pet: ${e.toString()}';
      return errorMessage;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> deletePet(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _petService.deletePet(id);
      pets.removeWhere((pet) => pet.id == id);
      if (selectedPet?.id == id) selectedPet = null;
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
