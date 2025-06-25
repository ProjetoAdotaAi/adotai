class AddressModel {
  final String id;
  final String cep;
  final String city;
  final String state;
  final String userId;

  AddressModel({
    required this.id,
    required this.cep,
    required this.city,
    required this.state,
    required this.userId,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      cep: json['cep']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cep': cep,
      'city': city,
      'state': state,
      'userId': userId,
    };
  }

  @override
  String toString() {
    return 'AddressModel(id: $id, cep: $cep, city: $city, state: $state, userId: $userId)';
  }
}
