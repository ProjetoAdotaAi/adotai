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
    } catch (e) {
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
    } catch (e) {
      errorMessage = 'Erro ao carregar pet';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> createPet(PetModel pet) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final error = await _petService.createPet(pet);
    if (error == null) {
      await loadPets();
    } else {
      errorMessage = error;
    }

    isLoading = false;
    notifyListeners();
    return error;
  }

  Future<String?> updatePet(String id, PetModel pet) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final error = await _petService.updatePet(id, pet);
    if (error == null) {
      await loadPetById(id);
      await loadPets();
    } else {
      errorMessage = error;
    }

    isLoading = false;
    notifyListeners();
    return error;
  }

  Future<String?> deletePet(String id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final error = await _petService.deletePet(id);
    if (error == null) {
      pets.removeWhere((pet) => pet.id == id);
      if (selectedPet?.id == id) selectedPet = null;
    } else {
      errorMessage = error;
    }

    isLoading = false;
    notifyListeners();
    return error;
  }
}
