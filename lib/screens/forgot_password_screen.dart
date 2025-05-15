import 'package:adotai/theme/app_theme.dart';
import 'package:adotai/widgets/home/appbar.dart';
import 'package:adotai/widgets/singup/alert_dialogs.dart';
import 'package:adotai/widgets/singup/form_button_style.dart';
import 'package:adotai/widgets/singup/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      showSuccessDialog(
        context,
        "Se este e-mail estiver cadastrado, você receberá um link para redefinir sua senha.",
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
        body: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Icon(Icons.lock_reset, size: 80, color: AppTheme.primaryColor),
                  SizedBox(height: 20),
                  Text(
                    'Informe seu e-mail para receber o link de redefinição de senha.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: FormInputDecoration("Email "),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe seu email';
                      }
                      // Regex para validar formato de email
                      String pattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      RegExp regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        return 'Email inválido';
                      }
                      return null; // Email válido
                    },
                  ),
                  SizedBox(height: 60),
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _resetPassword,
                        style: formButtonStyle(),
                        child:
                            _isLoading
                                ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text('Recuperar Senha'),
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
