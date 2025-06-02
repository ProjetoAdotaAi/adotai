import 'package:adotai/screens/swipe_detector_screen.dart';
import 'package:adotai/widgets/pet/favorite_pets.dart';
import 'package:flutter/material.dart';
import '../widgets/home/appbar.dart';
import '../widgets/home/navigation_bar.dart';
import 'protectors_filter.dart';
import 'user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    SwipeScreen(),
    ProtectorsFilterWidget(),
    FavoritePets(),
    UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _pages[_currentIndex],
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
