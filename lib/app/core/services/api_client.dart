// lib/app/core/services/api_client.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A centralized API client for handling HTTP requests.
///
/// This class configures Dio with a base URL and an interceptor
/// to automatically add the JWT token to protected routes.
class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  // The base URL for the API. For Android emulators, this is typically http://10.0.2.2:3000.
  // For physical devices, it would be the local IP of the machine running the backend.
  static const String _baseUrl = 'http://10.0.2.2:3000';

  factory ApiClient(FlutterSecureStorage secureStorage) {
    final dio = Dio(BaseOptions(baseUrl: _baseUrl));
    return ApiClient._internal(dio, secureStorage);
  }

  ApiClient._internal(this._dio, this._secureStorage) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Retrieve the token from secure storage.
          final token = await _secureStorage.read(key: 'jwt_token');

          // Add the token to the Authorization header if it exists.
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options); // Continue with the request.
        },
        onError: (DioException e, handler) {
          // TODO: Implement robust error handling, e.g., logging, user notification.
          print("API Error: ${e.response?.statusCode} - ${e.message}");
          return handler.next(e); // Continue with the error.
        },
      ),
    );
  }

  /// Provides direct access to the configured Dio instance.
  Dio get dio => _dio;
}
