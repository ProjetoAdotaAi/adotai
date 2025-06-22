import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../widgets/edit_user/save_button.dart';
import '../widgets/edit_user/profile_text_fields.dart';
import '../widgets/home/appbar.dart';
import 'package:adotai/providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _instagramController;
  late TextEditingController _cepController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;

  bool _loading = false;

  InputBorder _inputBorder(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: BorderRadius.circular(8),
      );

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    final user = userProvider.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        setState(() => _loading = true);
        await userProvider.loadUser(userProvider.userId ?? '');
        final loadedUser = userProvider.currentUser;
        _nameController.text = loadedUser?.name ?? '';
        _emailController.text = loadedUser?.email ?? '';
        _phoneController.text = loadedUser?.phone ?? '';
        _instagramController.text = loadedUser?.instagram ?? '';
        _cepController.text = loadedUser?.address?.cep ?? '';
        _cityController.text = loadedUser?.address?.city ?? '';
        _stateController.text = loadedUser?.address?.state ?? '';
        setState(() => _loading = false);
      });
    }
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

  Future<void> _save() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;
    if (userId == null) return;

    setState(() => _loading = true);

    await userProvider.updateUser(
      id: userId,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      instagram: _instagramController.text.trim(),
      addressCep: _cepController.text.trim(),
      addressCity: _cityController.text.trim(),
      addressState: _stateController.text.trim(),
    );

    if (_imageFile != null) {
      final bytes = await _imageFile!.readAsBytes();
      final base64Image = base64Encode(bytes);
      await userProvider.updateProfilePicture(userId, base64Image);
    }

    setState(() => _loading = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _instagramController.dispose();
    _cepController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        hasBackButton: true,
        hasNotificationIcon: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
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
                                    : (Provider.of<UserProvider>(context).currentUser?.profilePicture != null
                                        ? NetworkImage(Provider.of<UserProvider>(context).currentUser!.profilePicture!)
                                        : const AssetImage('assets/images/default_icon.png')) as ImageProvider,
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
                      ProfileTextFields(
                        nameController: _nameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        instagramController: _instagramController,
                        cepController: _cepController,
                        cityController: _cityController,
                        stateController: _stateController,
                        inputBorder: _inputBorder,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CancelButton(
                              onPressed: _loading
                                  ? () {}
                                  : () {
                                      Navigator.of(context).pop();
                                    },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SaveButton(
                              loading: _loading,
                              onPressed: _save,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
