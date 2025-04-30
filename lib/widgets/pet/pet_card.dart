import 'package:flutter/material.dart';
import '../../model/pet_model.dart';

class PetCard extends StatelessWidget {
  final Pet pet;

  const PetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            pet.imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Icon(Icons.star, color: Colors.orangeAccent),
        ),
        Positioned(
          left: 8,
          bottom: 8,
          child: Text(
            pet.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 3, color: Colors.black)],
            ),
          ),
        ),
      ],
    );
  }
}
