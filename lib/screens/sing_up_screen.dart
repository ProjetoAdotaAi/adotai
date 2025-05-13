import 'package:adotai/screens/login_screen.dart';
import 'package:adotai/services/user_service.dart';
import 'package:adotai/services/via_cep.dart';
import 'package:adotai/theme/app_theme.dart';
import 'package:adotai/widgets/home/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../utils/snackbar.dart';
import '../widgets/sing_up/text_input.dart';

class UserRegistrationPage extends StatefulWidget {
  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final telefoneController = MaskedTextController(mask: '(00) 00000-0000');
  final instagramController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final cepController = MaskedTextController(mask: '00000-000');
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  bool? isONG;

  int etapa = 1;

  void _salvarCadastro() async {
    if (_formKey.currentState!.validate() && isONG != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: senhaController.text,
            );
        String userId = userCredential.user!.uid;

        final response = await UserService.salvarUsuario(
          userId: userId,
          nome: nomeController.text,
          telefone: telefoneController.text,
          instagram: instagramController.text,
          email: emailController.text,
          senha: senhaController.text,
          cep: cepController.text,
          cidade: cidadeController.text,
          estado: estadoController.text,
          isONG: isONG!,
        );

        if (response.statusCode == 201) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: null,
              content: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/validator.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(height: 35),
                    Text(
                      'Seu cadastro foi efetuado com sucesso! Prossiga para a tela de login.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Ir para o login', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        fixedSize: const Size(220, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          SnackBarUtil.showError(context, 'Erro ao salvar: ${response.body}');
        }
      } on FirebaseAuthException catch (e) {
        String mensagemErro;
        if (e.code == 'email-already-in-use') {
          mensagemErro = 'Este e-mail já está em uso.';
        } else if (e.code == 'invalid-email') {
          mensagemErro = 'E-mail inválido.';
        } else if (e.code == 'weak-password') {
          mensagemErro = 'A senha precisa ter pelo menos 6 caracteres.';
        } else {
          mensagemErro = 'Erro: ${e.message}';
        }

        SnackBarUtil.showError(context, mensagemErro);
      }
    } else {
      SnackBarUtil.showWarning(context, 'Preencha todos os campos obrigatórios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(hasBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(
                  child: Text(
                    "Cadastre-se gratuitamente",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              if (etapa == 1) ...[
                TextFormField(
                  controller: nomeController,
                  decoration: inputDecoration('Nome *'),
                  validator: (v) => v!.isEmpty ? 'Informe seu nome' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: telefoneController,
                  decoration: inputDecoration('Telefone *'),
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe seu telefone';
                    if (v.length != 15 && v.length != 14) return 'Telefone inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: instagramController,
                  decoration: inputDecoration('Instagram'),
                  keyboardType: TextInputType.twitter,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: inputDecoration('Email *'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe seu email';
                    final pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    if (!RegExp(pattern).hasMatch(v)) return 'Email inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: senhaController,
                  decoration: inputDecoration('Senha *'),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe sua senha';
                    if (v.length < 6) return 'A senha deve ter no mínimo 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    style: formButtonStyle(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() => etapa = 2);
                      }
                    },
                    child: const Text('Próximo'),
                  ),
                ),
              ],
              if (etapa == 2) ...[
                TextFormField(
                  controller: cepController,
                  decoration: inputDecoration('CEP *'),
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  onChanged: (cep) {
                    final formatado = cep.replaceAll(RegExp(r'\D'), '');
                    if (formatado.length == 8) {
                      consultarCep(
                        context,
                        cepController.text,
                        cidadeController.text,
                        estadoController.text,
                      );
                    }
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe seu CEP';
                    if (v.length != 9) return 'CEP inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: cidadeController,
                  decoration: inputDecoration('Cidade *'),
                  validator: (v) => v!.isEmpty ? 'Informe sua cidade' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: estadoController,
                  decoration: inputDecoration('Estado *'),
                  validator: (v) => v!.isEmpty ? 'Informe seu estado' : null,
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    style: formButtonStyle(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() => etapa = 3);
                      }
                    },
                    child: const Text('Próximo'),
                  ),
                ),
              ],
              if (etapa == 3) ...[
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      'Escolha o seu tipo de perfil',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () => setState(() => isONG = false),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isONG == false ? AppTheme.primaryColor : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isONG == false ? AppTheme.primaryColor : Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Protetor individual',
                          style: TextStyle(
                            color: isONG == false ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () => setState(() => isONG = true),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isONG == true ? AppTheme.primaryColor : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isONG == true ? AppTheme.primaryColor : Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'ONG',
                          style: TextStyle(
                            color: isONG == true ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Center(
                  child: ElevatedButton(
                    style: formButtonStyle(),
                    onPressed: isONG == null ? null : _salvarCadastro,
                    child: const Text('Finalizar Cadastro'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
