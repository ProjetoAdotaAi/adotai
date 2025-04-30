import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pet_model.dart';


class Pet {
  final String name;
  final String imageUrl;

  Pet({required this.name, required this.imageUrl});

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}