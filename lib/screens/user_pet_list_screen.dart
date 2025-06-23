import 'package:adotai/screens/pet_register_screen.dart';
import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../services/pet_service.dart';
import '../widgets/pet/user_pet_card.dart';
import 'pet_edit_screen.dart';

class UserPetList extends StatefulWidget {
  const UserPetList({super.key});

  @override
  State<UserPetList> createState() => _UserPetListState();
}

class _UserPetListState extends State<UserPetList> {
  final PetService petService = PetService();
  late Future<List<PetModel>> futurePets;

  @override
  void initState() {
    super.initState();
    futurePets = petService.getPets();
  }

  Future<void> _reloadPets() async {
    setState(() {
      futurePets = petService.getPets();
    });
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
        child: Column(
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
            Expanded(
              child: FutureBuilder<List<PetModel>>(
                future: futurePets,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum Pet encontrado.'));
                  }

                  final pets = snapshot.data!;

                  return GridView.builder(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
