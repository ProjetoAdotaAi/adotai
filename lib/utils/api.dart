import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  final String? baseUrl = dotenv.env['BASE_URL'];

  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Uri getUri(String path) => Uri.parse('$baseUrl$path');

  Future<http.Response> get(String path) async {
    final uri = getUri(path);
    final response = await http.get(uri, headers: _headers());
    _handleErrors(response);
    return response;
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final uri = getUri(path);
    final response = await http.post(
      uri,
      headers: _headers(),
      body: jsonEncode(body),
    );
    _handleErrors(response);
    return response;
  }

  Future<http.Response> put(String path, Map<String, dynamic> body) async {
    final uri = getUri(path);
    final response = await http.put(
      uri,
      headers: _headers(),
      body: jsonEncode(body),
    );
    _handleErrors(response);
    return response;
  }

  Future<http.Response> patch(String path, Map<String, dynamic> body) async {
    final uri = getUri(path);
    final response = await http.patch(
      uri,
      headers: _headers(),
      body: jsonEncode(body),
    );
    _handleErrors(response);
    return response;
  }

  Future<http.Response> delete(String path) async {
    final uri = getUri(path);
    final response = await http.delete(uri, headers: _headers());
    _handleErrors(response);
    return response;
  }

  Map<String, String> _headers() {
    final headers = {
      "Content-Type": "application/json",
    };

    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  void _handleErrors(http.Response response) {
    if (response.statusCode >= 400) {
      final error = jsonDecode(response.body)['error'] ?? 'Erro desconhecido';
      throw ApiException(response.statusCode, error);
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException: $statusCode - $message';
}
