import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isOng;

  const CustomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.isOng,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = isOng
        ? [
            Icons.person_search_outlined,
            Icons.pets,
            Icons.person_2_outlined,
          ]
        : [
            Icons.pets,
            Icons.person_search_outlined,
            Icons.favorite_border,
            Icons.person_2_outlined,
          ];

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
          children: List.generate(icons.length, (index) {
            return IconButton(
              icon: Icon(icons[index], size: 28),
              onPressed: () => onTap(index),
              color: currentIndex == index ? Colors.orange : Colors.black,
            );
          }),
        ),
      ),
    );
  }
}
