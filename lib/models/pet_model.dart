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
    final map = {
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
    };

    map['createdAt'] = createdAt.toIso8601String();
  
    if (photos.isNotEmpty) {
      map['photos'] = photos.map((p) => p.url).toList();
    } else {
      map['photos'] = [];
    }

    return map;
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
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      photos: (json['photos'] as List).map((p) {
        if (p is String) {
          return PetPhotoModel(url: p);
        } else {
          return PetPhotoModel.fromJson(p);
        }
      }).toList(),
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
