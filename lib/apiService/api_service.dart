import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pet_model.dart';

class ApiService {
  static Future<List<Pet>> fetchFavorites() async {
    await Future.delayed(const Duration(seconds: 1)); // simula requisição

    return [
      Pet(
        name: 'Bob',
        imageUrl: 'https://static.ndmais.com.br/2024/07/cachorro-com-penteado-diferente-ok-590x800.jpg',
      ),
      Pet(
        name: 'Tabaco',
        imageUrl: 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSbQEzsLk0grhbQX-vAqH3wfhAgL95D8GmxuJ9bdtl3XFsS9vFr',
      ),
      Pet(
        name: 'Tobias',
        imageUrl: 'https://stories.bnews.com.br/motivos-para-o-vira-lata-caramelo-se-tornar-patrimonio-nacional-brasileiro/assets/21.jpeg',
      ),
      Pet(
        name: 'Fiapo',
        imageUrl: 'https://d3grcwqt8cmtlx.cloudfront.net/medium_FIAPO_273d4b746a.jpeg',
      ),
    ];
  }
}
