import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../widgets/home/appbar.dart';

class ProtectorPage extends StatelessWidget {
  final Map<String, dynamic> protectorData;

  const ProtectorPage({super.key, required this.protectorData});

  @override
  Widget build(BuildContext context) {
    final name = protectorData['protectorName'] ?? 'Nome não disponível';
    final image = protectorData['image'] ?? 'assets/images/default_icon.png';
    final location = protectorData['location'] ?? '';
    final pets = protectorData['pets'] as List<dynamic>? ?? [];

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
                    image,
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
                      Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('ONG de proteção ao animal', style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(height: 4),
                      if (location.isNotEmpty) Text(location),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pets disponíveis para adoção',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: pets.map((pet) {
                final p = pet as PetModel;
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/default_icon.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(p.sex.displayName, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
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
