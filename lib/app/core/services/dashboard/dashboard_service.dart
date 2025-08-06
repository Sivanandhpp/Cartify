/// High-level dashboard service with intelligent caching and content management
///
/// This service provides a simple, easy-to-use interface for all dashboard operations,
/// including home screen content, promotional banners, and smart caching to improve
/// performance and reduce API calls.

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/dashboard/dashboard_models.dart';
import '../../models/catalog/catalog_models.dart';
import '../log_service.dart';
import 'dashboard_api_client.dart';

/// Dashboard service managing home screen content and caching
///
/// Provides high-level functions for dashboard operations with automatic
/// caching, content filtering, and error handling. All operations
/// are designed to provide optimal user experience with smart data management.
class DashboardService extends GetxService {
  static const String _logTag = 'DashboardService';
  static const String _storagePrefix = 'dashboard_service_';
  static const Duration _cacheExpiry = Duration(minutes: 10);

  // Storage keys
  static const String _dashboardKey = '${_storagePrefix}dashboard';
  static const String _dashboardCacheTimeKey =
      '${_storagePrefix}dashboard_cache_time';

  // Dependencies
  final GetStorage _storage = GetStorage();

  // Reactive state
  final Rx<DashboardResponse?> _dashboardData = Rx<DashboardResponse?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _lastError = ''.obs;

  // Getters for reactive state
  DashboardResponse? get dashboardData => _dashboardData.value;
  bool get isLoading => _isLoading.value;
  String get lastError => _lastError.value;
  bool get hasError => _lastError.value.isNotEmpty;

  // Reactive getters
  Rx<DashboardResponse?> get dashboardDataRx => _dashboardData;
  RxBool get isLoadingRx => _isLoading;
  RxString get lastErrorRx => _lastError;

  @override
  void onInit() {
    super.onInit();
    _loadCachedData();
    LogService.info('$_logTag: Service initialized');
  }

  /// Load cached dashboard data from storage
  ///
  /// Attempts to load previously cached dashboard data
  /// from local storage if it hasn't expired.
  void _loadCachedData() {
    try {
      final dashboardData = _storage.read(_dashboardKey);
      final cacheTime = _storage.read(_dashboardCacheTimeKey);

      if (dashboardData != null && cacheTime != null) {
        final cacheDateTime = DateTime.fromMillisecondsSinceEpoch(
          cacheTime as int,
        );
        if (DateTime.now().difference(cacheDateTime) < _cacheExpiry) {
          _dashboardData.value = DashboardResponse.fromJson(
            dashboardData as Map<String, dynamic>,
          );
          LogService.debug(
            '$_logTag: Loaded cached dashboard data - Sections: ${_dashboardData.value?.sections.length}',
          );
        }
      }
    } catch (e) {
      LogService.warning('$_logTag: Failed to load cached data: $e');
      _clearCachedData();
    }
  }

  /// Clear cached data from storage
  void _clearCachedData() {
    _storage.remove(_dashboardKey);
    _storage.remove(_dashboardCacheTimeKey);
    LogService.debug('$_logTag: Cached data cleared');
  }

  /// Cache dashboard data to storage
  ///
  /// Stores the dashboard data with a timestamp for cache expiry management.
  ///
  /// [dashboard] - Dashboard data to cache
  void _cacheDashboard(DashboardResponse dashboard) {
    try {
      _storage.write(_dashboardKey, dashboard.toJson());
      _storage.write(
        _dashboardCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      LogService.debug(
        '$_logTag: Dashboard data cached - Sections: ${dashboard.sections.length}',
      );
    } catch (e) {
      LogService.warning('$_logTag: Failed to cache dashboard data: $e');
    }
  }

  /// Get complete dashboard content with smart caching
  ///
  /// Retrieves all dashboard content for the home screen. Uses cached data
  /// if available and not expired, otherwise fetches fresh data from the API.
  ///
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: [DashboardResponse] or null if not available
  /// Throws: [DashboardApiException] on API failure
  Future<DashboardResponse?> getDashboard({bool forceRefresh = false}) async {
    try {
      LogService.info(
        '$_logTag: Getting dashboard content (forceRefresh: $forceRefresh)',
      );
      _lastError.value = '';

      // Return cached data if available and not forcing refresh
      if (!forceRefresh && _dashboardData.value != null) {
        LogService.debug('$_logTag: Returning cached dashboard data');
        return _dashboardData.value;
      }

      _isLoading.value = true;

      // Fetch dashboard from API
      final dashboard = await DashboardApiClient.getDashboardContent();

      // Update state and cache
      _dashboardData.value = dashboard;
      _cacheDashboard(dashboard);

      LogService.info(
        '$_logTag: Dashboard content fetched successfully - Sections: ${dashboard.sections.length}',
      );
      return dashboard;
    } on DashboardApiException catch (e) {
      LogService.error('$_logTag: API error getting dashboard: $e');
      _lastError.value = e.message;
      rethrow;
    } catch (e) {
      LogService.error('$_logTag: Unexpected error getting dashboard: $e');
      _lastError.value = 'Failed to load dashboard content';
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Get all visible sections for home screen display
  ///
  /// Returns only the sections that should be displayed to users,
  /// filtered and sorted according to their configuration.
  ///
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: List of [DashboardSection] ready for display
  Future<List<DashboardSection>> getVisibleSections({
    bool forceRefresh = false,
  }) async {
    final dashboard = await getDashboard(forceRefresh: forceRefresh);
    return dashboard?.displaySections ?? [];
  }

  /// Get sections by specific type
  ///
  /// Filters dashboard sections by their type for targeted content display.
  ///
  /// [sectionType] - Type of sections to retrieve
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: List of [DashboardSection] of the specified type
  Future<List<DashboardSection>> getSectionsByType(
    DashboardSectionType sectionType, {
    bool forceRefresh = false,
  }) async {
    final dashboard = await getDashboard(forceRefresh: forceRefresh);
    return dashboard?.getSectionsByType(sectionType) ?? [];
  }

  /// Get all banner items for promotional display
  ///
  /// Retrieves all active banner items from promotional sections
  /// for carousel and banner displays.
  ///
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: List of [BannerItem] objects
  Future<List<BannerItem>> getBanners({bool forceRefresh = false}) async {
    final dashboard = await getDashboard(forceRefresh: forceRefresh);
    return dashboard?.allBanners ?? [];
  }

  /// Get featured products from dashboard
  ///
  /// Extracts all featured products from dashboard sections for
  /// prominent display on the home screen.
  ///
  /// [limit] - Maximum number of products to return
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: List of [Product] objects
  Future<List<Product>> getFeaturedProducts({
    int? limit,
    bool forceRefresh = false,
  }) async {
    final featuredSections = await getSectionsByType(
      DashboardSectionType.featuredProducts,
      forceRefresh: forceRefresh,
    );

    List<Product> products = [];
    for (final section in featuredSections) {
      products.addAll(section.products);
    }

    if (limit != null && products.length > limit) {
      products = products.take(limit).toList();
    }

    LogService.debug(
      '$_logTag: Retrieved ${products.length} featured products',
    );
    return products;
  }

  /// Get trending products from dashboard
  ///
  /// Extracts trending products from dashboard sections for
  /// highlighting popular items.
  ///
  /// [limit] - Maximum number of products to return
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: List of [Product] objects
  Future<List<Product>> getTrendingProducts({
    int? limit,
    bool forceRefresh = false,
  }) async {
    final trendingSections = await getSectionsByType(
      DashboardSectionType.trending,
      forceRefresh: forceRefresh,
    );

    List<Product> products = [];
    for (final section in trendingSections) {
      products.addAll(section.products);
    }

    if (limit != null && products.length > limit) {
      products = products.take(limit).toList();
    }

    LogService.debug(
      '$_logTag: Retrieved ${products.length} trending products',
    );
    return products;
  }

  /// Get sale/discounted products from dashboard
  ///
  /// Extracts products on sale from dashboard sections for
  /// promotional displays and deals sections.
  ///
  /// [limit] - Maximum number of products to return
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: List of [Product] objects
  Future<List<Product>> getSaleProducts({
    int? limit,
    bool forceRefresh = false,
  }) async {
    final saleSections = await getSectionsByType(
      DashboardSectionType.onSale,
      forceRefresh: forceRefresh,
    );

    List<Product> products = [];
    for (final section in saleSections) {
      products.addAll(section.products);
    }

    if (limit != null && products.length > limit) {
      products = products.take(limit).toList();
    }

    LogService.debug('$_logTag: Retrieved ${products.length} sale products');
    return products;
  }

  /// Get recommended products from dashboard
  ///
  /// Extracts personalized product recommendations from dashboard
  /// sections for user-specific content display.
  ///
  /// [limit] - Maximum number of products to return
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: List of [Product] objects
  Future<List<Product>> getRecommendedProducts({
    int? limit,
    bool forceRefresh = false,
  }) async {
    final recommendedSections = await getSectionsByType(
      DashboardSectionType.recommended,
      forceRefresh: forceRefresh,
    );

    List<Product> products = [];
    for (final section in recommendedSections) {
      products.addAll(section.products);
    }

    if (limit != null && products.length > limit) {
      products = products.take(limit).toList();
    }

    LogService.debug(
      '$_logTag: Retrieved ${products.length} recommended products',
    );
    return products;
  }

  /// Get featured categories from dashboard
  ///
  /// Extracts featured categories from dashboard sections for
  /// category navigation and discovery.
  ///
  /// [limit] - Maximum number of categories to return
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: List of [Category] objects
  Future<List<Category>> getFeaturedCategories({
    int? limit,
    bool forceRefresh = false,
  }) async {
    final categorySections = await getSectionsByType(
      DashboardSectionType.categories,
      forceRefresh: forceRefresh,
    );

    List<Category> categories = [];
    for (final section in categorySections) {
      categories.addAll(section.categories);
    }

    if (limit != null && categories.length > limit) {
      categories = categories.take(limit).toList();
    }

    LogService.debug(
      '$_logTag: Retrieved ${categories.length} featured categories',
    );
    return categories;
  }

  /// Get specific section by ID
  ///
  /// Finds and returns a specific dashboard section by its unique identifier.
  ///
  /// [sectionId] - ID of the section to find
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: [DashboardSection] or null if not found
  Future<DashboardSection?> getSectionById(
    String sectionId, {
    bool forceRefresh = false,
  }) async {
    final dashboard = await getDashboard(forceRefresh: forceRefresh);
    return dashboard?.sections.firstWhereOrNull(
      (section) => section.id == sectionId,
    );
  }

  /// Check if dashboard has content
  ///
  /// Determines if the dashboard has any content sections available for display.
  ///
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: true if dashboard has content
  Future<bool> hasContent({bool forceRefresh = false}) async {
    final dashboard = await getDashboard(forceRefresh: forceRefresh);
    return dashboard?.hasContent ?? false;
  }

  /// Get dashboard last update time
  ///
  /// Returns the timestamp of when the dashboard content was last updated.
  ///
  /// Returns: [DateTime] of last update or null if not available
  DateTime? getLastUpdateTime() {
    return _dashboardData.value?.lastUpdated;
  }

  /// Get dashboard version
  ///
  /// Returns the current version of the dashboard configuration.
  ///
  /// Returns: Version string or null if not available
  String? getDashboardVersion() {
    return _dashboardData.value?.version;
  }

  /// Refresh dashboard content
  ///
  /// Forces a complete refresh of dashboard content from the API,
  /// bypassing any cached information.
  ///
  /// Returns: true if successful
  Future<bool> refreshDashboard() async {
    try {
      LogService.info('$_logTag: Refreshing dashboard content');

      // Clear cached data first
      _clearCachedData();
      _dashboardData.value = null;

      // Fetch fresh data
      await getDashboard(forceRefresh: true);

      LogService.info('$_logTag: Dashboard content refreshed successfully');
      return true;
    } catch (e) {
      LogService.error('$_logTag: Error refreshing dashboard: $e');
      return false;
    }
  }

  /// Clear all dashboard data and cache
  ///
  /// Completely clears all dashboard data from memory and storage.
  /// Used when needing to reset the dashboard state.
  void clearAllData() {
    LogService.info('$_logTag: Clearing all dashboard data');
    _dashboardData.value = null;
    _lastError.value = '';
    _clearCachedData();
  }

  /// Check if dashboard content is stale
  ///
  /// Determines if the cached dashboard content is older than the cache expiry time.
  ///
  /// Returns: true if content should be refreshed
  bool isContentStale() {
    try {
      final cacheTime = _storage.read(_dashboardCacheTimeKey);
      if (cacheTime == null) return true;

      final cacheDateTime = DateTime.fromMillisecondsSinceEpoch(
        cacheTime as int,
      );
      return DateTime.now().difference(cacheDateTime) >= _cacheExpiry;
    } catch (e) {
      LogService.warning('$_logTag: Error checking content staleness: $e');
      return true;
    }
  }

  /// Get cache status information
  ///
  /// Returns information about the current cache state for debugging purposes.
  ///
  /// Returns: Map containing cache status details
  Map<String, dynamic> getCacheStatus() {
    try {
      final cacheTime = _storage.read(_dashboardCacheTimeKey);
      final hasData = _dashboardData.value != null;
      final isStale = isContentStale();

      return {
        'hasData': hasData,
        'isStale': isStale,
        'cacheTime': cacheTime != null
            ? DateTime.fromMillisecondsSinceEpoch(
                cacheTime as int,
              ).toIso8601String()
            : null,
        'sectionCount': _dashboardData.value?.sections.length ?? 0,
        'lastError': _lastError.value.isEmpty ? null : _lastError.value,
      };
    } catch (e) {
      LogService.warning('$_logTag: Error getting cache status: $e');
      return {'hasData': false, 'isStale': true, 'error': e.toString()};
    }
  }
}
