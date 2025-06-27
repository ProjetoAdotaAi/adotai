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
      if (id != null) 'id': id,
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
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      species: PetSpecies.values.firstWhere((e) => e.name == json['species'], orElse: () => PetSpecies.DOG),
      size: PetSize.values.firstWhere((e) => e.name == json['size'], orElse: () => PetSize.MEDIUM),
      age: PetAge.values.firstWhere((e) => e.name == json['age'], orElse: () => PetAge.ADULT),
      sex: PetSex.values.firstWhere((e) => e.name == json['sex'], orElse: () => PetSex.MALE),
      castrated: json['castrated'] == true,
      dewormed: json['dewormed'] == true,
      vaccinated: json['vaccinated'] == true,
      description: json['description']?.toString() ?? '',
      adopted: json['adopted'] == true,
      ownerId: json['ownerId']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      photos: (json['photos'] is List)
          ? (json['photos'] as List).map((p) {
              if (p is String) {
                return PetPhotoModel(url: p);
              } else if (p is Map<String, dynamic>) {
                return PetPhotoModel.fromJson(p);
              } else {
                return PetPhotoModel(url: '');
              }
            }).toList()
          : [],
    );
  }
}

extension PetSpeciesExt on PetSpecies {
  String get displayName {
    switch (this) {
      case PetSpecies.DOG:
        return 'Cachorro';
      case PetSpecies.CAT:
        return 'Gato';
    }
  }
}

extension PetSizeExt on PetSize {
  String get displayName {
    switch (this) {
      case PetSize.SMALL:
        return 'Pequeno';
      case PetSize.MEDIUM:
        return 'Médio';
      case PetSize.LARGE:
        return 'Grande';
    }
  }
}

extension PetAgeExt on PetAge {
  String get displayName {
    switch (this) {
      case PetAge.YOUNG:
        return 'Filhote';
      case PetAge.ADULT:
        return 'Adulto';
      case PetAge.SENIOR:
        return 'Idoso';
    }
  }
}

extension PetSexExt on PetSex {
  String get displayName {
    switch (this) {
      case PetSex.MALE:
        return 'Macho';
      case PetSex.FEMALE:
        return 'Fêmea';
    }
  }
}
