// lib/app/core/services/api_client.dart

import 'package:cartify/app/core/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// A centralized API client for handling HTTP requests.
///
/// This class configures Dio with a base URL and an interceptor
/// to automatically add the JWT token to protected routes and handle
/// token refreshing.
class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static const String _baseUrl = 'http://10.0.2.2:3000';

  factory ApiClient(FlutterSecureStorage secureStorage) {
    final dio = Dio(BaseOptions(baseUrl: _baseUrl));
    return ApiClient._internal(dio, secureStorage);
  }

  ApiClient._internal(this._dio, this._secureStorage) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // For endpoints other than refresh, use the access token.
          if (options.path != '/auth/refresh') {
            final token = await _secureStorage.read(key: 'access_token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Don't handle 401 errors for authentication endpoints
          // as they should be handled by the calling service
          final AuthenticationService authService =
              Get.find<AuthenticationService>();

          final authenticationEndpoints = [
            '/auth/request-otp',
            '/auth/verify-otp',
          ];

          if (e.response?.statusCode == 401 &&
              authenticationEndpoints.contains(e.requestOptions.path)) {
            // Let the authentication service handle the error
            return handler.next(e);
          }

          if (e.response?.statusCode == 401) {
            final refreshToken = await _secureStorage.read(
              key: 'refresh_token',
            );

            // If no refresh token or the failed request was the refresh endpoint, logout.
            if (refreshToken == null ||
                e.requestOptions.path == '/auth/refresh') {
              await authService.logout();
              return handler.next(e);
            }

            try {
              // Create a new Dio instance for the refresh token request to avoid interceptor loop.
              final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
              final refreshResponse = await refreshDio.get(
                '/auth/refresh',
                options: Options(
                  headers: {'Authorization': 'Bearer $refreshToken'},
                ),
              );

              if (refreshResponse.statusCode == 200) {
                // Save new tokens.
                final newAccessToken = refreshResponse.data['accessToken'];
                final newRefreshToken = refreshResponse.data['refreshToken'];
                await _secureStorage.write(
                  key: 'access_token',
                  value: newAccessToken,
                );
                await _secureStorage.write(
                  key: 'refresh_token',
                  value: newRefreshToken,
                );

                // Retry the original request with the new access token.
                final originalRequestOptions = e.requestOptions;
                originalRequestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';

                // Use the original Dio instance to retry the request.
                final response = await _dio.fetch(originalRequestOptions);
                return handler.resolve(response);
              }
            } catch (refreshError) {
              // If refresh fails, logout the user.
              await authService.logout();
              // It's important to return an error so the caller knows the request failed.
              return handler.next(
                DioException(
                  requestOptions: e.requestOptions,
                  error: 'Session expired. Please log in again.',
                ),
              );
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  /// Provides direct access to the configured Dio instance.
  Dio get dio => _dio;
}
