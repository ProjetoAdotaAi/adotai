import 'package:flutter/material.dart';
import '../apiService/api_service.dart';
import '../model/pet_model.dart';
import '../theme/app_theme.dart';
import '../widgets/home/appbar.dart';
import '../widgets/home/navigation_bar.dart';
import '../widgets/pet/pet_card.dart';

class UserPetList extends StatefulWidget {
  const UserPetList({super.key});

  @override
  State<UserPetList> createState() => _UserPetListState();
}

class _UserPetListState extends State<UserPetList> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 4;
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Meus Favoritos', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
           Expanded(
              child: FutureBuilder<List<Pet>>(
                future: ApiService.fetchFavorites(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum favorito encontrado.'));
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
                      return PetCard(pet: pets[index]);
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
