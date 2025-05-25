import 'package:adotai/providers/user_provider.dart';
import 'package:adotai/services/via_cep_api.dart';
import 'package:adotai/theme/app_theme.dart';
import 'package:adotai/utils/validators.dart';
import 'package:adotai/widgets/home/appbar.dart';
import 'package:adotai/widgets/singup/form_button_style.dart';
import 'package:adotai/widgets/singup/input_decoration.dart';
import 'package:adotai/widgets/singup/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

import '../widgets/singup/profile_options.dart';

class SingUpScreen extends StatefulWidget {
  @override
  _SingUpScreenState createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
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

  void _registerUser() async {
    if (_formKey.currentState!.validate() && isONG != null) {
      final provider = Provider.of<UserProvider>(context, listen: false);

      final result = await provider.registerUser(
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

      if (result == null) {
        showSuccessDialog(
          context,
          "Seu cadastro foi efetuado com sucesso! Prossiga para a tela de login.",
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
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
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Cadastre-se gratuitamente",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 25),
              if (_formStep == 1) ...[
                TextFormField(
                  controller: nameController,
                  decoration: customInputDecoration('Nome *'),
                  validator: (v) => v!.isEmpty ? 'Informe seu nome' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneController,
                  decoration: customInputDecoration('Telefone *'),
                  keyboardType: TextInputType.phone,
                  validator: phoneValidator,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: instagramController,
                  decoration: customInputDecoration('Instagram'),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: customInputDecoration('Email *'),
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: customInputDecoration(
                    'Senha *',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppTheme.primaryColor,
                      ),
                      onPressed: () => setState(() => obscurePassword = !obscurePassword),
                    ),
                  ),
                  validator: passwordValidator,
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    style: formButtonStyle(),
                    onPressed: () => setState(() => _formStep = 2),
                    child: const Text('Próximo'),
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
                    final cleanCep = cep.replaceAll(RegExp(r'\D'), '');
                    if (cleanCep.length == 8) {
                      getAddressFromCep(
                        cep: cleanCep,
                        cityController: cityController,
                        stateController: stateController,
                        context: context,
                      );
                    }
                  },
                  validator: cepValidator,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: cityController,
                  decoration: customInputDecoration('Cidade *'),
                  validator: (v) => v!.isEmpty ? 'Informe sua cidade' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: stateController,
                  decoration: customInputDecoration('Estado *'),
                  validator: (v) => v!.isEmpty ? 'Informe seu estado' : null,
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    style: formButtonStyle(),
                    onPressed: () => setState(() => _formStep = 3),
                    child: const Text('Próximo'),
                  ),
                ),
              ],
              if (_formStep == 3) ...[
                const Center(
                  child: Text('Escolha o seu tipo de perfil', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 60),
                ProfileOption(
                  label: 'Protetor individual',
                  selected: isONG == false,
                  onTap: () => setState(() => isONG = false),
                ),
                const SizedBox(height: 20),
                ProfileOption(
                  label: 'ONG',
                  selected: isONG == true,
                  onTap: () => setState(() => isONG = true),
                ),
                const SizedBox(height: 60),
                Center(
                  child: ElevatedButton(
                    style: formButtonStyle(),
                    onPressed: isONG == null ? null : _registerUser,
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
