import 'package:adotai/screens/swipe_detector_screen.dart';
import 'package:adotai/widgets/pet/favorite_pets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/home/appbar.dart';
import '../widgets/home/navigation_bar.dart';
import 'protectors_filter.dart';
import 'user_pet_list_screen.dart';
import 'user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;
    bool isOng = user?.isOng ?? false;

    final List<Widget> pages = [
      const SwipeScreen(),
      const ProtectorsFilterWidget(),
      isOng ? const UserPetList() : const FavoritePets(),
      const UserScreen(),
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: pages[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

