class AddressModel {
  final int id;
  final String cep;
  final String city;
  final String state;
  final int userId;

  AddressModel({
    required this.id,
    required this.cep,
    required this.city,
    required this.state,
    required this.userId,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      cep: json['cep'],
      city: json['city'],
      state: json['state'],
      userId: json['userId'],
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
}
