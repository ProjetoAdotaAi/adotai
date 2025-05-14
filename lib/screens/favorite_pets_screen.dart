import 'package:flutter/material.dart';
import '../widgets/home/appbar.dart';
import '../widgets/pet/favorite_pets.dart';

class Favorite_pets_screen extends StatefulWidget {
  const Favorite_pets_screen({super.key});

  @override
  State<Favorite_pets_screen> createState() => _Favorite_pets_screenState();
}

class _Favorite_pets_screenState extends State<Favorite_pets_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: const CustomAppBar(hasBackButton: true,),
    body: FavoritePets(),
    );
  }
}
