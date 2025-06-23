import 'package:adotai/providers/forgotPassword_provider.dart';
import 'package:adotai/widgets/forgotPassword/showSucessDialog.dart';
import 'package:adotai/widgets/forgotPassword/showErrorDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:adotai/theme/app_theme.dart';
import 'package:adotai/widgets/home/appbar.dart';
import 'package:adotai/widgets/singup/form_button_style.dart';
import 'package:adotai/widgets/singup/input_decoration.dart';

class ResetPasswordOtpScreen extends StatefulWidget {
  final String email;
  const ResetPasswordOtpScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<ResetPasswordOtpScreen> createState() =>
      _ResetPasswordOtpScreenState();
}

class _ResetPasswordOtpScreenState extends State<ResetPasswordOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _submitted = false;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) return 'Informe o código recebido';
    if (value.length != 6) return 'O código deve ter 6 dígitos';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Informe a nova senha';
    if (value.length < 6) return 'Senha deve ter ao menos 6 caracteres';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirme a nova senha';
    if (value != _passwordController.text) return 'As senhas não coincidem';
    return null;
  }

  Future<void> _handleResetPassword(OtpProvider otpProvider) async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    final success = await otpProvider.resetPassword(
      email: widget.email,
      otp: _otpController.text.trim(),
      newPassword: _passwordController.text.trim(),
    );

    if (success) {
      await showSuccessPasswordDialog(context);
      if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      String error = otpProvider.errorMessage ?? 'Erro desconhecido';

      if (error.toLowerCase().contains('400') ||
          error.toLowerCase().contains('exception')) {
        error =
            'O código informado está incorreto ou expirou. Por favor, verifique e tente novamente.';
      }

      if (mounted) {
        await showErrorDialog(context, error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final otpProvider = context.watch<OtpProvider>();

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.lock, size: 80, color: AppTheme.primaryColor),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: 'Digite o código enviado para ',
                    style: const TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const TextSpan(text: ' e a nova senha.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                /// OTP Field + erro
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        activeColor: AppTheme.primaryColor,
                        selectedColor: AppTheme.primaryColor,
                        inactiveColor: Colors.grey,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_submitted && _validateOtp(_otpController.text) != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          _validateOtp(_otpController.text)!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  decoration: customInputDecoration("Nova Senha"),
                  obscureText: true,
                  validator: _validatePassword,
                  enableSuggestions: false,
                  autocorrect: false,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: customInputDecoration("Confirmar Nova Senha"),
                  obscureText: true,
                  validator: _validateConfirmPassword,
                  enableSuggestions: false,
                  autocorrect: false,
                ),

                const SizedBox(height: 60),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: otpProvider.isLoading
                        ? null
                        : () => _handleResetPassword(otpProvider),
                    style: formButtonStyle(),
                    child: otpProvider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Redefinir Senha'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
