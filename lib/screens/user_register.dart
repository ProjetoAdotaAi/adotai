import 'dart:convert';

import 'package:adotai/screens/login_screen.dart';
import 'package:adotai/theme/app_theme.dart';
import 'package:adotai/widgets/home/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:http/http.dart' as http;

class UserRegistrationPage extends StatefulWidget {
  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final telefoneController = MaskedTextController(mask: '(00) 00000-0000');
  final emailController = TextEditingController();
  final instagramController = TextEditingController();
  final senhaController = TextEditingController();
  final cepController = MaskedTextController(mask: '00000-000');
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  bool? isONG;

  // Etapas do formulário de cadastro
  int etapa = 1;

  void _salvarCadastro() async {
    if (_formKey.currentState!.validate() && isONG != null) {
      try {
        //Criando o usuário no Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: senhaController.text,
            );

        // Pegando o UID do usuário
        String userId = userCredential.user!.uid;

        // Criando a collection no Firestore com os dados do usuário
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'codigo': userId,
          'nome': nomeController.text,
          'telefone': telefoneController.text,
          'email': emailController.text,
          'instagram': instagramController.text,
          'cep': cepController.text,
          'cidade': cidadeController.text,
          'estado': estadoController.text,
          'perfil':
              isONG != null
                  ? (isONG! ? 'ONG' : 'Protetor individual')
                  : 'Não selecionado',
        });

        //Alerta indicando que o cadastro foi efetuado com sucesso!

        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
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
                      SizedBox(height: 35),
                      Text(
                        'Seu cadastro foi efetuado com sucesso! Prossiga para a tela de login.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Ir para o login',
                          style: TextStyle(color: Colors.white),
                        ),
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

    print("Nome: ${nomeController.text}");
    print("Telefone: ${telefoneController.text}");
    print("Email: ${emailController.text}");
    print("Email: ${instagramController.text}");
    print("Senha: ${senhaController.text}");
    print("CEP: ${cepController.text}");
    print("Cidade: ${cidadeController.text}");
    print("Estado: ${estadoController.text}");
    print(
      "Perfil: ${isONG != null ? (isONG! ? 'ONG' : 'Protetor individual') : 'Não selecionado'}",
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppTheme.primaryColor),
      ),
    );
  }

  ButtonStyle formButtonStyle({Size size = const Size(220, 50)}) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      fixedSize: size,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(color: Colors.white),
    );
  }

  Future<void> consultarCep(String cep) async {
    final url = 'https://viacep.com.br/ws/$cep/json/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Preenche os campos com os dados retornados
      if (data['erro'] == null) {
        cidadeController.text = data['localidade'];
        estadoController.text = data['uf'];
      } else {
        // Caso o CEP seja inválido
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('CEP inválido')));
      }
    } else {
      // Se a requisição falhar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falha ao consultar o CEP')));
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

              if (etapa == 1) ...[
                TextFormField(
                  controller: nomeController,
                  decoration: _inputDecoration('Nome *'),
                  validator:
                      (value) => value!.isEmpty ? 'Informe seu nome' : null,
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: telefoneController,
                  decoration: _inputDecoration('Telefone *'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe seu telefone';
                    }
                    // Validar se o valor tem o comprimento certo (15 caracteres com a máscara)
                    if (value.length != 15 && value.length != 14) {
                      return 'Telefone inválido';
                    }
                    return null; // Telefone válido
                  },
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: emailController,
                  decoration: _inputDecoration('Email *'),
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

                SizedBox(height: 20),

                TextFormField(
                  controller: instagramController,
                  decoration: _inputDecoration('Instagram'),
                  keyboardType: TextInputType.twitter,
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: senhaController,
                  decoration: _inputDecoration('Senha *'),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe sua senha';
                    }

                    if (value.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 50),

                Center(
                  child: ElevatedButton(
                    style: formButtonStyle(),

                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          etapa = 2;
                        });
                      }
                    },
                    child: Text('Próximo'),
                  ),
                ),
              ],

              if (etapa == 2) ...[
                TextFormField(
                  controller: cepController,
                  decoration: _inputDecoration('CEP *'),
                  keyboardType: TextInputType.number,
                  maxLength: 9, // Defina o comprimento do CEP como 9
                  onChanged: (cep) {
                    // Remover caracteres não numéricos (como o hífen)
                    String cepFormatado = cep.replaceAll(RegExp(r'\D'), '');
                    if (cepFormatado.length == 8) {
                      consultarCep(cepFormatado);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe seu CEP';
                    }
                    if (value.length != 9) {
                      return 'CEP inválido';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: cidadeController,
                  decoration: _inputDecoration('Cidade *'),
                  keyboardType: TextInputType.text,
                  validator:
                      (value) => value!.isEmpty ? 'Informe sua cidade' : null,
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: estadoController,
                  decoration: _inputDecoration('Estado *'),
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
                          etapa = 3;
                        });
                      }
                    },
                    child: Text('Próximo'),
                  ),
                ),
              ],

              SizedBox(height: 30),
              if (etapa == 3) ...[
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
                        borderRadius: BorderRadius.circular(12),
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
                    onPressed: isONG == null ? null : _salvarCadastro,
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
