class PetPhotoModel {
  final String? id;
  final String url;
  final String? publicId;
  final String? petId;

  PetPhotoModel({
    this.id,
    required this.url,
    this.publicId,
    this.petId,
  });

  factory PetPhotoModel.fromJson(Map<String, dynamic> json) {
    return PetPhotoModel(
      id: json['id']?.toString(),
      url: json['url']?.toString() ?? '',
      publicId: json['publicId']?.toString(),
      petId: json['petId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'url': url,
      if (publicId != null) 'publicId': publicId,
      if (petId != null) 'petId': petId,
    };
  }
}
