import 'adress_model.dart';
import 'pet_model.dart';

class UserModel {
  final String id;
  final String firebaseId;
  final String name;
  final String phone;
  final String instagram;
  final String email;
  final String password;
  final AddressModel? address;  
  final bool isOng;
  final String? profilePicture;
  final List<PetModel> pets;

  UserModel({
    required this.id,
    required this.firebaseId,
    required this.name,
    required this.phone,
    required this.instagram,
    required this.email,
    required this.password,
    this.address,
    required this.isOng,
    this.profilePicture,
    required this.pets,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      firebaseId: json['firebaseId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      instagram: json['instagram']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      address: json['address'] != null ? AddressModel.fromJson(json['address']) : null,
      isOng: json['isOng'] is bool 
        ? json['isOng'] 
        : (json['isOng']?.toString().toLowerCase() == 'true'),
      profilePicture: json['profilePicture']?.toString(),
      pets: json['pets'] != null
          ? List<PetModel>.from(
              (json['pets'] as List).map((x) => PetModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firebaseId': firebaseId,
      'name': name,
      'phone': phone,
      'instagram': instagram,
      'email': email,
      'password': password,
      'address': address?.toJson(),
      'isOng': isOng,
      'profilePicture': profilePicture,
      'pets': pets.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, firebaseId: $firebaseId, name: $name, phone: $phone, instagram: $instagram, email: $email, isOng: $isOng, profilePicture: $profilePicture, address: ${address.toString()}, pets: ${pets.length})';
  }
}
