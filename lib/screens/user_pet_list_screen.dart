import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet_model.dart';
import '../providers/pet_provider.dart';
import '../widgets/pet/user_pet_card.dart';
import 'pet_edit_screen.dart';
import 'pet_register_screen.dart';

class UserPetList extends StatefulWidget {
  final String ownerId;
  const UserPetList({super.key, required this.ownerId});

  @override
  State<UserPetList> createState() => _UserPetListState();
}

class _UserPetListState extends State<UserPetList> {
  late PetProvider petProvider;

  @override
  void initState() {
    super.initState();
    petProvider = Provider.of<PetProvider>(context, listen: false);
    Future.microtask(() => petProvider.loadPetsByOwner(widget.ownerId, reset: true));
  }

  Future<void> _reloadPets() async {
    await petProvider.loadPetsByOwner(widget.ownerId, reset: true);
  }

  void _onEditPet(PetModel pet) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PetEditScreen(pet: pet)),
    );
    if (updated == true) {
      _reloadPets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<PetProvider>(
          builder: (context, petProv, _) {
            final pets = petProv.pets;
            final isLoading = petProv.isLoading;
            final error = petProv.errorMessage;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Meus Pets', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PetRegistrationScreen()),
                    ).then((_) => _reloadPets());
                  },
                  icon: const Icon(Icons.add, size: 30),
                  label: const Text('  Adicionar Pet  '),
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
                if (isLoading && pets.isEmpty)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (error != null)
                  Expanded(child: Center(child: Text('Erro: $error')))
                else if (pets.isEmpty)
                  const Expanded(child: Center(child: Text('Nenhum Pet encontrado.')))
                else
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (!isLoading &&
                            petProv.hasMore &&
                            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent) {
                          petProv.loadPetsByOwner(widget.ownerId);
                          return true;
                        }
                        return false;
                      },
                      child: GridView.builder(
                        itemCount: pets.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          return PetCard(
                            pet: pets[index],
                            onEdit: () => _onEditPet(pets[index]),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
