import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../widgets/login/login_text_field.dart';
import '../widgets/login/login_links.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  bool isLoading = false;

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
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
    return const Scaffold(body: _LoginBody());
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_LoginScreenState>()!;
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Container(
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
                        controller: state.emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      LoginTextField(
                        labelText: 'Senha',
                        hintText: 'Digite sua senha...',
                        controller: state.passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: state.obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            state.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppTheme.primaryColor,
                          ),
                          onPressed: state.togglePasswordVisibility,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final email = state.emailController.text;
                          final password = state.passwordController.text;

                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                            if (userCredential.user != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Erro ao fazer login")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          fixedSize: const Size(220, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),

                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                          fixedSize: const Size(220, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            bool isLogged = await login(context);
                            if (isLogged) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            }
                          },
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
                      ),

                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cadastre-se como ',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          SingInOngLink(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> login(BuildContext context) async {
    final state = context.findAncestorStateOfType<_LoginScreenState>()!;
    state.setLoading(true);

    try {
      final user = await GoogleSignIn().signIn();
      if (user == null) {
        state.setLoading(false);
        return false;
      }

      GoogleSignInAuthentication userAuth = await user.authentication;

      var credential = GoogleAuthProvider.credential(
        idToken: userAuth.idToken,
        accessToken: userAuth.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      return FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      return false;
    } finally {
      final state = context.findAncestorStateOfType<_LoginScreenState>()!;
      state.setLoading(false);
    }
  }
}
