import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet_model.dart';

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
        imageUrl: 'https://i0.statig.com.br/bancodeimagens/78/pt/gs/78ptgsfeddfh638dkkzya5p3y.jpg',
      ),
      Pet(
        name: 'Fiapo',
        imageUrl: 'https://d3grcwqt8cmtlx.cloudfront.net/medium_FIAPO_273d4b746a.jpeg',
      ),
    ];
  }

  static Future<List<Pet>> fetchUserPets() async {
    await Future.delayed(const Duration(seconds: 1)); // simula requisição

    return [
      Pet(
        name: 'Junior',
        imageUrl: 'https://i.pinimg.com/736x/c6/f5/e3/c6f5e3f6538aba58a1c0b94592f0e4b0.jpg',
      ),
      Pet(
        name: 'Jamelão',
        imageUrl: 'https://cdn0.peritoanimal.com.br/pt/razas/5/3/7/vira-lata-caramelo_735_0_orig.jpg',
      ),
      Pet(
        name: 'Washington',
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnfBXWWZRNR2R4KGNkAK6-WVPznB28FWG8Hw&s',
      ),
      Pet(
        name: 'Belinha',
        imageUrl: 'https://www.doglife.com.br/blog/assets/post/cachorro-reativo-6628fad48fb9841241484f8a/cachorro-reativo.jpg',
      ),
    ];
  }

}

