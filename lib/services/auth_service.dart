import 'package:google_sign_in/google_sign_in.dart';
import '../utils/api.dart';

class AuthService {
  final Api api;

  AuthService({required this.api});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = {'email': email, 'password': password};

    try {
      final response = await api.request(
        '/api/login',
        method: 'POST',
        data: data,
      );

      print('Response login completa: $response');

      if (response.containsKey('token') && response.containsKey('user')) {
        return {
          'token': response['token'],
          'user': response['user'],
        };
      } else {
        throw Exception('Resposta incompleta do servidor');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> loginGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Login com Google cancelado');
    }

    final data = {
      'email': googleUser.email,
      'name': googleUser.displayName ?? '',
    };

    try {
      final response = await api.request(
        '/api/login/google',
        method: 'POST',
        data: data,
      );

      if (response.containsKey('token') && response.containsKey('user')) {
        return {
          'token': response['token'],
          'user': response['user'],
        };
      } else {
        throw Exception('Resposta incompleta do servidor');
      }
    } catch (e) {
      rethrow;
    }
  }
}
