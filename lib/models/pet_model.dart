import 'pet_photo_model.dart';

class PetModel {
  final int? id;
  final String name;
  final String species;
  final String size;
  final int age;
  final String sex;
  final bool castrated;
  final bool dewormed;
  final bool vaccinated;
  final String description;
  final bool adopted;
  final String ownerId;
  final DateTime createdAt;
  final List<PetPhotoModel> photos;

  PetModel({
    this.id,
    required this.name,
    required this.species,
    required this.size,
    required this.age,
    required this.sex,
    required this.castrated,
    required this.dewormed,
    required this.vaccinated,
    required this.description,
    required this.adopted,
    required this.ownerId,
    required this.createdAt,
    required this.photos,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'species': species,
      'size': size,
      'age': age,
      'sex': sex,
      'castrated': castrated,
      'dewormed': dewormed,
      'vaccinated': vaccinated,
      'description': description,
      'adopted': adopted,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
      'photos': photos.map((p) => p.toJson()).toList(),
    };
  }

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      size: json['size'],
      age: json['age'],
      sex: json['sex'],
      castrated: json['castrated'],
      dewormed: json['dewormed'],
      vaccinated: json['vaccinated'],
      description: json['description'],
      adopted: json['adopted'],
      ownerId: json['ownerId'],
      createdAt: DateTime.parse(json['createdAt']),
      photos: (json['photos'] as List).map((p) => PetPhotoModel.fromJson(p)).toList(),
    );
  }
}
