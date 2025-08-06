/// Product Storage Service for Cartify
/// Handles local storage and caching of product data
/// including categories, products, reviews, and search history

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/product_models.dart';
import '../log_service.dart';

/// Service for product data local storage and caching
class ProductStorageService extends GetxService {
  static const String _productsKey = 'cached_products';
  static const String _categoriesKey = 'cached_categories';
  static const String _featuredProductsKey = 'featured_products';
  static const String _searchHistoryKey = 'search_history';
  static const String _viewedProductsKey = 'viewed_products';
  static const String _wishlistKey = 'wishlist';
  static const String _productFiltersKey = 'product_filters';

  final GetStorage _storage = GetStorage();

  // Cache expiry time (30 minutes)
  static const Duration _cacheExpiry = Duration(minutes: 30);

  // ============================================================================
  // CATEGORIES STORAGE
  // ============================================================================

  /// Save categories to local storage
  Future<void> saveCategories(List<ProductCategory> categories) async {
    try {
      final categoriesJson = categories.map((cat) => cat.toJson()).toList();
      await _storage.write(_categoriesKey, categoriesJson);
      await _storage.write(
        '${_categoriesKey}_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );

      LogService.info('Saved ${categories.length} categories to local storage');
    } catch (e) {
      LogService.error('Error saving categories: $e');
    }
  }

  /// Get cached categories
  List<ProductCategory> getCachedCategories() {
    try {
      final List<dynamic>? categoriesData = _storage.read(_categoriesKey);
      if (categoriesData == null) return [];

      return categoriesData
          .map((data) => ProductCategory.fromJson(data))
          .toList();
    } catch (e) {
      LogService.error('Error loading cached categories: $e');
      return [];
    }
  }

  /// Check if categories cache is valid
  bool isCategoriesCacheValid() {
    try {
      final int? timestamp = _storage.read('${_categoriesKey}_timestamp');
      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateTime.now().difference(cacheTime) < _cacheExpiry;
    } catch (e) {
      LogService.error('Error checking categories cache validity: $e');
      return false;
    }
  }

  // ============================================================================
  // PRODUCTS STORAGE
  // ============================================================================

  /// Save products to local storage
  Future<void> saveProducts(
    List<Product> products, {
    String? categoryId,
  }) async {
    try {
      final productsJson = products.map((product) => product.toJson()).toList();
      final key = categoryId != null
          ? '${_productsKey}_$categoryId'
          : _productsKey;

      await _storage.write(key, productsJson);
      await _storage.write(
        '${key}_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );

      LogService.info('Saved ${products.length} products to local storage');
    } catch (e) {
      LogService.error('Error saving products: $e');
    }
  }

  /// Get cached products
  List<Product> getCachedProducts({String? categoryId}) {
    try {
      final key = categoryId != null
          ? '${_productsKey}_$categoryId'
          : _productsKey;
      final List<dynamic>? productsData = _storage.read(key);
      if (productsData == null) return [];

      return productsData.map((data) => Product.fromJson(data)).toList();
    } catch (e) {
      LogService.error('Error loading cached products: $e');
      return [];
    }
  }

  /// Check if products cache is valid
  bool isProductsCacheValid({String? categoryId}) {
    try {
      final key = categoryId != null
          ? '${_productsKey}_$categoryId'
          : _productsKey;
      final int? timestamp = _storage.read('${key}_timestamp');
      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateTime.now().difference(cacheTime) < _cacheExpiry;
    } catch (e) {
      LogService.error('Error checking products cache validity: $e');
      return false;
    }
  }

  /// Save single product to cache
  Future<void> saveProduct(Product product) async {
    try {
      await _storage.write('product_${product.id}', product.toJson());
      await _storage.write(
        'product_${product.id}_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );

      LogService.info('Saved product ${product.id} to local storage');
    } catch (e) {
      LogService.error('Error saving product: $e');
    }
  }

  /// Get single cached product
  Product? getCachedProduct(String productId) {
    try {
      final Map<String, dynamic>? productData = _storage.read(
        'product_$productId',
      );
      if (productData == null) return null;

      return Product.fromJson(productData);
    } catch (e) {
      LogService.error('Error loading cached product: $e');
      return null;
    }
  }

  // ============================================================================
  // FEATURED PRODUCTS
  // ============================================================================

  /// Save featured products
  Future<void> saveFeaturedProducts(List<Product> products) async {
    try {
      final productsJson = products.map((product) => product.toJson()).toList();
      await _storage.write(_featuredProductsKey, productsJson);
      await _storage.write(
        '${_featuredProductsKey}_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );

      LogService.info('Saved ${products.length} featured products');
    } catch (e) {
      LogService.error('Error saving featured products: $e');
    }
  }

  /// Get cached featured products
  List<Product> getCachedFeaturedProducts() {
    try {
      final List<dynamic>? productsData = _storage.read(_featuredProductsKey);
      if (productsData == null) return [];

      return productsData.map((data) => Product.fromJson(data)).toList();
    } catch (e) {
      LogService.error('Error loading cached featured products: $e');
      return [];
    }
  }

  /// Check if featured products cache is valid
  bool isFeaturedProductsCacheValid() {
    try {
      final int? timestamp = _storage.read('${_featuredProductsKey}_timestamp');
      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateTime.now().difference(cacheTime) < _cacheExpiry;
    } catch (e) {
      LogService.error('Error checking featured products cache validity: $e');
      return false;
    }
  }

  // ============================================================================
  // SEARCH HISTORY
  // ============================================================================

  /// Add search query to history
  Future<void> addSearchHistory(String query) async {
    try {
      if (query.trim().isEmpty) return;

      List<String> history = getSearchHistory();

      // Remove if already exists
      history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());

      // Add to beginning
      history.insert(0, query.trim());

      // Keep only last 20 searches
      if (history.length > 20) {
        history = history.take(20).toList();
      }

      await _storage.write(_searchHistoryKey, history);
      LogService.info('Added search query to history: $query');
    } catch (e) {
      LogService.error('Error adding search history: $e');
    }
  }

  /// Get search history
  List<String> getSearchHistory() {
    try {
      final List<dynamic>? history = _storage.read(_searchHistoryKey);
      if (history == null) return [];

      return history.map((item) => item.toString()).toList();
    } catch (e) {
      LogService.error('Error loading search history: $e');
      return [];
    }
  }

  /// Clear search history
  Future<void> clearSearchHistory() async {
    try {
      await _storage.remove(_searchHistoryKey);
      LogService.info('Search history cleared');
    } catch (e) {
      LogService.error('Error clearing search history: $e');
    }
  }

  /// Remove specific search item
  Future<void> removeSearchHistoryItem(String query) async {
    try {
      List<String> history = getSearchHistory();
      history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
      await _storage.write(_searchHistoryKey, history);

      LogService.info('Removed search item: $query');
    } catch (e) {
      LogService.error('Error removing search history item: $e');
    }
  }

  // ============================================================================
  // VIEWED PRODUCTS HISTORY
  // ============================================================================

  /// Add product to viewed history
  Future<void> addViewedProduct(Product product) async {
    try {
      List<Map<String, dynamic>> viewed = getViewedProducts();

      // Remove if already exists
      viewed.removeWhere((item) => item['id'] == product.id);

      // Add to beginning
      viewed.insert(0, {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'imageUrl': product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
        'viewedAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Keep only last 50 viewed products
      if (viewed.length > 50) {
        viewed = viewed.take(50).toList();
      }

      await _storage.write(_viewedProductsKey, viewed);
      LogService.info('Added product to viewed history: ${product.name}');
    } catch (e) {
      LogService.error('Error adding viewed product: $e');
    }
  }

  /// Get viewed products history
  List<Map<String, dynamic>> getViewedProducts() {
    try {
      final List<dynamic>? viewed = _storage.read(_viewedProductsKey);
      if (viewed == null) return [];

      return viewed.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      LogService.error('Error loading viewed products: $e');
      return [];
    }
  }

  /// Clear viewed products history
  Future<void> clearViewedProducts() async {
    try {
      await _storage.remove(_viewedProductsKey);
      LogService.info('Viewed products history cleared');
    } catch (e) {
      LogService.error('Error clearing viewed products: $e');
    }
  }

  // ============================================================================
  // WISHLIST STORAGE
  // ============================================================================

  /// Add product to wishlist
  Future<void> addToWishlist(Product product) async {
    try {
      List<String> wishlist = getWishlist();

      if (!wishlist.contains(product.id)) {
        wishlist.add(product.id);
        await _storage.write(_wishlistKey, wishlist);

        // Also cache the product data
        await saveProduct(product);

        LogService.info('Added product to wishlist: ${product.name}');
      }
    } catch (e) {
      LogService.error('Error adding to wishlist: $e');
    }
  }

  /// Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    try {
      List<String> wishlist = getWishlist();
      wishlist.removeWhere((id) => id == productId);
      await _storage.write(_wishlistKey, wishlist);

      LogService.info('Removed product from wishlist: $productId');
    } catch (e) {
      LogService.error('Error removing from wishlist: $e');
    }
  }

  /// Get wishlist product IDs
  List<String> getWishlist() {
    try {
      final List<dynamic>? wishlist = _storage.read(_wishlistKey);
      if (wishlist == null) return [];

      return wishlist.map((id) => id.toString()).toList();
    } catch (e) {
      LogService.error('Error loading wishlist: $e');
      return [];
    }
  }

  /// Check if product is in wishlist
  bool isInWishlist(String productId) {
    return getWishlist().contains(productId);
  }

  /// Get wishlist products (cached data)
  List<Product> getWishlistProducts() {
    try {
      final wishlistIds = getWishlist();
      final List<Product> products = [];

      for (final productId in wishlistIds) {
        final product = getCachedProduct(productId);
        if (product != null) {
          products.add(product);
        }
      }

      return products;
    } catch (e) {
      LogService.error('Error loading wishlist products: $e');
      return [];
    }
  }

  /// Clear wishlist
  Future<void> clearWishlist() async {
    try {
      await _storage.remove(_wishlistKey);
      LogService.info('Wishlist cleared');
    } catch (e) {
      LogService.error('Error clearing wishlist: $e');
    }
  }

  // ============================================================================
  // PRODUCT FILTERS STORAGE
  // ============================================================================

  /// Save user's last used filters
  Future<void> saveProductFilters(Map<String, dynamic> filters) async {
    try {
      await _storage.write(_productFiltersKey, filters);
      LogService.info('Saved product filters');
    } catch (e) {
      LogService.error('Error saving product filters: $e');
    }
  }

  /// Get saved product filters
  Map<String, dynamic> getSavedProductFilters() {
    try {
      final Map<String, dynamic>? filters = _storage.read(_productFiltersKey);
      return filters ?? {};
    } catch (e) {
      LogService.error('Error loading product filters: $e');
      return {};
    }
  }

  /// Clear saved filters
  Future<void> clearSavedFilters() async {
    try {
      await _storage.remove(_productFiltersKey);
      LogService.info('Saved filters cleared');
    } catch (e) {
      LogService.error('Error clearing saved filters: $e');
    }
  }

  // ============================================================================
  // CACHE MANAGEMENT
  // ============================================================================

  /// Clear all product caches
  Future<void> clearAllProductCaches() async {
    try {
      final keys = [
        _productsKey,
        _categoriesKey,
        _featuredProductsKey,
        _searchHistoryKey,
        _viewedProductsKey,
        _productFiltersKey,
      ];

      for (final key in keys) {
        await _storage.remove(key);
        await _storage.remove('${key}_timestamp');
      }

      // Clear individual product caches
      final allKeys = _storage.getKeys();
      for (final key in allKeys) {
        if (key.startsWith('product_')) {
          await _storage.remove(key);
        }
      }

      LogService.info('All product caches cleared');
    } catch (e) {
      LogService.error('Error clearing product caches: $e');
    }
  }

  /// Get cache size information
  Map<String, int> getCacheInfo() {
    try {
      final info = <String, int>{};

      info['categories'] = getCachedCategories().length;
      info['products'] = getCachedProducts().length;
      info['featured_products'] = getCachedFeaturedProducts().length;
      info['search_history'] = getSearchHistory().length;
      info['viewed_products'] = getViewedProducts().length;
      info['wishlist'] = getWishlist().length;

      return info;
    } catch (e) {
      LogService.error('Error getting cache info: $e');
      return {};
    }
  }

  /// Check if any cache needs refresh
  bool needsCacheRefresh() {
    return !isCategoriesCacheValid() ||
        !isProductsCacheValid() ||
        !isFeaturedProductsCacheValid();
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get product statistics
  Map<String, dynamic> getProductStatistics() {
    try {
      final categories = getCachedCategories();
      final products = getCachedProducts();
      final wishlist = getWishlist();
      final viewed = getViewedProducts();

      return {
        'total_categories': categories.length,
        'total_products': products.length,
        'wishlist_count': wishlist.length,
        'viewed_count': viewed.length,
        'average_price': products.isNotEmpty
            ? products.map((p) => p.price).reduce((a, b) => a + b) /
                  products.length
            : 0.0,
        'products_in_stock': products.where((p) => p.isInStock).length,
        'out_of_stock': products.where((p) => !p.isInStock).length,
      };
    } catch (e) {
      LogService.error('Error calculating product statistics: $e');
      return {};
    }
  }

  /// Search cached products locally
  List<Product> searchCachedProducts(String query) {
    try {
      if (query.trim().isEmpty) return [];

      final products = getCachedProducts();
      final searchQuery = query.toLowerCase();

      return products
          .where(
            (product) =>
                product.name.toLowerCase().contains(searchQuery) ||
                product.description.toLowerCase().contains(searchQuery) ||
                (product.category?.name.toLowerCase().contains(searchQuery) ??
                    false),
          )
          .toList();
    } catch (e) {
      LogService.error('Error searching cached products: $e');
      return [];
    }
  }

  /// Filter cached products
  List<Product> filterCachedProducts({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
  }) {
    try {
      List<Product> products = getCachedProducts();

      if (categoryId != null) {
        products = products.where((p) => p.categoryId == categoryId).toList();
      }

      if (minPrice != null) {
        products = products.where((p) => p.price >= minPrice).toList();
      }

      if (maxPrice != null) {
        products = products.where((p) => p.price <= maxPrice).toList();
      }

      if (inStock != null) {
        products = products.where((p) => p.isInStock == inStock).toList();
      }

      return products;
    } catch (e) {
      LogService.error('Error filtering cached products: $e');
      return [];
    }
  }
}
