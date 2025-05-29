import '../models/pet_model.dart';
import '../models/pet_photo_model.dart';

class PetService {
  static Future<List<PetModel>> fetchFavorites() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      PetModel(
        id: 1,
        name: 'Bob',
        species: 'Dog',
        size: 'Medium',
        age: 3,
        sex: 'Male',
        castrated: true,
        dewormed: true,
        vaccinated: true,
        description: 'Friendly dog',
        adopted: false,
        ownerId: 1,
        createdAt: DateTime.now(),
        photos: [
          PetPhotoModel(
            id: 1,
            url: 'https://static.ndmais.com.br/2024/07/cachorro-com-penteado-diferente-ok-590x800.jpg',
            publicId: 'photo1',
            petId: 1,
          )
        ],
      ),
      PetModel(
        id: 2,
        name: 'Tabaco',
        species: 'Dog',
        size: 'Large',
        age: 5,
        sex: 'Male',
        castrated: false,
        dewormed: true,
        vaccinated: false,
        description: 'Energetic and playful',
        adopted: false,
        ownerId: 1,
        createdAt: DateTime.now(),
        photos: [
          PetPhotoModel(
            id: 2,
            url: 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSbQEzsLk0grhbQX-vAqH3wfhAgL95D8GmxuJ9bdtl3XFsS9vFr',
            publicId: 'photo2',
            petId: 2,
          )
        ],
      ),
      PetModel(
        id: 3,
        name: 'Tobias',
        species: 'Dog',
        size: 'Small',
        age: 2,
        sex: 'Male',
        castrated: true,
        dewormed: true,
        vaccinated: true,
        description: 'Calm and loving',
        adopted: false,
        ownerId: 2,
        createdAt: DateTime.now(),
        photos: [
          PetPhotoModel(
            id: 3,
            url: 'https://i0.statig.com.br/bancodeimagens/78/pt/gs/78ptgsfeddfh638dkkzya5p3y.jpg',
            publicId: 'photo3',
            petId: 3,
          )
        ],
      ),
      PetModel(
        id: 4,
        name: 'Fiapo',
        species: 'Cat',
        size: 'Small',
        age: 4,
        sex: 'Female',
        castrated: true,
        dewormed: false,
        vaccinated: true,
        description: 'Quiet and affectionate',
        adopted: false,
        ownerId: 2,
        createdAt: DateTime.now(),
        photos: [
          PetPhotoModel(
            id: 4,
            url: 'https://d3grcwqt8cmtlx.cloudfront.net/medium_FIAPO_273d4b746a.jpeg',
            publicId: 'photo4',
            petId: 4,
          )
        ],
      ),
    ];
  }

  static Future<List<PetModel>> fetchUserPets() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      PetModel(
        id: 5,
        name: 'Junior',
        species: 'Dog',
        size: 'Large',
        age: 6,
        sex: 'Male',
        castrated: true,
        dewormed: true,
        vaccinated: true,
        description: 'Loyal and protective',
        adopted: false,
        ownerId: 3,
        createdAt: DateTime.now(),
        photos: [
          PetPhotoModel(
            id: 5,
            url: 'https://i.pinimg.com/736x/c6/f5/e3/c6f5e3f6538aba58a1c0b94592f0e4b0.jpg',
            publicId: 'photo5',
            petId: 5,
          )
        ],
      ),
      PetModel(
        id: 6,
        name: 'Jamelão',
        species: 'Dog',
        size: 'Medium',
        age: 3,
        sex: 'Male',
        castrated: false,
        dewormed: true,
        vaccinated: true,
        description: 'Energetic and friendly',
        adopted: false,
        ownerId: 3,
        createdAt: DateTime.now(),
        photos: [
          PetPhotoModel(
            id: 6,
            url: 'https://cdn0.peritoanimal.com.br/pt/razas/5/3/7/vira-lata-caramelo_735_0_orig.jpg',
            publicId: 'photo6',
            petId: 6,
          )
        ],
      ),
      PetModel(
        id: 7,
        name: 'Washington',
        species: 'Dog',
        size: 'Medium',
        age: 4,
        sex: 'Male',
        castrated: true,
        dewormed: true,
        vaccinated: false,
        description: 'Calm and gentle',
        adopted: false,
        ownerId: 4,
        createdAt: DateTime.now(),
        photos: [
          PetPhotoModel(
            id: 7,
            url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnfBXWWZRNR2R4KGNkAK6-WVPznB28FWG8Hw&s',
            publicId: 'photo7',
            petId: 7,
          )
        ],
      ),
      PetModel(
        id: 8,
        name: 'Belinha',
        species: 'Dog',
        size: 'Small',
        age: 5,
        sex: 'Female',
        castrated: true,
        dewormed: true,
        vaccinated: true,
        description: 'Sweet and playful',
        adopted: false,
        ownerId: 4,
        createdAt: DateTime.now(),
        photos: [
          PetPhotoModel(
            id: 8,
            url: 'https://www.doglife.com.br/blog/assets/post/cachorro-reativo-6628fad48fb9841241484f8a/cachorro-reativo.jpg',
            publicId: 'photo8',
            petId: 8,
          )
        ],
      ),
    ];
  }
}
