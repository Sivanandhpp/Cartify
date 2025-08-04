// API Service - Legacy compatibility layer
//
// This file maintains backward compatibility while redirecting to the new
// organized API services structure. New code should use the specific API
// services directly from the api_services folder.

import 'package:http/http.dart' as http;
import 'package:cartify/app/core/index.dart';
import 'api_services/index.dart';

/// Legacy API service for backward compatibility
///
/// @deprecated Use specific API services from api_services folder instead:
/// - AuthApiService for authentication
/// - ProductsApiService for products
/// - CartApiService for cart operations
/// - BaseApiService for generic HTTP operations
class ApiService {
  /// @deprecated Use AuthApiService.isAuthenticated instead
  static bool get isAuthenticated => AuthApiService.isAuthenticated;

  /// @deprecated Use AuthApiService.accessToken instead
  static String? get accessToken => AuthApiService.accessToken;

  /// @deprecated Use BaseApiService.get() instead
  static Future<http.Response> authenticatedGet(String url) async {
    return BaseApiService.get(url);
  }

  /// @deprecated Use BaseApiService.post() instead
  static Future<http.Response> authenticatedPost(
    String url,
    Map<String, dynamic> body,
  ) async {
    return BaseApiService.post(url, body);
  }

  /// @deprecated Use BaseApiService.put() instead
  static Future<http.Response> authenticatedPut(
    String url,
    Map<String, dynamic> body,
  ) async {
    return BaseApiService.put(url, body);
  }

  /// @deprecated Use BaseApiService.delete() instead
  static Future<http.Response> authenticatedDelete(String url) async {
    return BaseApiService.delete(url);
  }

  /// @deprecated Use ProductsApiService.fetchProducts() instead
  static Future<List<Product>> fetchProducts() async {
    return ProductsApiService.fetchProducts();
  }

  /// @deprecated Use ProductsApiService.fetchHotDealsProducts() instead
  static Future<List<Product>> fetchHotDealsProducts({int limit = 10}) async {
    return ProductsApiService.fetchHotDealsProducts(limit: limit);
  }
}
