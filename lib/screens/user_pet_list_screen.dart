import 'package:adotai/screens/pet_register_screen.dart';
import 'package:adotai/widgets/pet/user_pet_card.dart';
import 'package:flutter/material.dart';
import '../apiService/api_service.dart';
import '../model/pet_model.dart';
import '../widgets/home/appbar.dart';


class UserPetList extends StatefulWidget {
  const UserPetList({super.key});

  @override
  State<UserPetList> createState() => _UserPetListState();
}

class _UserPetListState extends State<UserPetList> {
  String filter = 'Disponíveis';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const CustomAppBar(hasBackButton: true,),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Meus Pets', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                       Row(
             children: [
                   ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context, MaterialPageRoute(builder: (_) => PetRegistrationScreen()));
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
                    const SizedBox(width: 22),
                    DropdownButton<String>(
                      value: filter,
                      items: <String>['Disponíveis', 'Adotados', 'Todos']
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            filter = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
           const SizedBox(height: 16),
           Expanded(
              child: FutureBuilder<List<Pet>>(
                future: ApiService.fetchUserPets(),
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






