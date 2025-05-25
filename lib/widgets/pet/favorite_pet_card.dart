import 'package:flutter/material.dart';
import '../../models/pet_model.dart';

class FavoritePetCard extends StatelessWidget {
  final PetModel pet;

  const FavoritePetCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final imageUrl = pet.photos.isNotEmpty ? pet.photos.first.url : '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey,
              alignment: Alignment.center,
              child: const Icon(Icons.pets, size: 40, color: Colors.white70),
            ),
          ),
          const Positioned(
            top: 8,
            right: 8,
            child: Icon(Icons.star, color: Colors.orangeAccent),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            child: Text(
              pet.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 3, color: Colors.black)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
