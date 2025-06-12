import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/pet_service.dart';

class PetProvider with ChangeNotifier {
  final PetService _petService = PetService();
  bool isLoading = false;
  String? errorMessage;
  List<PetModel> pets = [];

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

  Future<void> loadPets() async {
    isLoading = true;
    notifyListeners();

    try {
      pets = await _petService.getPets();
    } catch (e) {
      errorMessage = 'Erro ao carregar pets: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
