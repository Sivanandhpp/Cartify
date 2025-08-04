import 'dart:convert';
import 'package:cartify/app/core/index.dart';
import '../../config/api_endpoints.dart';
import '../log_service.dart';
import '../error_service.dart';
import 'base_api_service.dart';

/// Products API service
///
/// Handles all product-related API operations including fetching products,
/// hot deals, and external API integrations.
class ProductsApiService {
  // External API configuration for product data
  static const String _externalProductsUrl =
      'https://api.jsonbin.io/v3/b/6881d8637b4b8670d8a6726c/latest';
  static const String _externalApiKey =
      r'$2a$10$zDMIipp.oXBVa5aRBh4LMeQAqKpixzSSkrLcNVBWNRlxL1.cPdZMG';

  /// Fetch products from external API (existing JSONBin functionality)
  static Future<List<Product>> fetchProducts() async {
    try {
      LogService.info('Fetching products from external API');

      final headers = BaseApiService.getCustomHeaders({
        'X-Master-Key': _externalApiKey,
      });

      final response = await BaseApiService.publicGet(
        _externalProductsUrl,
        headers: headers,
      );

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
          endpoint: _externalProductsUrl,
          statusCode: response.statusCode,
          response: response.body,
        );
        throw Exception(errorMessage);
      }
    } catch (e) {
      LogService.error('An error occurred while fetching products: $e');
      ErrorService().handleApiError(
        e.toString(),
        endpoint: _externalProductsUrl,
      );
      rethrow;
    }
  }

  /// Fetch limited products for hot deals section
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

  /// Fetch products from internal API (future implementation)
  static Future<List<Product>> fetchProductsFromInternalApi() async {
    try {
      LogService.info('Fetching products from internal API');

      final response = await BaseApiService.get(
        '${ApiEndpoints.baseUrl}/products',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productsJson = data['products'] as List;

        final products = productsJson
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();

        LogService.info(
          '✅ Successfully fetched ${products.length} products from internal API',
        );
        return products;
      } else {
        final errorMessage =
            'Failed to fetch products from internal API. Status code: ${response.statusCode}';
        LogService.error(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      LogService.error(
        'An error occurred while fetching products from internal API: $e',
      );
      rethrow;
    }
  }

  /// Get product details by ID
  static Future<Product?> getProductById(String productId) async {
    try {
      LogService.info('Fetching product details for ID: $productId');

      final response = await BaseApiService.get(
        '${ApiEndpoints.baseUrl}/products/$productId',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final product = Product.fromJson(data['product']);

        LogService.info('✅ Successfully fetched product: ${product.name}');
        return product;
      } else if (response.statusCode == 404) {
        LogService.warning('Product not found for ID: $productId');
        return null;
      } else {
        final errorMessage =
            'Failed to fetch product details. Status code: ${response.statusCode}';
        LogService.error(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      LogService.error('An error occurred while fetching product details: $e');
      rethrow;
    }
  }

  /// Search products by query
  static Future<List<Product>> searchProducts(String query) async {
    try {
      LogService.info('Searching products with query: $query');

      final response = await BaseApiService.get(
        '${ApiEndpoints.baseUrl}/products/search?q=${Uri.encodeComponent(query)}',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productsJson = data['products'] as List;

        final products = productsJson
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();

        LogService.info(
          '✅ Found ${products.length} products for query: $query',
        );
        return products;
      } else {
        final errorMessage =
            'Failed to search products. Status code: ${response.statusCode}';
        LogService.error(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      LogService.error('An error occurred while searching products: $e');
      rethrow;
    }
  }

  /// Get products by category
  static Future<List<Product>> getProductsByCategory(String category) async {
    try {
      LogService.info('Fetching products for category: $category');

      final response = await BaseApiService.get(
        '${ApiEndpoints.baseUrl}/products/category/${Uri.encodeComponent(category)}',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final productsJson = data['products'] as List;

        final products = productsJson
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();

        LogService.info(
          '✅ Found ${products.length} products in category: $category',
        );
        return products;
      } else {
        final errorMessage =
            'Failed to fetch products by category. Status code: ${response.statusCode}';
        LogService.error(errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      LogService.error(
        'An error occurred while fetching products by category: $e',
      );
      rethrow;
    }
  }
}
