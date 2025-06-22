import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ProfileTextFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController instagramController;
  final TextEditingController cepController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final InputBorder Function(Color) inputBorder;

  const ProfileTextFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.instagramController,
    required this.cepController,
    required this.cityController,
    required this.stateController,
    required this.inputBorder,
  });

  InputBorder _customBorder(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: BorderRadius.circular(5),
      );

  @override
  Widget build(BuildContext context) {
    final darkGray = const Color(0xFF444444);

    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Nome',
            border: _customBorder(darkGray),
            enabledBorder: _customBorder(darkGray),
            focusedBorder: _customBorder(AppTheme.primaryColor),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: _customBorder(darkGray),
            enabledBorder: _customBorder(darkGray),
            focusedBorder: _customBorder(AppTheme.primaryColor),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: 'Telefone',
            border: _customBorder(darkGray),
            enabledBorder: _customBorder(darkGray),
            focusedBorder: _customBorder(AppTheme.primaryColor),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: instagramController,
          decoration: InputDecoration(
            labelText: 'Instagram',
            border: _customBorder(darkGray),
            enabledBorder: _customBorder(darkGray),
            focusedBorder: _customBorder(AppTheme.primaryColor),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: cepController,
          decoration: InputDecoration(
            labelText: 'CEP',
            border: _customBorder(darkGray),
            enabledBorder: _customBorder(darkGray),
            focusedBorder: _customBorder(AppTheme.primaryColor),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: cityController,
          decoration: InputDecoration(
            labelText: 'Cidade',
            border: _customBorder(darkGray),
            enabledBorder: _customBorder(darkGray),
            focusedBorder: _customBorder(AppTheme.primaryColor),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: stateController,
          decoration: InputDecoration(
            labelText: 'Estado',
            border: _customBorder(darkGray),
            enabledBorder: _customBorder(darkGray),
            focusedBorder: _customBorder(AppTheme.primaryColor),
          ),
        ),
      ],
    );
  }
}
