import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';

/// Centralized data controller for seller panel
/// Manages products, orders, and categories with caching mechanism
class SellerDataController extends GetxController {
  // ===================== SERVICES =====================
  final ProductService _productService = Get.find<ProductService>();
  final OrderService _orderService = Get.find<OrderService>();

  // ===================== OBSERVABLE DATA =====================
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<String> extractedCategories = <String>['All'].obs;

  // ===================== STATE MANAGEMENT =====================
  final RxBool isLoading = false.obs;
  final RxBool isDataLoaded = false.obs;

  // ===================== CACHE MANAGEMENT =====================
  DateTime? _lastFetch;
  static const Duration _cacheDuration = Duration(minutes: 5);

  // ===================== DATA FETCHING METHODS =====================

  /// Fetch all data (products, orders, and categories) with caching
  /// [forceRefresh] - bypasses cache and fetches fresh data
  Future<void> fetchAllData({bool forceRefresh = false}) async {
    // Return cached data if valid and not forcing refresh
    if (!forceRefresh && _isCacheValid() && isDataLoaded.value) {
      LogService.info('Using cached seller data');
      return;
    }

    try {
      isLoading.value = true;
      LogService.info('Fetching seller data from API');

      // Fetch all data concurrently for better performance
      final results = await Future.wait([
        _productService.getMyProducts(),
        _orderService.getMyIncomingOrders(),
        _productService.getAllCategories(),
      ]);

      // Assign results to observable lists
      products.assignAll(results[0] as List<ProductModel>);
      orders.assignAll(results[1] as List<OrderModel>);
      categories.assignAll(results[2] as List<CategoryModel>);

      // Extract categories for filtering and update cache
      _extractCategories();
      _updateCache();

      LogService.info('Seller data fetched successfully');
    } catch (e) {
      LogService.error('Failed to fetch seller data', e);
      NotificationService.showError(
        title: 'Loading Failed',
        message: 'Failed to load data. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh only products data
  Future<void> refreshProducts() async {
    try {
      isLoading.value = true;
      LogService.info('Refreshing seller products');

      final fetchedProducts = await _productService.getMyProducts();
      products.assignAll(fetchedProducts);

      // Update extracted categories and cache
      _extractCategories();
      _updateCache();

      LogService.info('Products refreshed successfully');
    } catch (e) {
      LogService.error('Failed to refresh products', e);
      NotificationService.showError(
        title: 'Refresh Failed',
        message: 'Failed to refresh products. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh only orders data
  Future<void> refreshOrders() async {
    try {
      isLoading.value = true;
      LogService.info('Refreshing seller orders');

      final fetchedOrders = await _orderService.getMyIncomingOrders();
      orders.assignAll(fetchedOrders);

      // Update cache timestamp
      _updateCache();

      LogService.info('Orders refreshed successfully');
    } catch (e) {
      LogService.error('Failed to refresh orders', e);
      NotificationService.showError(
        title: 'Refresh Failed',
        message: 'Failed to refresh orders. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Force refresh all data (bypasses cache)
  Future<void> refreshData() async {
    await fetchAllData(forceRefresh: true);
  }

  // ===================== FILTERING METHODS =====================

  /// Get filtered products based on multiple criteria
  List<ProductModel> getFilteredProducts({
    String? category,
    String? status,
    String? stockFilter,
    String? searchQuery,
  }) {
    List<ProductModel> filtered = List.from(products);

    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (product) =>
                product.name.toLowerCase().contains(query) ||
                (product.category?.name.toLowerCase().contains(query) ?? false),
          )
          .toList();
    }

    // Apply category filter
    if (category != null && category != 'All') {
      filtered = filtered
          .where((product) => product.category?.name == category)
          .toList();
    }

    // Apply status filter
    if (status != null && status != 'All') {
      final isActive = status == 'Active';
      filtered = filtered
          .where((product) => (product.isActive ?? true) == isActive)
          .toList();
    }

    // Apply stock filter
    if (stockFilter != null && stockFilter != 'All') {
      filtered = _applyStockFilter(filtered, stockFilter);
    }

    return filtered;
  }

  /// Get filtered orders based on status and search criteria
  List<OrderModel> getFilteredOrders({String? status, String? searchQuery}) {
    List<OrderModel> filtered = List.from(orders);

    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (order) =>
                order.id.toLowerCase().contains(query) ||
                order.shippingAddress.recipientName.toLowerCase().contains(
                  query,
                ) ||
                order.items.any(
                  (item) => item.productName.toLowerCase().contains(query),
                ),
          )
          .toList();
    }

    // Apply status filter
    if (status != null && status != 'All') {
      final orderStatus = _mapStringToOrderStatus(status);
      if (orderStatus != null) {
        filtered = filtered
            .where((order) => order.status == orderStatus)
            .toList();
      }
    }

    return filtered;
  }

  // ===================== PRIVATE HELPER METHODS =====================

  /// Extract unique categories from products for filtering
  void _extractCategories() {
    final categorySet = <String>{'All'};

    for (final product in products) {
      if (product.category != null && product.category!.name.isNotEmpty) {
        categorySet.add(product.category!.name);
      }
    }

    extractedCategories.assignAll(categorySet.toList()..sort());
    LogService.debug('Categories extracted', {
      'count': extractedCategories.length - 1,
    });
  }

  /// Update cache timestamp and data loaded flag
  void _updateCache() {
    _lastFetch = DateTime.now();
    isDataLoaded.value = true;
  }

  /// Check if cached data is still valid
  bool _isCacheValid() {
    return _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < _cacheDuration;
  }

  /// Apply stock-based filtering to products
  List<ProductModel> _applyStockFilter(
    List<ProductModel> products,
    String stockFilter,
  ) {
    switch (stockFilter) {
      case 'In Stock':
        return products.where((product) => product.stockQuantity > 10).toList();
      case 'Low Stock':
        return products
            .where(
              (product) =>
                  product.stockQuantity > 0 && product.stockQuantity <= 10,
            )
            .toList();
      case 'Out of Stock':
        return products.where((product) => product.stockQuantity == 0).toList();
      default:
        return products;
    }
  }

  /// Map string status to OrderStatus enum
  OrderStatus? _mapStringToOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.PENDING;
      case 'confirmed':
        return OrderStatus.CONFIRMED;
      case 'shipped':
        return OrderStatus.SHIPPED;
      case 'delivered':
        return OrderStatus.DELIVERED;
      case 'cancelled':
        return OrderStatus.CANCELLED;
      default:
        return null;
    }
  }
}
