import 'package:flutter/material.dart';
import '../widgets/home/appbar.dart';

class ProtectorPage extends StatelessWidget {
  const ProtectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(text: 'Patas do Bem');
    final _phoneController = TextEditingController(text: '(11) 98765-4321');
    final _instagramController = TextEditingController(text: '@patasdobem_oficial');
    final _locationController = TextEditingController(text: 'Rua das Esperanças, 123, Toledo - PR');
    final _descriptionController = TextEditingController(
      text: 'A Patas do Bem é uma ONG dedicada ao resgate, cuidado e adoção responsável de animais em situação de vulnerabilidade. Nossa missão é transformar vidas proporcionando um lar amoroso para cães e gatos abandonados, além de conscientizar a sociedade sobre a importância da proteção animal.',
    );

    final availablePets = [
      {'name': 'Bob', 'subtitle': 'Macho', 'image': 'assets/images/default_icon.png'},
      {'name': 'Tabaco', 'subtitle': 'Macho', 'image': 'assets/images/default_icon.png'},
      {'name': 'Tobias', 'subtitle': 'Cachorro', 'image': 'assets/images/default_icon.png'},
      {'name': 'Fiapo', 'subtitle': '3 meses', 'image': 'assets/images/default_icon.png'},
    ];

    return Scaffold(
      appBar: CustomAppBar(hasBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/default_icon.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_nameController.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('ONG de proteção ao animal', style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(height: 4),
                      Text(_phoneController.text),
                      Text(_locationController.text),
                      Text(_instagramController.text),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _descriptionController.text,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Disponíveis para adoção',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: availablePets.map((pet) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/animal-details');
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              pet['image']!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pet['name']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(pet['subtitle']!, style: const TextStyle(fontSize: 14)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
