import 'package:adotai/screens/change_password_screen.dart';
import 'package:adotai/screens/favorite_pets_screen.dart';
import 'package:adotai/screens/user_pet_list_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/user/action_tile.dart';
import '../widgets/user/user_card.dart';
import 'adoption_preferences_screen.dart';
import 'edit_profile_screen.dart';
import 'help_screen.dart';
import 'login_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String name = 'Nome do Usuário';
    final String phone = '45 99999-9999';
    final String instagram = '@instagram';
    final String location = 'Endereço';
    final String description =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vitae pharetra nibh, quis condimentum diam. Pellentesque bibendum nisi imperdiet ante eleifend, ac luctus ipsum aliquam.';
    final String imageUrl = 'assets/images/default_icon.png';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserCard(
                name: name,
                phone: phone,
                instagram: instagram,
                location: location,
                description: description,
                imageUrl: imageUrl,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              ActionTile(
                icon: Icons.filter_alt_outlined,
                label: 'Preferências para Adoção',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdoptionPreferncesScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              ActionTile(
                icon: Icons.pets,
                label: 'Meus Pets',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserPetList()),
                  );
                },
              ),
              const SizedBox(height: 12),
              ActionTile(
                icon: Icons.favorite_border,
                label: 'Meus Favoritos',
                onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Favorite_pets_screen()),
                );
                },
              ),
              const SizedBox(height: 12),
              ActionTile(
                icon: Icons.help_outline,
                label: 'Ajuda',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HelpScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              ActionTile(
                icon: Icons.lock,
                label: 'Alterar Senha',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              ActionTile(
                icon: Icons.exit_to_app,
                label: 'Sair',
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
