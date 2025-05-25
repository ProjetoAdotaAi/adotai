import 'package:adotai/models/user_model.dart';
import 'package:adotai/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/adress_model.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  Future<String?> registerUser({
    required String name,
    required String phone,
    required String instagram,
    required String email,
    required String password,
    required String cep,
    required String city,
    required String state,
    required bool isOng,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final userId = userCredential.user!.uid;

      final user = UserModel(
        id: 0,
        firebaseId: userId,
        name: name,
        phone: phone,
        instagram: instagram,
        email: email,
        password: password,
        address: AddressModel(
          id: 0,
          cep: cep,
          city: city,
          state: state,
          userId: 0,
        ),
        isOng: isOng,
        profilePicture: null,
        pets: [],
      );

      return await _userService.registerUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') return 'Este e-mail já está em uso.';
      if (e.code == 'invalid-email') return 'E-mail inválido.';
      if (e.code == 'weak-password') return 'A senha precisa ter pelo menos 6 caracteres.';
      return 'Erro: ${e.message}';
    }
  }
}
