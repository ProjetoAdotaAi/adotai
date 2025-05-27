import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/login/login_text_field.dart';
import '../widgets/login/login_links.dart';
import 'splash_screen.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                height: 650,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 150,
                      height: 150,
                    ),
                    Image.asset('assets/images/adotai.png'),
                    const SizedBox(height: 20),
                    LoginTextField(
                      labelText: 'E-mail',
                      hintText: 'Digite seu e-mail...',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    LoginTextField(
                      labelText: 'Senha',
                      hintText: 'Digite sua senha...',
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppTheme.primaryColor,
                        ),
                        onPressed: togglePasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();

                              await authProvider.loginWithEmail(email, password);

                              if (authProvider.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(authProvider.errorMessage!)),
                                );
                              } else if (authProvider.token != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SplashScreen(fromLogin: true),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        fixedSize: const Size(220, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Entrar',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                              await authProvider.loginWithGoogle();

                              if (authProvider.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(authProvider.errorMessage!)),
                                );
                              } else if (authProvider.token != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SplashScreen(fromLogin: true),
                                  ),
                                );
                              }
                            },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                        fixedSize: const Size(220, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Entrar com Google',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cadastre-se com ',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        SingInEmailLink(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Esqueçeu sua senha? ',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        ForgotPasswordLink(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
