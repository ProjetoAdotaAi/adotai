import 'package:adotai/widgets/home/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserRegistrationPage extends StatefulWidget {
  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final instagramController = TextEditingController();
  final senhaController = TextEditingController();
  final cepController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  bool? isONG;

  // Etapas do formulário de cadastro
  int etapa = 1;

  void _salvarCadastro() async {
if (_formKey.currentState!.validate() && isONG != null) {
    try {
      // Criando o usuário no Firebase Authentication
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
        'perfil': isONG != null ? (isONG! ? 'ONG' : 'Protetor individual') : 'Não selecionado',
      });

      // Sucesso: mensagem de feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro concluído com sucesso!')),
      );

      print("Usuário criado com sucesso e dados salvos no Firestore!");
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagemErro)),
      );
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
    print("Perfil: ${isONG != null ? (isONG! ? 'ONG' : 'Protetor individual') : 'Não selecionado'}");
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
        borderSide: BorderSide(
          color: Colors.black,
          width: 2,
        ),
      ),
    );
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
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 16),

              if (etapa == 1) ...[
                TextFormField(
                  controller: nomeController,
                  decoration: _inputDecoration('Nome'),
                  validator: (value) => value!.isEmpty ? 'Informe seu nome' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: telefoneController,
                  decoration: _inputDecoration('Telefone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Informe seu telefone' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: _inputDecoration('Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Informe seu email' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: instagramController,
                  decoration: _inputDecoration('@Instagram'),
                  keyboardType: TextInputType.twitter,
                  validator: (value) => value!.isEmpty ? 'Informe seu instagram' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: senhaController,
                  decoration: _inputDecoration('Senha'),
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        etapa = 2;
                      });
                    }
                  },
                  child: Text('Próximo'),
                ),
              ],

              if (etapa == 2) ...[
                TextFormField(
                  controller: cepController,
                  decoration: _inputDecoration('CEP'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Informe seu CEP' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: cidadeController,
                  decoration: _inputDecoration('Cidade'),
                  keyboardType: TextInputType.text,
                  validator: (value) => value!.isEmpty ? 'Informe sua cidade' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: estadoController,
                  decoration: _inputDecoration('Estado'),
                  keyboardType: TextInputType.text,
                  validator: (value) => value!.isEmpty ? 'Informe seu estado' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        etapa = 3;
                      });
                    }
                  },
                  child: Text('Próximo'),
                ),
              ],

              if (etapa == 3) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Escolha o seu tipo de perfil',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 60),
                RadioListTile<bool>(
                  title: Text('Protetor individual'),
                  value: false,
                  groupValue: isONG,
                  onChanged: (value) {
                    setState(() {
                      isONG = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                RadioListTile<bool>(
                  title: Text('ONG'),
                  value: true,
                  groupValue: isONG,
                  onChanged: (value) {
                    setState(() {
                      isONG = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isONG == null ? null : _salvarCadastro,
                  child: Text('Finalizar Cadastro'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
