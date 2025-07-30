import 'dart:convert';
import 'package:cartify/app/core/index.dart';
import 'package:http/http.dart' as http;

/// Enhanced service for handling both public and authenticated API requests
class ApiService {
  static const String _baseUrl =
      'https://api.jsonbin.io/v3/b/6881d8637b4b8670d8a6726c/latest';
  static const String _apiKey =
      r'$2a$10$zDMIipp.oXBVa5aRBh4LMeQAqKpixzSSkrLcNVBWNRlxL1.cPdZMG';

  static final SecureStorageService _secureStorage = SecureStorageService();

  /// Get headers for authenticated requests
  static Map<String, String> _getAuthHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};

    final authHeader = _secureStorage.getAuthorizationHeader();
    if (authHeader != null) {
      headers['Authorization'] = authHeader;
    }

    return headers;
  }

  /// Make authenticated GET request
  static Future<http.Response> authenticatedGet(String url) async {
    final headers = _getAuthHeaders();
    LogService.apiRequest('GET', url, headers);

    final response = await http.get(Uri.parse(url), headers: headers);
    LogService.apiResponse('GET', url, response.statusCode, response.body);

    return response;
  }

  /// Make authenticated POST request
  static Future<http.Response> authenticatedPost(
    String url,
    Map<String, dynamic> body,
  ) async {
    final headers = _getAuthHeaders();
    final jsonBody = json.encode(body);

    LogService.apiRequest('POST', url, headers, jsonBody);

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    LogService.apiResponse('POST', url, response.statusCode, response.body);

    return response;
  }

  /// Make authenticated PUT request
  static Future<http.Response> authenticatedPut(
    String url,
    Map<String, dynamic> body,
  ) async {
    final headers = _getAuthHeaders();
    final jsonBody = json.encode(body);

    LogService.apiRequest('PUT', url, headers, jsonBody);

    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    LogService.apiResponse('PUT', url, response.statusCode, response.body);

    return response;
  }

  /// Make authenticated DELETE request
  static Future<http.Response> authenticatedDelete(String url) async {
    final headers = _getAuthHeaders();
    LogService.apiRequest('DELETE', url, headers);

    final response = await http.delete(Uri.parse(url), headers: headers);
    LogService.apiResponse('DELETE', url, response.statusCode, response.body);

    return response;
  }

  /// Fetch products from the API (existing functionality)
  static Future<List<Product>> fetchProducts() async {
    try {
      LogService.apiRequest('GET', _baseUrl);

      final url = Uri.parse(_baseUrl);
      final headers = {
        'X-Master-Key': _apiKey,
        'Content-Type': 'application/json',
      };

      final response = await http.get(url, headers: headers);

      LogService.apiResponse('GET', _baseUrl, response.statusCode);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // The actual content is inside the "record" field
        final productsJson = data['record']['beverageProducts'] as List;

        final products = productsJson
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();

        LogService.info('✅ Successfully fetched ${products.length} products');
        return products;
      } else {
        final errorMessage =
            'Failed to fetch data. Status code: ${response.statusCode}';
        LogService.error(errorMessage);
        ErrorService().handleApiError(
          errorMessage,
          endpoint: _baseUrl,
          statusCode: response.statusCode,
          response: response.body,
        );
        throw Exception(errorMessage);
      }
    } catch (e) {
      LogService.error('An error occurred while fetching products: $e');
      ErrorService().handleApiError(e.toString(), endpoint: _baseUrl);
      rethrow;
    }
  }

  /// Fetch limited products for hot deals section (existing functionality)
  static Future<List<Product>> fetchHotDealsProducts({int limit = 10}) async {
    try {
      final allProducts = await fetchProducts();

      // Filter products with offers and take limited count
      final hotDealsProducts = allProducts
          .where((product) => product.offerPercentage > 0)
          .take(limit)
          .toList();

      LogService.info(
        '✅ Filtered ${hotDealsProducts.length} hot deals products',
      );
      return hotDealsProducts;
    } catch (e) {
      LogService.error(
        'An error occurred while fetching hot deals products: $e',
      );
      rethrow;
    }
  }
}
