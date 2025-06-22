import 'package:adotai/screens/change_password_screen.dart';
import 'package:adotai/screens/favorite_pets_screen.dart';
import 'package:adotai/screens/user_pet_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/user/action_tile.dart';
import '../widgets/user/user_card.dart';
import 'adoption_preferences_screen.dart';
import 'edit_profile_screen.dart';
import 'help_screen.dart';
import 'login_screen.dart';
import '../providers/user_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (userProvider.currentUser == null && userProvider.userId != null) {
        userProvider.loadUser(userProvider.userId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.currentUser;

        if (userProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Nenhum usuário carregado')),
          );
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserCard(
                    name: user.name,
                    phone: user.phone,
                    instagram: user.instagram,
                    location: '${user.address?.city}, ${user.address?.state}',
                    imageUrl: user.profilePicture ?? 'assets/images/default_icon.png',
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
                  if (!user.isOng) ...[
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
                  ],
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
                        MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
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
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
