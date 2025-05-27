import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';
import '../widgets/home/appbar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;

  final _nameController = TextEditingController(text: 'Nome do Usuário');
  final _phoneController = TextEditingController(text: '45 99999-9999');
  final _instagramController = TextEditingController(text: '@instagram');
  final _locationController = TextEditingController(text: 'Endereço');
  final _descriptionController = TextEditingController(
    text:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vitae pharetra nibh, quis condimentum diam. Pellentesque bibendum nisi imperdiet ante eleifend, ac luctus ipsum aliquam.',
  );

  InputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(8),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        hasBackButton: true,
        hasNotificationIcon: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : const AssetImage('assets/images/default_icon.png')
                                as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: _inputBorder(Colors.black),
                  enabledBorder: _inputBorder(Colors.black),
                  focusedBorder: _inputBorder(AppTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: _inputBorder(Colors.black),
                  enabledBorder: _inputBorder(Colors.black),
                  focusedBorder: _inputBorder(AppTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _instagramController,
                decoration: InputDecoration(
                  labelText: 'Instagram',
                  border: _inputBorder(Colors.black),
                  enabledBorder: _inputBorder(Colors.black),
                  focusedBorder: _inputBorder(AppTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Endereço',
                  border: _inputBorder(Colors.black),
                  enabledBorder: _inputBorder(Colors.black),
                  focusedBorder: _inputBorder(AppTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: _inputBorder(Colors.black),
                  enabledBorder: _inputBorder(Colors.black),
                  focusedBorder: _inputBorder(AppTheme.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
