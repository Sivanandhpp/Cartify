import 'dart:convert';
import 'package:http/http.dart' as http;
import '../log_service.dart';
import '../secure_storage_service.dart';

/// Base API service providing common HTTP functionality
///
/// This service handles the core HTTP operations with authentication,
/// logging, and error handling. All specific API services should extend
/// or use this base service.
class BaseApiService {
  static const Duration _defaultTimeout = Duration(seconds: 30);

  static final SecureStorageService _secureStorage = SecureStorageService();

  /// Get standard headers with optional authentication
  static Map<String, String> getHeaders({bool includeAuth = true}) {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (includeAuth) {
      final authHeader = _secureStorage.getAuthorizationHeader();
      if (authHeader != null) {
        headers['Authorization'] = authHeader;
      }
    }

    return headers;
  }

  /// Get headers with custom API key (for external APIs)
  static Map<String, String> getCustomHeaders(
    Map<String, String> customHeaders,
  ) {
    return {'Content-Type': 'application/json', ...customHeaders};
  }

  /// Make authenticated GET request
  static Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final requestHeaders = headers ?? getHeaders();
    LogService.apiRequest('GET', url, requestHeaders);

    final response = await http
        .get(Uri.parse(url), headers: requestHeaders)
        .timeout(timeout ?? _defaultTimeout);

    LogService.apiResponse('GET', url, response.statusCode, response.body);
    return response;
  }

  /// Make authenticated POST request
  static Future<http.Response> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final requestHeaders = headers ?? getHeaders();
    final jsonBody = json.encode(body);

    LogService.apiRequest('POST', url, requestHeaders, jsonBody);

    final response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: jsonBody)
        .timeout(timeout ?? _defaultTimeout);

    LogService.apiResponse('POST', url, response.statusCode, response.body);
    return response;
  }

  /// Make authenticated PUT request
  static Future<http.Response> put(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final requestHeaders = headers ?? getHeaders();
    final jsonBody = json.encode(body);

    LogService.apiRequest('PUT', url, requestHeaders, jsonBody);

    final response = await http
        .put(Uri.parse(url), headers: requestHeaders, body: jsonBody)
        .timeout(timeout ?? _defaultTimeout);

    LogService.apiResponse('PUT', url, response.statusCode, response.body);
    return response;
  }

  /// Make authenticated DELETE request
  static Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final requestHeaders = headers ?? getHeaders();
    LogService.apiRequest('DELETE', url, requestHeaders);

    final response = await http
        .delete(Uri.parse(url), headers: requestHeaders)
        .timeout(timeout ?? _defaultTimeout);

    LogService.apiResponse('DELETE', url, response.statusCode, response.body);
    return response;
  }

  /// Make unauthenticated request (for public APIs)
  static Future<http.Response> publicGet(
    String url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final requestHeaders = headers ?? getHeaders(includeAuth: false);
    LogService.apiRequest('GET', url, requestHeaders);

    final response = await http
        .get(Uri.parse(url), headers: requestHeaders)
        .timeout(timeout ?? _defaultTimeout);

    LogService.apiResponse('GET', url, response.statusCode, response.body);
    return response;
  }

  /// Make unauthenticated POST request (for login, registration, etc.)
  static Future<http.Response> publicPost(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final requestHeaders = headers ?? getHeaders(includeAuth: false);
    final jsonBody = json.encode(body);

    LogService.apiRequest('POST', url, requestHeaders, jsonBody);

    final response = await http
        .post(Uri.parse(url), headers: requestHeaders, body: jsonBody)
        .timeout(timeout ?? _defaultTimeout);

    LogService.apiResponse('POST', url, response.statusCode, response.body);
    return response;
  }
}
