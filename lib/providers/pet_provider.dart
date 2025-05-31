import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet_model.dart';
import '../services/pet_service.dart';

class PetProvider with ChangeNotifier {
  late PetService _petService;
  bool _isInitialized = false;

  List<PetModel> pets = [];
  PetModel? selectedPet;
  bool isLoading = false;
  String? errorMessage;

  PetProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); 
    _petService = PetService(token);
    _isInitialized = true;
    await loadPets();
  }

  Future<void> loadPets({int page = 1, int limit = 15}) async {
    if (!_isInitialized) return;
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
    if (!_isInitialized) return;
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
    if (!_isInitialized) return 'Provider não inicializado';
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
    if (!_isInitialized) return 'Provider não inicializado';
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
    if (!_isInitialized) return 'Provider não inicializado';
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
