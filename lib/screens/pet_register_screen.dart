import 'package:adotai/widgets/home/appbar.dart';
import 'package:adotai/widgets/preferences/filter_options.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Também necessário para trabalhar com File

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

  List<ImageProvider> petPhotos = [];

  Map<String, dynamic> toAnimalMap({required String usuarioId}) {
    return {
      'nome': nameController.text.trim(),
      'idade': idade,
      'disponibilidade': true,
      'sexo': sexo,
      'porte': porte,
      'especie': especie,
      'castrado': castrado,
      'vacinado': vacinado,
      'vermifugado': desverminado,
      'descricao': aboutController.text.trim(),
      'usuario_id': usuarioId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [             
           Wrap(
            spacing: 8,
            children: [
              ...petPhotos.map(
                (photo) => Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image: photo,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          petPhotos.remove(photo);
                        });
                      },
                    ),
                  ],
                ),
              ),
              
            ],
          ),
          const SizedBox(height: 16), 
          ElevatedButton.icon(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final List<XFile>? pickedFiles =
                      await picker.pickMultiImage();
                  if (pickedFiles != null && pickedFiles.isNotEmpty) {
                    setState(() {
                      petPhotos.addAll(
                        pickedFiles.map((file) => FileImage(File(file.path))),
                      );
                    });
                  }
                },
                icon: const Icon(Icons.add, size: 30),
                label: const Text('Adicionar Fotos do Pet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  iconColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
            items:
                ['Cachorro', 'Gato']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (val) => setState(() => especie = val),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Porte'),
            value: porte,
            items:
                ['Pequeno', 'Médio', 'Grande']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (val) => setState(() => porte = val),
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Idade'),
            value: idade,
            items:
                ['Filhote', 'Adulto', 'Idoso']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (val) => setState(() => idade = val),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          SingleSelectToggle(
            selectedOption: sexo,
            options: ['Macho', 'Fêmea'],
            onSelectionChanged: (val) => setState(() => sexo = val), label: 'Sexo',
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
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Sobre',
              border: OutlineInputBorder(),
              hintText: 'Descreva o animal',
              hintStyle: TextStyle(color: Colors.grey),
              floatingLabelBehavior:
                  FloatingLabelBehavior.always, // Mantém o label sempre visível
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final animalData = toAnimalMap(usuarioId: 'ID_DO_USUARIO');
                    print(
                      animalData,
                    ); // Chamada da API para salvar os dados do animal
                  },
                  child: const Text('Salvar dados'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
