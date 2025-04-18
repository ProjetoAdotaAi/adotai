import 'package:flutter/material.dart';

class SingInEmailLink extends StatelessWidget {
  const SingInEmailLink({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('Cadastre-se como Cliente');
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

class SingInOngLink extends StatelessWidget {
  const SingInOngLink({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('Cadastre-se como Protetor/ONG');
      },
      child: const Text(
        'Protetor/ONG',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 14,
        ),
      ),
    );
  }
}
