import 'package:google_sign_in/google_sign_in.dart';
import '../utils/api.dart';

class AuthService {
  final Api api;

  AuthService({required this.api});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = {'email': email, 'password': password};
    final response = await api.request(
      '/api/login',
      method: 'POST',
      data: data,
    );
    return {
      'token': response['token'],
      'user': response['user'],
    };
  }

  Future<Map<String, dynamic>> loginGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) throw Exception('Login com Google cancelado');

    final data = {
      'email': googleUser.email,
      'name': googleUser.displayName ?? '',
    };

    final response = await api.request(
      '/api/login/google',
      method: 'POST',
      data: data,
    );

    return {
      'token': response['token'],
      'user': response['user'],
    };
  }
}
