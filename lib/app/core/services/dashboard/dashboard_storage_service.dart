/// Dashboard Storage Service for Cartify
/// Handles caching of dashboard data for better performance
/// and offline access to previously loaded content

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/product_models.dart';
import '../log_service.dart';

/// Service for dashboard data storage and caching
class DashboardStorageService extends GetxService {
  static final GetStorage _storage = GetStorage();

  // Storage keys
  static const String _dashboardDataKey = 'dashboard_data';
  static const String _lastUpdateKey = 'dashboard_last_update';
  static const String _featuredProductsKey = 'featured_products';
  static const String _categoriesKey = 'dashboard_categories';

  // Cache duration (1 hour)
  static const Duration _cacheValidityDuration = Duration(hours: 1);

  // Observable dashboard data
  final RxList<DashboardSection> _dashboardSections = <DashboardSection>[].obs;
  final RxList<Product> _featuredProducts = <Product>[].obs;
  final RxList<ProductCategory> _categories = <ProductCategory>[].obs;
  final Rx<DateTime?> _lastUpdate = Rx<DateTime?>(null);

  // Getters for reactive state
  List<DashboardSection> get dashboardSections => _dashboardSections.toList();
  List<Product> get featuredProducts => _featuredProducts.toList();
  List<ProductCategory> get categories => _categories.toList();
  DateTime? get lastUpdate => _lastUpdate.value;

  // Reactive getters
  RxList<DashboardSection> get dashboardSectionsRx => _dashboardSections;
  RxList<Product> get featuredProductsRx => _featuredProducts;
  RxList<ProductCategory> get categoriesRx => _categories;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadStoredDashboardData();
  }

  /// Load stored dashboard data on app start
  Future<void> _loadStoredDashboardData() async {
    try {
      LogService.info('Loading stored dashboard data');

      // Load last update time
      final lastUpdateString = _storage.read<String>(_lastUpdateKey);
      if (lastUpdateString != null) {
        _lastUpdate.value = DateTime.parse(lastUpdateString);
      }

      // Load dashboard sections
      final sectionsData = _storage.read<List<dynamic>>(_dashboardDataKey);
      if (sectionsData != null) {
        final sections = sectionsData
            .map(
              (data) => DashboardSection.fromJson(data as Map<String, dynamic>),
            )
            .toList();
        _dashboardSections.assignAll(sections);
        LogService.info(
          'Loaded ${sections.length} dashboard sections from storage',
        );
      }

      // Load featured products
      final featuredData = _storage.read<List<dynamic>>(_featuredProductsKey);
      if (featuredData != null) {
        final products = featuredData
            .map((data) => Product.fromJson(data as Map<String, dynamic>))
            .toList();
        _featuredProducts.assignAll(products);
        LogService.info(
          'Loaded ${products.length} featured products from storage',
        );
      }

      // Load categories
      final categoriesData = _storage.read<List<dynamic>>(_categoriesKey);
      if (categoriesData != null) {
        final categories = categoriesData
            .map(
              (data) => ProductCategory.fromJson(data as Map<String, dynamic>),
            )
            .toList();
        _categories.assignAll(categories);
        LogService.info('Loaded ${categories.length} categories from storage');
      }
    } catch (e) {
      LogService.error('Error loading stored dashboard data: $e');
    }
  }

  // ============================================================================
  // DASHBOARD SECTIONS STORAGE
  // ============================================================================

  /// Save complete dashboard data to storage
  Future<void> saveDashboardData(List<DashboardSection> sections) async {
    try {
      LogService.info('Saving dashboard data to storage');

      final sectionsData = sections.map((section) => section.toJson()).toList();
      await _storage.write(_dashboardDataKey, sectionsData);
      await _storage.write(_lastUpdateKey, DateTime.now().toIso8601String());

      _dashboardSections.assignAll(sections);
      _lastUpdate.value = DateTime.now();

      // Extract and save specific data types for quick access
      await _extractAndSaveFeaturedProducts(sections);
      await _extractAndSaveCategories(sections);

      LogService.info('Dashboard data saved successfully');
    } catch (e) {
      LogService.error('Error saving dashboard data: $e');
      throw Exception('Failed to save dashboard data');
    }
  }

  /// Extract and save featured products from sections
  Future<void> _extractAndSaveFeaturedProducts(
    List<DashboardSection> sections,
  ) async {
    try {
      final featuredSection = sections.firstWhereOrNull(
        (section) => section.type == 'featured_products',
      );

      if (featuredSection != null) {
        final products = featuredSection.products;
        final productsData = products
            .map((product) => product.toJson())
            .toList();
        await _storage.write(_featuredProductsKey, productsData);
        _featuredProducts.assignAll(products);
        LogService.info(
          'Extracted and saved ${products.length} featured products',
        );
      }
    } catch (e) {
      LogService.error('Error extracting featured products: $e');
    }
  }

  /// Extract and save categories from sections
  Future<void> _extractAndSaveCategories(
    List<DashboardSection> sections,
  ) async {
    try {
      final categorySection = sections.firstWhereOrNull(
        (section) => section.type == 'categories',
      );

      if (categorySection != null) {
        final categories = categorySection.categories;
        final categoriesData = categories
            .map((category) => category.toJson())
            .toList();
        await _storage.write(_categoriesKey, categoriesData);
        _categories.assignAll(categories);
        LogService.info('Extracted and saved ${categories.length} categories');
      }
    } catch (e) {
      LogService.error('Error extracting categories: $e');
    }
  }

  // ============================================================================
  // CACHE VALIDATION
  // ============================================================================

  /// Check if cached dashboard data is still valid
  bool isCacheValid() {
    if (_lastUpdate.value == null) return false;

    final now = DateTime.now();
    final timeDifference = now.difference(_lastUpdate.value!);

    return timeDifference < _cacheValidityDuration;
  }

  /// Get cache age in minutes
  int getCacheAgeInMinutes() {
    if (_lastUpdate.value == null) return -1;

    final now = DateTime.now();
    final timeDifference = now.difference(_lastUpdate.value!);

    return timeDifference.inMinutes;
  }

  /// Check if cache needs refresh
  bool needsRefresh() {
    return !isCacheValid() || _dashboardSections.isEmpty;
  }

  // ============================================================================
  // DATA RETRIEVAL
  // ============================================================================

  /// Get section by type from cached data
  DashboardSection? getSectionByType(String sectionType) {
    try {
      return _dashboardSections.firstWhereOrNull(
        (section) => section.type == sectionType,
      );
    } catch (e) {
      LogService.warning('Section not found: $sectionType');
      return null;
    }
  }

  /// Get products from specific section
  List<Product> getProductsFromSection(String sectionType) {
    final section = getSectionByType(sectionType);
    return section?.products ?? [];
  }

  /// Get sale products from cached data
  List<Product> getSaleProducts() {
    return getProductsFromSection('sale_products');
  }

  /// Get new arrivals from cached data
  List<Product> getNewArrivals() {
    return getProductsFromSection('new_arrivals');
  }

  /// Get popular products from cached data
  List<Product> getPopularProducts() {
    return getProductsFromSection('popular_products');
  }

  /// Get banners from cached data
  List<dynamic> getBanners() {
    final section = getSectionByType('banners');
    return section?.data ?? [];
  }

  // ============================================================================
  // STATISTICS
  // ============================================================================

  /// Get total number of cached products across all sections
  int getTotalCachedProducts() {
    int total = 0;
    for (final section in _dashboardSections) {
      if (section.type.contains('products')) {
        total += section.products.length;
      }
    }
    return total;
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStatistics() {
    return {
      'sections_count': _dashboardSections.length,
      'featured_products_count': _featuredProducts.length,
      'categories_count': _categories.length,
      'total_products': getTotalCachedProducts(),
      'last_update': _lastUpdate.value?.toIso8601String(),
      'cache_valid': isCacheValid(),
      'cache_age_minutes': getCacheAgeInMinutes(),
    };
  }

  // ============================================================================
  // CLEANUP
  // ============================================================================

  /// Clear all cached dashboard data
  Future<void> clearDashboardCache() async {
    try {
      LogService.info('Clearing dashboard cache');

      await _storage.remove(_dashboardDataKey);
      await _storage.remove(_lastUpdateKey);
      await _storage.remove(_featuredProductsKey);
      await _storage.remove(_categoriesKey);

      _dashboardSections.clear();
      _featuredProducts.clear();
      _categories.clear();
      _lastUpdate.value = null;

      LogService.info('Dashboard cache cleared successfully');
    } catch (e) {
      LogService.error('Error clearing dashboard cache: $e');
    }
  }

  /// Force refresh cache (mark as expired)
  void forceRefresh() {
    _lastUpdate.value = DateTime.now().subtract(const Duration(days: 1));
    LogService.info('Dashboard cache marked for refresh');
  }
}
