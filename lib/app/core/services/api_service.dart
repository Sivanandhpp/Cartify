import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_product_model.dart';
import 'log_service.dart';
import 'error_service.dart';

/// Service for fetching products from JSONBin.io API
class ApiService {
  static const String _baseUrl =
      'https://api.jsonbin.io/v3/b/6881d8637b4b8670d8a6726c/latest';
  static const String _apiKey =
      r'$2a$10$zDMIipp.oXBVa5aRBh4LMeQAqKpixzSSkrLcNVBWNRlxL1.cPdZMG';

  /// Fetch products from the API
  static Future<List<ApiProduct>> fetchProducts() async {
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
            .map((json) => ApiProduct.fromJson(json as Map<String, dynamic>))
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

  /// Fetch limited products for hot deals section
  static Future<List<ApiProduct>> fetchHotDealsProducts({
    int limit = 10,
  }) async {
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
