import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    Center(child: Text('Pets')),
    Center(child: Text('Buscar')),
    Center(child: Text('Favoritos')),
    Center(child: Text('Perfil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey[300]!, width: 3),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(0, -1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.pets, size: 28),
              onPressed: () => onTap(0),
              color: currentIndex == 0 ? Colors.orange : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.person_search_outlined, size: 28),
              onPressed: () => onTap(1),
              color: currentIndex == 1 ? Colors.orange : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border, size: 28),
              onPressed: () => onTap(2),
              color: currentIndex == 2 ? Colors.orange : Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.person_2_outlined, size: 28),
              onPressed: () => onTap(3),
              color: currentIndex == 3 ? Colors.orange : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
