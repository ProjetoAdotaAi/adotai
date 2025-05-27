import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'token': data['token'],
        'user': data['user'],
      };
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Erro ao fazer login');
    }
  }

  Future<Map<String, dynamic>> loginGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) throw Exception('Login com Google cancelado');

    final email = googleUser.email;
    final name = googleUser.displayName ?? '';

    final url = Uri.parse('$baseUrl/api/login/google');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'name': name}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'token': data['token'],
        'user': data['user'],
      };
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Erro ao fazer login com Google');
    }
  }
}
