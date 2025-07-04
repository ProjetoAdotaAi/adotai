import 'package:adotai/screens/forgot_password_screen.dart';
import 'package:adotai/screens/sing_up_screen.dart';
import 'package:flutter/material.dart';

class SingInEmailLink extends StatelessWidget {
  const SingInEmailLink({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, 
        MaterialPageRoute(builder: (context) => SingUpScreen()));
      },
      child: const Text(
        'E-mail',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 14,
        ),
      ),
    );
  }
}

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, 
        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
      },
      child: const Text(
        'Recuperar senha',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 14,
        ),
      ),
    );
  }
}


