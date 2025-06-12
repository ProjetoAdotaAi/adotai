import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static final Api _instance = Api._internal();
  factory Api() => _instance;

  final Dio _dio;
  String? _token;

  Api._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: dotenv.env['BASE_URL'] ?? '',
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null && _token!.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        print('API Request: ${options.method} ${options.uri}');
        print('Token usado: $_token');
        handler.next(options);
      },
    ));
  }

  void setToken(String? token) {
    _token = token;
  }

  Future<dynamic> request(
    String path, {
    required String method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: headers,
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode ?? 0;
      final message = e.response?.data['error'] ?? e.message;
      return ApiException(statusCode, message.toString());
    } else {
      return ApiException(0, e.message ?? 'Error');
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
