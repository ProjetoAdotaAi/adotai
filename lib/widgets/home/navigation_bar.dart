import 'package:flutter/material.dart';

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
