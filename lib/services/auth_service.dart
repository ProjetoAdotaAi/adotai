import 'package:google_sign_in/google_sign_in.dart';
import '../utils/api.dart';

class AuthService {
  final Api api;

  AuthService({required this.api});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = {'email': email, 'password': password};

    print('[Login] Enviando dados de login: $data');

    try {
      final response = await api.request(
        '/api/login',
        method: 'POST',
        data: data,
      );

      print('[Login] Resposta recebida: $response');

      if (response.containsKey('token') && response.containsKey('user')) {
        print('[Login] Login bem-sucedido. Token e usuário presentes.');
        return {
          'token': response['token'],
          'user': response['user'],
        };
      } else {
        print('[Login] Erro: Resposta incompleta do servidor');
        throw Exception('Resposta incompleta do servidor');
      }
    } catch (e, stackTrace) {
      print('[Login] Exceção capturada: $e');
      print('[Login] Stack trace:\n$stackTrace');
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
