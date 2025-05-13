import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<http.Response> salvarUsuario({
    required String userId,
    required String nome,
    required String telefone,
    required String instagram,
    required String email,
    required String senha,
    required String cep,
    required String cidade,
    required String estado,
    required bool isONG,
  }) async {
    final baseUrl = dotenv.env['API_BASE_URL']!;
    final url = Uri.parse('$baseUrl/api/users');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'firebaseId': userId,
        'name': nome,
        'phone': telefone,
        'instagram': instagram,
        'email': email,
        'password': senha,
        'address': {'cep': cep, 'city': cidade, 'state': estado},
        'isOng': isONG,
      }),
    );

    return response;
  }
}
