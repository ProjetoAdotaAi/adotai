import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/interaction_type.dart';
import '../../models/pet_model.dart';
import '../../providers/interaction_provider.dart';
import 'favorite_pet_card.dart';

class FavoritePets extends StatefulWidget {
  const FavoritePets({super.key});

  @override
  State<FavoritePets> createState() => _FavoritePetsState();
}

class _FavoritePetsState extends State<FavoritePets> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InteractionProvider>(context, listen: false)
          .loadUserInteractions(InteractionType.FAVORITED);
    });
  }

  void _showFixedContactDialog(BuildContext context, PetModel pet) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(pet.name),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.message),
            label: const Text('Mandar WhatsApp'),
            onPressed: () {
              final url = 'https://wa.me/5545998328541';
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InteractionProvider>(context);
    final pets = provider.favoritedPets;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
              ? Center(child: Text('Erro: ${provider.errorMessage}'))
              : pets.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 72,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum favorito encontrado',
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adicione pets aos favoritos para encontrá-los aqui!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Meus Favoritos',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: pets.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final pet = pets[index];
                              return GestureDetector(
                                onTap: () => _showFixedContactDialog(context, pet),
                                child: FavoritePetCard(pet: pet),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }
}
