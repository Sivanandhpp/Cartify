/// HTTP API Service for Cartify
/// Handles all HTTP requests using Dio with proper error handling,
/// authentication, and request/response interceptors

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import '../config/api_endpoints.dart';
import 'log_service.dart';
import 'error_service.dart';
import 'secure_storage_service.dart';

/// HTTP API service using Dio
class ApiService extends GetxService {
  late final Dio _dio;
  final SecureStorageService _storageService = SecureStorageService();

  /// Initialize API service with Dio configuration
  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeDio();
  }

  /// Initialize Dio with base configuration and interceptors
  Future<void> _initializeDio() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_createAuthInterceptor());
    _dio.interceptors.add(_createLoggingInterceptor());
    _dio.interceptors.add(_createErrorInterceptor());
  }

  /// Create authentication interceptor for automatic token handling
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip auth for public endpoints
        if (_isPublicEndpoint(options.path)) {
          return handler.next(options);
        }

        // Add access token for protected routes
        final accessToken = _storageService.getAccessToken();
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle token refresh on 401 error
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshTokenIfNeeded();
          if (refreshed) {
            // Retry the original request with new token
            final newToken = _storageService.getAccessToken();
            error.requestOptions.headers['Authorization'] = 'Bearer $newToken';

            try {
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
        }
        handler.next(error);
      },
    );
  }

  /// Create logging interceptor for debugging
  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        LogService.debug('API Request: ${options.method} ${options.path}');
        LogService.debug('Headers: ${options.headers}');
        if (options.data != null) {
          LogService.debug('Body: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        LogService.debug(
          'API Response: ${response.statusCode} ${response.requestOptions.path}',
        );
        handler.next(response);
      },
      onError: (error, handler) {
        LogService.error('API Error: ${error.message}');
        if (error.response != null) {
          LogService.error('Error Response: ${error.response?.data}');
        }
        handler.next(error);
      },
    );
  }

  /// Create error interceptor for centralized error handling
  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        ErrorService.instance.handleApiError(
          error.message ?? 'Unknown API error',
          endpoint: error.requestOptions.path,
          statusCode: error.response?.statusCode,
          response: error.response?.data,
        );
        handler.next(error);
      },
    );
  }

  /// Check if endpoint is public (doesn't require authentication)
  bool _isPublicEndpoint(String path) {
    final publicPaths = [
      '/auth/request-otp',
      '/auth/verify-otp',
      '/dashboard',
      '/categories',
      '/products',
    ];

    return publicPaths.any((publicPath) => path.startsWith(publicPath));
  }

  /// Refresh access token using refresh token
  Future<bool> _refreshTokenIfNeeded() async {
    try {
      final refreshToken = _storageService.getRefreshToken();
      if (refreshToken == null) {
        LogService.warning('No refresh token available');
        return false;
      }

      final response = await _dio.get(
        '/auth/refresh',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _storageService.storeAccessToken(data['accessToken']);
        await _storageService.storeRefreshToken(data['refreshToken']);
        LogService.info('Token refreshed successfully');
        return true;
      }
    } catch (e) {
      LogService.error('Failed to refresh token: $e');
      // Clear stored tokens on refresh failure
      await _storageService.clearAuthData();
    }
    return false;
  }

  /// Make GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      LogService.error('GET request failed: $path - $e');
      rethrow;
    }
  }

  /// Make POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      LogService.error('POST request failed: $path - $e');
      rethrow;
    }
  }

  /// Make PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      LogService.error('PATCH request failed: $path - $e');
      rethrow;
    }
  }

  /// Make DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      LogService.error('DELETE request failed: $path - $e');
      rethrow;
    }
  }

  /// Upload file using multipart/form-data
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    Options? options,
  }) async {
    try {
      final formData = FormData();

      // Add file
      formData.files.add(
        MapEntry(fieldName, await MultipartFile.fromFile(filePath)),
      );

      // Add additional data if provided
      if (additionalData != null) {
        additionalData.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      return await _dio.post<T>(path, data: formData, options: options);
    } on DioException catch (e) {
      LogService.error('File upload failed: $path - $e');
      rethrow;
    }
  }

  /// Upload multiple files
  Future<Response<T>> uploadFiles<T>(
    String path,
    List<String> filePaths, {
    String fieldName = 'files',
    Map<String, dynamic>? additionalData,
    Options? options,
  }) async {
    try {
      final formData = FormData();

      // Add files
      for (final filePath in filePaths) {
        formData.files.add(
          MapEntry(fieldName, await MultipartFile.fromFile(filePath)),
        );
      }

      // Add additional data if provided
      if (additionalData != null) {
        additionalData.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      return await _dio.post<T>(path, data: formData, options: options);
    } on DioException catch (e) {
      LogService.error('Files upload failed: $path - $e');
      rethrow;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final accessToken = _storageService.getAccessToken();
    return accessToken != null;
  }

  /// Get current access token
  Future<String?> getAccessToken() async {
    return _storageService.getAccessToken();
  }

  /// Clear all authentication data
  Future<void> clearAuth() async {
    await _storageService.clearAuthData();
  }
}
