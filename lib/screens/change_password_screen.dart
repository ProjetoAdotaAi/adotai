import 'package:flutter/material.dart';
import 'package:adotai/theme/app_theme.dart';
import 'package:adotai/widgets/home/appbar.dart';
import 'package:adotai/widgets/singup/form_button_style.dart';
import 'package:adotai/widgets/singup/input_decoration.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
    }
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(hasBackButton: true,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: currentPasswordController,
                obscureText: obscureCurrent,
                decoration: customInputDecoration(
                  'Senha Atual',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureCurrent ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () => setState(() => obscureCurrent = !obscureCurrent),
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Informe sua senha atual' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: newPasswordController,
                obscureText: obscureNew,
                decoration: customInputDecoration(
                  'Nova Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNew ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () => setState(() => obscureNew = !obscureNew),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a nova senha';
                  if (v.length < 6) return 'Senha deve ter no mínimo 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: obscureConfirm,
                decoration: customInputDecoration(
                  'Confirmar Nova Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Confirme a nova senha';
                  if (v != newPasswordController.text) return 'As senhas não coincidem';
                  return null;
                },
              ),
              const SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  style: formButtonStyle(),
                  onPressed: _submit,
                  child: const Text('Alterar Senha'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
