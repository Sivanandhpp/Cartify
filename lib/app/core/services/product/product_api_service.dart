/// Product API Service for Cartify
/// Handles all product and category related API calls including
/// fetching products, categories, and product reviews

import 'package:get/get.dart';

import '../../models/product_models.dart';
import '../../models/cart_models.dart';
import '../api_service.dart';
import '../log_service.dart';
import '../error_service.dart';

/// Service for product and category API calls
class ProductApiService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // ============================================================================
  // CATEGORY OPERATIONS
  // ============================================================================

  /// Get all product categories
  Future<List<ProductCategory>> getAllCategories() async {
    try {
      LogService.info('Fetching all categories');

      final response = await _apiService.get('/categories');

      if (response.statusCode == 200) {
        final List<dynamic> categoriesData = response.data ?? [];
        final categories = categoriesData
            .map((data) => ProductCategory.fromJson(data))
            .toList();

        LogService.info('Fetched ${categories.length} categories');
        return categories;
      } else {
        LogService.error('Failed to fetch categories: ${response.statusCode}');
        ErrorService.showError('Failed to load categories. Please try again.');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching categories: $e');
      ErrorService.showError('Failed to load categories. Please try again.');
      return [];
    }
  }

  // ============================================================================
  // PRODUCT OPERATIONS
  // ============================================================================

  /// Get all products with optional filtering
  Future<List<Product>> getAllProducts({
    String? categoryId,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    try {
      LogService.info('Fetching products');

      final queryParameters = <String, dynamic>{};
      if (categoryId != null) queryParameters['category_id'] = categoryId;
      if (searchQuery != null) queryParameters['search'] = searchQuery;
      if (limit != null) queryParameters['limit'] = limit;
      if (offset != null) queryParameters['offset'] = offset;

      final response = await _apiService.get(
        '/products',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsData = response.data ?? [];
        final products = productsData
            .map((data) => Product.fromJson(data))
            .toList();

        LogService.info('Fetched ${products.length} products');
        return products;
      } else {
        LogService.error('Failed to fetch products: ${response.statusCode}');
        ErrorService.showError('Failed to load products. Please try again.');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching products: $e');
      ErrorService.showError('Failed to load products. Please try again.');
      return [];
    }
  }

  /// Get single product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      LogService.info('Fetching product: $productId');

      final response = await _apiService.get('/products/$productId');

      if (response.statusCode == 200) {
        final product = Product.fromJson(response.data);
        LogService.info('Product fetched successfully');
        return product;
      } else {
        LogService.error('Failed to fetch product: ${response.statusCode}');
        ErrorService.showError(
          'Failed to load product details. Please try again.',
        );
        return null;
      }
    } catch (e) {
      LogService.error('Error fetching product: $e');
      ErrorService.showError(
        'Failed to load product details. Please try again.',
      );
      return null;
    }
  }

  /// Search products by name or description
  Future<List<Product>> searchProducts(String query) async {
    try {
      LogService.info('Searching products: $query');

      return await getAllProducts(searchQuery: query);
    } catch (e) {
      LogService.error('Error searching products: $e');
      return [];
    }
  }

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      LogService.info('Fetching products for category: $categoryId');

      return await getAllProducts(categoryId: categoryId);
    } catch (e) {
      LogService.error('Error fetching products by category: $e');
      return [];
    }
  }

  /// Get featured products
  Future<List<Product>> getFeaturedProducts() async {
    try {
      LogService.info('Fetching featured products');

      // This could be a specific endpoint or filtered results
      return await getAllProducts(limit: 10);
    } catch (e) {
      LogService.error('Error fetching featured products: $e');
      return [];
    }
  }

  // ============================================================================
  // PRODUCT CREATION (For sellers/admins)
  // ============================================================================

  /// Create new product (for sellers/admins)
  Future<Product?> createProduct(CreateProductDto productData) async {
    try {
      LogService.info('Creating new product: ${productData.name}');

      final response = await _apiService.post(
        '/products',
        data: productData.toJson(),
      );

      if (response.statusCode == 201) {
        final product = Product.fromJson(response.data);
        LogService.info('Product created successfully: ${product.id}');
        ErrorService.showSuccess('Product created successfully');
        return product;
      } else {
        LogService.error('Failed to create product: ${response.statusCode}');
        ErrorService.showError('Failed to create product. Please try again.');
        return null;
      }
    } catch (e) {
      LogService.error('Error creating product: $e');
      ErrorService.showError('Failed to create product. Please try again.');
      return null;
    }
  }

  /// Upload product images (for sellers/admins)
  Future<List<String>> uploadProductImages(
    String productId,
    List<String> imagePaths,
  ) async {
    try {
      LogService.info(
        'Uploading ${imagePaths.length} images for product: $productId',
      );

      final response = await _apiService.uploadFiles(
        '/products/$productId/images',
        imagePaths,
        fieldName: 'files',
      );

      if (response.statusCode == 200) {
        final List<dynamic> imageUrls = response.data['image_urls'] ?? [];
        final urls = imageUrls.map((url) => url.toString()).toList();

        LogService.info('${urls.length} images uploaded successfully');
        ErrorService.showSuccess('Images uploaded successfully');
        return urls;
      } else {
        LogService.error('Failed to upload images: ${response.statusCode}');
        ErrorService.showError('Failed to upload images. Please try again.');
        return [];
      }
    } catch (e) {
      LogService.error('Error uploading product images: $e');
      ErrorService.showError('Failed to upload images. Please try again.');
      return [];
    }
  }

  // ============================================================================
  // PRODUCT REVIEWS
  // ============================================================================

  /// Get reviews for a specific product
  Future<List<ProductReview>> getProductReviews(String productId) async {
    try {
      LogService.info('Fetching reviews for product: $productId');

      final response = await _apiService.get('/reviews/product/$productId');

      if (response.statusCode == 200) {
        final List<dynamic> reviewsData = response.data ?? [];
        final reviews = reviewsData
            .map((data) => ProductReview.fromJson(data))
            .toList();

        LogService.info('Fetched ${reviews.length} reviews');
        return reviews;
      } else {
        LogService.error('Failed to fetch reviews: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching product reviews: $e');
      return [];
    }
  }

  /// Create a product review
  Future<ProductReview?> createProductReview(CreateReviewDto reviewData) async {
    try {
      LogService.info('Creating review for product: ${reviewData.productId}');

      final response = await _apiService.post(
        '/reviews',
        data: reviewData.toJson(),
      );

      if (response.statusCode == 201) {
        final review = ProductReview.fromJson(response.data);
        LogService.info('Review created successfully');
        ErrorService.showSuccess('Review submitted successfully');
        return review;
      } else {
        LogService.error('Failed to create review: ${response.statusCode}');
        ErrorService.showError('Failed to submit review. Please try again.');
        return null;
      }
    } catch (e) {
      LogService.error('Error creating review: $e');
      ErrorService.showError('Failed to submit review. Please try again.');
      return null;
    }
  }

  // ============================================================================
  // PRODUCT FILTERING AND SORTING
  // ============================================================================

  /// Get products with advanced filtering
  Future<List<Product>> getFilteredProducts({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    String?
    sortBy, // 'price_asc', 'price_desc', 'name_asc', 'name_desc', 'newest'
    int? limit,
    int? offset,
  }) async {
    try {
      LogService.info('Fetching filtered products');

      final queryParameters = <String, dynamic>{};
      if (categoryId != null) queryParameters['category_id'] = categoryId;
      if (minPrice != null) queryParameters['min_price'] = minPrice;
      if (maxPrice != null) queryParameters['max_price'] = maxPrice;
      if (inStock != null) queryParameters['in_stock'] = inStock;
      if (sortBy != null) queryParameters['sort_by'] = sortBy;
      if (limit != null) queryParameters['limit'] = limit;
      if (offset != null) queryParameters['offset'] = offset;

      final response = await _apiService.get(
        '/products',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsData = response.data ?? [];
        final products = productsData
            .map((data) => Product.fromJson(data))
            .toList();

        LogService.info('Fetched ${products.length} filtered products');
        return products;
      } else {
        LogService.error(
          'Failed to fetch filtered products: ${response.statusCode}',
        );
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching filtered products: $e');
      return [];
    }
  }

  /// Get products sorted by price (low to high)
  Future<List<Product>> getProductsSortedByPriceLowToHigh({
    String? categoryId,
  }) async {
    return await getFilteredProducts(
      categoryId: categoryId,
      sortBy: 'price_asc',
    );
  }

  /// Get products sorted by price (high to low)
  Future<List<Product>> getProductsSortedByPriceHighToLow({
    String? categoryId,
  }) async {
    return await getFilteredProducts(
      categoryId: categoryId,
      sortBy: 'price_desc',
    );
  }

  /// Get newest products
  Future<List<Product>> getNewestProducts({
    String? categoryId,
    int limit = 20,
  }) async {
    return await getFilteredProducts(
      categoryId: categoryId,
      sortBy: 'newest',
      limit: limit,
    );
  }

  /// Get products in price range
  Future<List<Product>> getProductsInPriceRange(
    double minPrice,
    double maxPrice, {
    String? categoryId,
  }) async {
    return await getFilteredProducts(
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }

  /// Get products that are in stock
  Future<List<Product>> getProductsInStock({String? categoryId}) async {
    return await getFilteredProducts(categoryId: categoryId, inStock: true);
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Check if product is available for purchase
  bool isProductAvailable(Product product, int requestedQuantity) {
    return product.isActive &&
        product.isInStock &&
        product.stockQuantity >= requestedQuantity;
  }

  /// Get product availability message
  String getProductAvailabilityMessage(Product product, int requestedQuantity) {
    if (!product.isActive) {
      return 'Product is currently unavailable';
    }

    if (!product.isInStock) {
      return 'Product is out of stock';
    }

    if (product.stockQuantity < requestedQuantity) {
      return 'Only ${product.stockQuantity} items available';
    }

    return 'Available';
  }

  /// Get related products (mock implementation)
  Future<List<Product>> getRelatedProducts(
    String productId, {
    int limit = 5,
  }) async {
    try {
      LogService.info('Fetching related products for: $productId');

      // This is a simplified implementation
      // In a real app, this would use recommendation algorithms
      final allProducts = await getAllProducts(limit: limit * 2);

      // Remove the current product and return a subset
      allProducts.removeWhere((product) => product.id == productId);

      return allProducts.take(limit).toList();
    } catch (e) {
      LogService.error('Error fetching related products: $e');
      return [];
    }
  }
}
