class UserModel {
  final String firebaseId;
  final String name;
  final String phone;
  final String instagram;
  final String email;
  final String password;
  final String cep;
  final String city;
  final String state;
  final bool isOng;

  UserModel({
    required this.firebaseId,
    required this.name,
    required this.phone,
    required this.instagram,
    required this.email,
    required this.password,
    required this.cep,
    required this.city,
    required this.state,
    required this.isOng,
  });

  Map<String, dynamic> toJson() {
    return {
      'firebaseId': firebaseId,
      'name': name,
      'phone': phone,
      'instagram': instagram,
      'email': email,
      'password': password,
      'address': {'cep': cep, 'city': city, 'state': state},
      'isOng': isOng,
    };
  }
}
