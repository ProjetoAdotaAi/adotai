import 'pet_photo_model.dart';

enum PetSpecies { DOG, CAT }
enum PetSize { SMALL, MEDIUM, LARGE }
enum PetAge { YOUNG, ADULT, SENIOR }
enum PetSex { MALE, FEMALE }

class PetModel {
  final String? id;
  final String name;
  final PetSpecies species;
  final PetSize size;
  final PetAge age;
  final PetSex sex;
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
      'id': id,
      'name': name,
      'species': species.name,
      'size': size.name,
      'age': age.name,
      'sex': sex.name,
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
      species: PetSpecies.values.firstWhere((e) => e.name == json['species']),
      size: PetSize.values.firstWhere((e) => e.name == json['size']),
      age: PetAge.values.firstWhere((e) => e.name == json['age']),
      sex: PetSex.values.firstWhere((e) => e.name == json['sex']),
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
