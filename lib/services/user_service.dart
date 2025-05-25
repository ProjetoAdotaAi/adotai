import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:adotai/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  Future<String?> registerUser(UserModel user) async {
    final baseUrl = dotenv.env['BASE_URL'];
    final url = Uri.parse('$baseUrl/api/users');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) return null;
    return response.body;
  }
}
