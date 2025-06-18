import '../utils/api.dart';

class SendOtpProvider {
  final Api api = Api();

  Future<String?> sendOtp(String email) async {
    try {
      print('Requisição POST /api/login/sendOtp com email: $email');
      await api.request(
        '/api/login/sendOtp',
        method: 'POST',
        data: {'email': email},
      );
      print('OTP enviado com sucesso para $email');
      return null;
    } catch (e) {
      print('Erro ao enviar OTP: $e');
      return e.toString();
    }
  }

  Future<String?> verifyOtpAndResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      print('Requisição POST /api/login/resetPassword com email: $email, otp: $otp');
      await api.request(
        '/api/login/resetPassword',
        method: 'POST',
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );
      print('Senha redefinida com sucesso para $email');
      return null;
    } catch (e) {
      print('Erro ao redefinir senha: $e');
      return e.toString();
    }
  }
}
