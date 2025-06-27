import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/pet_model.dart';
import '../widgets/home/appbar.dart';
import '../providers/pet_provider.dart';

class ProtectorPage extends StatefulWidget {
  final Map<String, dynamic> protectorData;

  const ProtectorPage({super.key, required this.protectorData});

  @override
  State<ProtectorPage> createState() => _ProtectorPageState();
}

class _ProtectorPageState extends State<ProtectorPage> {
  @override
  void initState() {
    super.initState();
    final ownerId = widget.protectorData['ownerId'] as String?;
    if (ownerId != null) {
      final petProvider = Provider.of<PetProvider>(context, listen: false);
      petProvider.loadPetsByOwner(ownerId, reset: true);
    }
  }

  void _showContactDialog(String phone) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Contato'),
          content: Text('Telefone: $phone'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final url = Uri.parse('https://wa.me/$phone');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('WhatsApp'),
            ),
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: phone));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Número copiado')),
                );
              },
              child: const Text('Copiar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.protectorData['protectorName'] ?? 'Nome não disponível';
    final image = widget.protectorData['image'] ?? 'assets/images/default_icon.png';
    final location = widget.protectorData['location'] ?? '';
    final phone = widget.protectorData['phone'] ?? '';

    final petProvider = Provider.of<PetProvider>(context);
    final pets = petProvider.pets;

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
                  child: image.startsWith('http')
                      ? Image.network(image, width: 100, height: 100, fit: BoxFit.cover)
                      : Image.asset(image, width: 100, height: 100, fit: BoxFit.cover),
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
            if (petProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (pets.isEmpty)
              Center(
                child: Text(
                  'Nenhum pet disponível',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
                ),
              )
            else
              Column(
                children: pets.map((pet) {
                  final photoUrl = pet.photos.isNotEmpty ? pet.photos.first.url : null;

                  return GestureDetector(
                    onTap: () {
                      if (phone != null && phone.toString().isNotEmpty) {
                        _showContactDialog(phone.toString());
                      }
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
                              child: photoUrl != null && photoUrl.isNotEmpty
                                  ? Image.network(
                                      photoUrl,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        'assets/images/default_icon.png',
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
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
                                Text(pet.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text(pet.sex.displayName, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
