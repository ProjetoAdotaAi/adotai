import 'package:flutter/material.dart';
import '../../models/pet_model.dart';

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
          child: GestureDetector(
            onTap: () {
              // Ação ao clicar no ícone de editar
              print('Editar ${pet.name}');
              // Você pode navegar para uma tela de edição, abrir um modal, etc.
            },
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Icon(Icons.edit, color: Colors.white),
            ),
          ),
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
