import 'dart:convert';
import 'dart:io';
import 'package:adotai/widgets/home/appbar.dart';
import 'package:adotai/widgets/preferences/filter_options.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/pet_model.dart';
import '../models/pet_photo_model.dart';
import '../providers/pet_provider.dart';
import '../providers/user_provider.dart';

class PetRegistrationScreen extends StatelessWidget {
  const PetRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(hasBackButton: true),
      body: const PetRegistrationForm(),
    );
  }
}

class PetRegistrationForm extends StatefulWidget {
  const PetRegistrationForm({super.key});

  @override
  State<PetRegistrationForm> createState() => _PetRegistrationFormState();
}

class _PetRegistrationFormState extends State<PetRegistrationForm> {
  String? especie;
  String? porte;
  String? idade;
  String? sexo;
  bool desverminado = true;
  bool castrado = true;
  bool vacinado = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  List<XFile> pickedPhotos = [];
  bool isSaving = false;

  Future<void> onSave() async {
    if (isSaving) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado')),
      );
      return;
    }

    if (especie == null || porte == null || idade == null || sexo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      List<PetPhotoModel> photosModels = [];
      for (var file in pickedPhotos) {
        final bytes = await File(file.path).readAsBytes();
        final base64Image = base64Encode(bytes);
        photosModels.add(PetPhotoModel(url: 'data:image/png;base64,$base64Image'));
      }

      final pet = PetModel(
        name: nameController.text.trim(),
        species: especie!,
        size: porte!,
        age: _mapIdadeToInt(idade!),
        sex: sexo!,
        castrated: castrado,
        dewormed: desverminado,
        vaccinated: vacinado,
        description: aboutController.text.trim(),
        adopted: false,
        ownerId: userId,
        createdAt: DateTime.now(),
        photos: photosModels,
      );

      final provider = Provider.of<PetProvider>(context, listen: false);
      final error = await provider.createPet(pet);

      if (error == null) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar pet: $e')),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  int _mapIdadeToInt(String label) {
    switch (label) {
      case 'Filhote':
        return 0;
      case 'Adulto':
        return 1;
      case 'Idoso':
        return 2;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            children: pickedPhotos.map((file) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(file.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        pickedPhotos.remove(file);
                      });
                    },
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final picker = ImagePicker();
              final files = await picker.pickMultiImage();
              if (files.isNotEmpty) {
                setState(() {
                  pickedPhotos.addAll(files);
                });
              }
            },
            icon: const Icon(Icons.add, size: 30),
            label: const Text('Adicionar Fotos do Pet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              iconColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Espécie'),
            value: especie,
            items: ['Cachorro', 'Gato']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => especie = val),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Porte'),
            value: porte,
            items: ['Pequeno', 'Médio', 'Grande']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => porte = val),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Idade'),
            value: idade,
            items: ['Filhote', 'Adulto', 'Idoso']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => idade = val),
          ),
          const SizedBox(height: 16),
          SingleSelectToggle(
            selectedOption: sexo,
            options: ['Macho', 'Fêmea'],
            onSelectionChanged: (val) => setState(() => sexo = val),
            label: 'Sexo',
          ),
          const SizedBox(height: 16),
          Text('Saúde'),
          const SizedBox(height: 16),
          YesNoToggle(
            label: 'Castrado',
            value: castrado,
            onChanged: (val) => setState(() => castrado = val),
          ),
          const SizedBox(height: 16),
          YesNoToggle(
            label: 'Vacinado',
            value: vacinado,
            onChanged: (val) => setState(() => vacinado = val),
          ),
          const SizedBox(height: 16),
          YesNoToggle(
            label: 'Vermifugado',
            value: desverminado,
            onChanged: (val) => setState(() => desverminado = val),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: aboutController,
            maxLength: 500,
            minLines: 3,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Sobre',
              border: OutlineInputBorder(),
              hintText: 'Descreva o animal',
              hintStyle: TextStyle(color: Colors.grey),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: Colors.orange,
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Salvar dados'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
