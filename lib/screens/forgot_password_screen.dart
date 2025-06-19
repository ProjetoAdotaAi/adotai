import 'package:adotai/providers/forgotPassword_provider.dart';
import 'package:adotai/widgets/forgotPassword/showAutoCloseSuccessDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:adotai/theme/app_theme.dart';
import 'package:adotai/widgets/home/appbar.dart';
import 'package:adotai/widgets/singup/form_button_style.dart';
import 'package:adotai/widgets/singup/input_decoration.dart';
import 'package:adotai/utils/validators.dart';

import 'reset_password_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> showOtpSentDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Expanded(child: Text('Código OTP enviado para o seu e-mail.')),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 4));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final otpProvider = context.watch<OtpProvider>();

    Future<void> _requestOtp() async {
  if (!_formKey.currentState!.validate()) return;

  final email = _emailController.text.trim();

  final success = await otpProvider.sendOtp(email);

  if (success) {
  
    await showAutoCloseSuccessDialog(context, email);
    
  
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResetPasswordOtpScreen(email: email),
      ),
    );
  } else {
    final error = otpProvider.errorMessage ?? 'Erro desconhecido';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }
}

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(Icons.lock_reset, size: 80, color: AppTheme.primaryColor),
                const SizedBox(height: 20),
                const Text(
                  'Informe seu e-mail para receber o código para redefinição de senha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: customInputDecoration("Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: otpProvider.isLoading ? null : _requestOtp,
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
                          : const Text('Enviar Código'),
                    ),
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
