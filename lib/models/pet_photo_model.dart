class PetPhotoModel {
  final int id;
  final String url;
  final String publicId;
  final int petId;

  PetPhotoModel({
    required this.id,
    required this.url,
    required this.publicId,
    required this.petId,
  });

  factory PetPhotoModel.fromJson(Map<String, dynamic> json) {
    return PetPhotoModel(
      id: json['id'],
      url: json['url'],
      publicId: json['publicId'],
      petId: json['petId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'publicId': publicId,
      'petId': petId,
    };
  }
}
