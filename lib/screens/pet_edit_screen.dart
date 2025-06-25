import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/pet_model.dart';
import '../models/pet_photo_model.dart';
import '../providers/pet_provider.dart';
import '../widgets/home/appbar.dart';

class PetEditScreen extends StatefulWidget {
  final PetModel pet;

  const PetEditScreen({required this.pet, super.key});

  @override
  State<PetEditScreen> createState() => _PetEditScreenState();
}

class _PetEditScreenState extends State<PetEditScreen> {
  late TextEditingController nameController;
  late TextEditingController aboutController;
  late String especie;
  late String porte;
  late String idade;
  late String sexo;
  late bool desverminado;
  late bool castrado;
  late bool vacinado;
  List<XFile> pickedPhotos = [];
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final pet = widget.pet;
    nameController = TextEditingController(text: pet.name);
    aboutController = TextEditingController(text: pet.description);
    especie = pet.species == PetSpecies.DOG ? 'Cachorro' : 'Gato';
    porte = pet.size == PetSize.SMALL
        ? 'Pequeno'
        : pet.size == PetSize.MEDIUM
            ? 'Médio'
            : 'Grande';
    idade = pet.age == PetAge.YOUNG
        ? 'Filhote'
        : pet.age == PetAge.ADULT
            ? 'Adulto'
            : 'Idoso';
    sexo = pet.sex == PetSex.MALE ? 'Macho' : 'Fêmea';
    desverminado = pet.dewormed;
    castrado = pet.castrated;
    vacinado = pet.vaccinated;
  }

  Future<void> onSave() async {
    if (isSaving) return;

    setState(() => isSaving = true);

    try {
      final provider = Provider.of<PetProvider>(context, listen: false);

      List<PetPhotoModel> photos = [];

      for (var photo in widget.pet.photos) {
        if (!photo.url.startsWith('data:image')) {
          photos.add(photo);
        }
      }

      for (var file in pickedPhotos) {
        final bytes = await File(file.path).readAsBytes();
        final base64Image = base64Encode(bytes);
        photos.add(PetPhotoModel(url: 'data:image/png;base64,$base64Image'));
      }

      final updatedPet = PetModel(
        id: widget.pet.id,
        name: nameController.text.trim(),
        species: especie == 'Cachorro' ? PetSpecies.DOG : PetSpecies.CAT,
        size: porte == 'Pequeno'
            ? PetSize.SMALL
            : porte == 'Médio'
                ? PetSize.MEDIUM
                : PetSize.LARGE,
        age: idade == 'Filhote'
            ? PetAge.YOUNG
            : idade == 'Adulto'
                ? PetAge.ADULT
                : PetAge.SENIOR,
        sex: sexo == 'Macho' ? PetSex.MALE : PetSex.FEMALE,
        castrated: castrado,
        dewormed: desverminado,
        vaccinated: vacinado,
        description: aboutController.text.trim(),
        adopted: widget.pet.adopted,
        ownerId: widget.pet.ownerId,
        createdAt: widget.pet.createdAt,
        photos: photos,
      );

      final error = await provider.updatePet(widget.pet.id!, updatedPet);

      if (error == null) {
        if (mounted) Navigator.pop(context, true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar pet: $e')));
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        hasBackButton: true,
        hasNotificationIcon: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...widget.pet.photos.map((photo) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Image.network(photo.url, width: 100, height: 100, fit: BoxFit.cover),
                      )),
                  ...pickedPhotos.map((file) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Image.file(File(file.path), width: 100, height: 100, fit: BoxFit.cover),
                      )),
                  IconButton(
                    icon: const Icon(Icons.add_a_photo, color: Colors.orange, size: 36),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final files = await picker.pickMultiImage();
                      if (files.isNotEmpty) {
                        setState(() {
                          pickedPhotos.addAll(files);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nome')),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Espécie'),
              value: especie,
              items: ['Cachorro', 'Gato'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => especie = val!),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Porte'),
              value: porte,
              items: ['Pequeno', 'Médio', 'Grande'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => porte = val!),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Idade'),
              value: idade,
              items: ['Filhote', 'Adulto', 'Idoso'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => idade = val!),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Macho'),
                    value: 'Macho',
                    groupValue: sexo,
                    onChanged: (val) => setState(() => sexo = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Fêmea'),
                    value: 'Fêmea',
                    groupValue: sexo,
                    onChanged: (val) => setState(() => sexo = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Castrado'),
              value: castrado,
              onChanged: (val) => setState(() => castrado = val),
            ),
            SwitchListTile(
              title: const Text('Vacinado'),
              value: vacinado,
              onChanged: (val) => setState(() => vacinado = val),
            ),
            SwitchListTile(
              title: const Text('Vermifugado'),
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
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: const Size.fromHeight(48),
              ),
              child: isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Salvar alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
