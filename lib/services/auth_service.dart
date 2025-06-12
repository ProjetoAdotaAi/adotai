import 'package:google_sign_in/google_sign_in.dart';
import '../utils/api.dart';

class AuthService {
  final Api api;

  AuthService({required this.api});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = {'email': email, 'password': password};
    print('Enviando dados de login: $data');

    try {
      final response = await api.request(
        '/api/login',
        method: 'POST',
        data: data,
      );

      print('Resposta recebida: $response');

      if (response.containsKey('token') && response.containsKey('user')) {
        return {
          'token': response['token'],
          'user': response['user'],
        };
      } else {
        print('Erro: resposta incompleta');
        throw Exception('Resposta incompleta do servidor');
      }
    } catch (e) {
      print('Erro no login: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> loginGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      print('Login com Google cancelado');
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

      print('Resposta recebida do login Google: $response');

      if (response.containsKey('token') && response.containsKey('user')) {
        return {
          'token': response['token'],
          'user': response['user'],
        };
      } else {
        print('Erro: resposta incompleta do login Google');
        throw Exception('Resposta incompleta do servidor');
      }
    } catch (e) {
      print('Erro no login Google: $e');
      rethrow;
    }
  }
}
