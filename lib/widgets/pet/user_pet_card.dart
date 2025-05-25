import 'package:flutter/material.dart';
import '../../models/pet_model.dart';

class PetCard extends StatelessWidget {
  final PetModel pet;
  final VoidCallback? onEdit;

  const PetCard({super.key, required this.pet, this.onEdit});

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
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.edit, color: Colors.white),
              ),
            ),
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
