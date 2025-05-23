import 'dart:convert';
import 'package:adotai/services/via_cep_api.dart';
import 'package:adotai/theme/app_theme.dart';
import 'package:adotai/utils/validators.dart';
import 'package:adotai/widgets/home/appbar.dart';
import 'package:adotai/widgets/singup/form_button_style.dart';
import 'package:adotai/widgets/singup/input_decoration.dart';
import 'package:adotai/widgets/singup/alert_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:http/http.dart' as http;
import 'package:adotai/models/user_model.dart';

class UserRegistrationPage extends StatefulWidget {
  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  bool obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final instagramController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cepController = MaskedTextController(mask: '00000-000');
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  bool? isONG;

  // formSteps do formulário de cadastro
  int _formStep = 1;

   @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    instagramController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cepController.dispose();
    cityController.dispose();
    stateController.dispose();
    super.dispose();
  }

  Future<void> _registerUserInDatabase(UserModel user) async {
    //10.0.2.2 porta utilizada rodando o app por emulador
    final url = Uri.parse('http://10.0.2.2:4040/api/users');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      print('Usuário salvo no banco de dados com sucesso');
    } else {
      print('Erro ao salvar no backend: ${response.body}');
    }
  }

  void _registerUser() async {
    if (_formKey.currentState!.validate() && isONG != null) {
      try {
      
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text,
            );
 
        String userId = userCredential.user!.uid;

        final user = UserModel(
          firebaseId: userId,
          name: nameController.text,
          phone: phoneController.text,
          instagram: instagramController.text,
          email: emailController.text,
          password: passwordController.text,
          cep: cepController.text,
          city: cityController.text,
          state: stateController.text,
          isOng: isONG!,
        );

        await _registerUserInDatabase(user);

        showSuccessDialog(
          context,
          "Seu cadastro foi efetuado com sucesso! Prossiga para a tela de login.",
        );
        
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

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mensagemErro)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Text(
                    "Cadastre-se gratuitamente",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 25),

              if (_formStep == 1) ...[
                TextFormField(
                  controller: nameController,
                  decoration: customInputDecoration('Nome *'),
                  validator:
                      (value) => value!.isEmpty ? 'Informe seu nome' : null,
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: phoneController,
                  decoration: customInputDecoration('Telefone *'),
                  keyboardType: TextInputType.phone,
                  validator: phoneValidator,
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: instagramController,
                  decoration: customInputDecoration('Instagram'),
                  keyboardType: TextInputType.twitter,
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: emailController,
                  decoration: customInputDecoration('Email *'),
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: customInputDecoration(
                    'Senha *',
                    suffixIcon: IconButton(
                      tooltip:
                          obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppTheme.primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: passwordValidator,
                ),

                SizedBox(height: 50),

                Center(
                  child: ElevatedButton(
                    style: formButtonStyle(),

                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _formStep = 2;
                        });
                      }
                    },
                    child: Text('Próximo'),
                  ),
                ),
              ],

              if (_formStep == 2) ...[
                TextFormField(
                  controller: cepController,
                  decoration: customInputDecoration('CEP *'),
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  onChanged: (cep) {
                    String cepFormatado = cep.replaceAll(RegExp(r'\D'), '');
                    if (cepFormatado.length == 8) {
                      getAddressFromCep(
                        cep: cepFormatado,
                        cityController: cityController,
                        stateController: stateController,
                        context: context,
                      );
                    }
                  },
                  validator: cepValidator,
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: cityController,
                  decoration: customInputDecoration('Cidade *'),
                  keyboardType: TextInputType.text,
                  validator:
                      (value) => value!.isEmpty ? 'Informe sua cidade' : null,
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: stateController,
                  decoration: customInputDecoration('Estado *'),
                  keyboardType: TextInputType.text,
                  validator:
                      (value) => value!.isEmpty ? 'Informe seu estado' : null,
                ),

                SizedBox(height: 50),

                Center(
                  child: ElevatedButton(
                    style: formButtonStyle(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _formStep = 3;
                        });
                      }
                    },
                    child: Text('Próximo'),
                  ),
                ),
              ],

              SizedBox(height: 30),
              if (_formStep == 3) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Text(
                      'Escolha o seu tipo de perfil',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 60),

                // Botão Protetor individual
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isONG = false;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color:
                            isONG == false
                                ? AppTheme.primaryColor
                                : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isONG == false
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Protetor individual',
                          style: TextStyle(
                            color: isONG == false ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Botão ONG
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isONG = true;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color:
                            isONG == true
                                ? AppTheme.primaryColor
                                : Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color:
                              isONG == true
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'ONG',
                          style: TextStyle(
                            color: isONG == true ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 60),
                Center(
                  child: ElevatedButton(
                    style: formButtonStyle(),
                    onPressed: isONG == null ? null : _registerUser,
                    child: Text('Finalizar Cadastro'),
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
