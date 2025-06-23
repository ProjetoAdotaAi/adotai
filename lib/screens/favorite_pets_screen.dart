import 'package:flutter/material.dart';
import '../widgets/home/appbar.dart';
import '../widgets/pet/favorite_pets.dart';

class FavoritePetsScreen extends StatelessWidget {
  const FavoritePetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(hasBackButton: true),
      body: FavoritePets(),
    );
  }
}
