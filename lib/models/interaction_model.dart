import 'interaction_type.dart';
import 'pet_model.dart';
import 'user_model.dart';

class InteractionModel {
  final String id;
  final String userId;
  final String petId;
  final InteractionType type;
  final DateTime createdAt;
  final UserModel? user;
  final PetModel? pet;

  InteractionModel({
    required this.id,
    required this.userId,
    required this.petId,
    required this.type,
    required this.createdAt,
    this.user,
    this.pet,
  });

  factory InteractionModel.fromJson(Map<String, dynamic> json) {
    return InteractionModel(
      id: json['id'],
      userId: json['userId'],
      petId: json['petId'],
      type: InteractionType.fromString(json['type']),
      createdAt: DateTime.parse(json['createdAt']),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      pet: json['pet'] != null ? PetModel.fromJson(json['pet']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'petId': petId,
      'type': type.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
