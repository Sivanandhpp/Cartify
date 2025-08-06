/// Order Storage Service for Cartify
/// Handles local storage and caching of order data for better performance
/// and offline access to order history and details

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/order_models.dart';
import '../log_service.dart';

/// Service for order data storage and caching
class OrderStorageService extends GetxService {
  static final GetStorage _storage = GetStorage();

  // Storage keys
  static const String _ordersKey = 'user_orders';
  static const String _ordersLastUpdateKey = 'orders_last_update';
  static const String _orderStatisticsKey = 'order_statistics';

  // Cache duration (30 minutes)
  static const Duration _cacheValidityDuration = Duration(minutes: 30);

  // Observable order data
  final RxList<Order> _userOrders = <Order>[].obs;
  final Rx<DateTime?> _lastUpdate = Rx<DateTime?>(null);
  final RxMap<String, dynamic> _orderStatistics = <String, dynamic>{}.obs;

  // Getters for reactive state
  List<Order> get userOrders => _userOrders.toList();
  DateTime? get lastUpdate => _lastUpdate.value;
  Map<String, dynamic> get orderStatistics => Map.from(_orderStatistics);

  // Reactive getters
  RxList<Order> get userOrdersRx => _userOrders;
  RxMap<String, dynamic> get orderStatisticsRx => _orderStatistics;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadStoredOrderData();
  }

  /// Load stored order data on app start
  Future<void> _loadStoredOrderData() async {
    try {
      LogService.info('Loading stored order data');

      // Load last update time
      final lastUpdateString = _storage.read<String>(_ordersLastUpdateKey);
      if (lastUpdateString != null) {
        _lastUpdate.value = DateTime.parse(lastUpdateString);
      }

      // Load orders
      final ordersData = _storage.read<List<dynamic>>(_ordersKey);
      if (ordersData != null) {
        final orders = ordersData
            .map((data) => Order.fromJson(data as Map<String, dynamic>))
            .toList();
        _userOrders.assignAll(orders);
        LogService.info('Loaded ${orders.length} orders from storage');
      }

      // Load order statistics
      final statisticsData = _storage.read<Map<String, dynamic>>(
        _orderStatisticsKey,
      );
      if (statisticsData != null) {
        _orderStatistics.assignAll(statisticsData);
        LogService.info('Order statistics loaded from storage');
      }
    } catch (e) {
      LogService.error('Error loading stored order data: $e');
    }
  }

  // ============================================================================
  // ORDER STORAGE OPERATIONS
  // ============================================================================

  /// Save orders to storage
  Future<void> saveOrders(List<Order> orders) async {
    try {
      LogService.info('Saving ${orders.length} orders to storage');

      final ordersData = orders.map((order) => order.toJson()).toList();
      await _storage.write(_ordersKey, ordersData);
      await _storage.write(
        _ordersLastUpdateKey,
        DateTime.now().toIso8601String(),
      );

      _userOrders.assignAll(orders);
      _lastUpdate.value = DateTime.now();

      LogService.info('Orders saved successfully');
    } catch (e) {
      LogService.error('Error saving orders: $e');
      throw Exception('Failed to save orders');
    }
  }

  /// Add single order to storage
  Future<void> addOrder(Order order) async {
    try {
      LogService.info('Adding order to storage: ${order.id}');

      final currentOrders = List<Order>.from(_userOrders);

      // Check if order already exists
      final existingIndex = currentOrders.indexWhere((o) => o.id == order.id);
      if (existingIndex != -1) {
        // Update existing order
        currentOrders[existingIndex] = order;
      } else {
        // Add new order at the beginning (most recent first)
        currentOrders.insert(0, order);
      }

      await saveOrders(currentOrders);
    } catch (e) {
      LogService.error('Error adding order: $e');
    }
  }

  /// Update existing order in storage
  Future<void> updateOrder(Order updatedOrder) async {
    try {
      LogService.info('Updating order in storage: ${updatedOrder.id}');

      final currentOrders = List<Order>.from(_userOrders);
      final index = currentOrders.indexWhere(
        (order) => order.id == updatedOrder.id,
      );

      if (index != -1) {
        currentOrders[index] = updatedOrder;
        await saveOrders(currentOrders);
      } else {
        LogService.warning('Order not found for update: ${updatedOrder.id}');
      }
    } catch (e) {
      LogService.error('Error updating order: $e');
    }
  }

  /// Save order statistics
  Future<void> saveOrderStatistics(Map<String, dynamic> statistics) async {
    try {
      LogService.info('Saving order statistics to storage');

      await _storage.write(_orderStatisticsKey, statistics);
      _orderStatistics.assignAll(statistics);

      LogService.info('Order statistics saved successfully');
    } catch (e) {
      LogService.error('Error saving order statistics: $e');
    }
  }

  // ============================================================================
  // CACHE VALIDATION
  // ============================================================================

  /// Check if cached order data is still valid
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
    return !isCacheValid() || _userOrders.isEmpty;
  }

  // ============================================================================
  // ORDER QUERIES
  // ============================================================================

  /// Get order by ID from cached data
  Order? getOrderById(String orderId) {
    try {
      return _userOrders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      LogService.warning('Order not found in cache: $orderId');
      return null;
    }
  }

  /// Get orders by status from cached data
  List<Order> getOrdersByStatus(OrderStatus status) {
    return _userOrders.where((order) => order.status == status).toList();
  }

  /// Get recent orders from cached data
  List<Order> getRecentOrders({int days = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _userOrders
        .where((order) => order.createdAt.isAfter(cutoffDate))
        .toList();
  }

  /// Get pending orders from cached data
  List<Order> getPendingOrders() {
    return _userOrders.where((order) => order.canBeCancelled).toList();
  }

  /// Get delivered orders from cached data
  List<Order> getDeliveredOrders() {
    return _userOrders.where((order) => order.isDelivered).toList();
  }

  /// Get orders in progress from cached data
  List<Order> getOrdersInProgress() {
    return _userOrders.where((order) => order.isInProgress).toList();
  }

  /// Get orders sorted by date (newest first)
  List<Order> getOrdersSortedByDate() {
    final orders = List<Order>.from(_userOrders);
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return orders;
  }

  /// Get orders for a specific date range
  List<Order> getOrdersInDateRange(DateTime startDate, DateTime endDate) {
    return _userOrders.where((order) {
      return order.createdAt.isAfter(startDate) &&
          order.createdAt.isBefore(endDate);
    }).toList();
  }

  // ============================================================================
  // ORDER STATISTICS
  // ============================================================================

  /// Calculate local order statistics from cached data
  Map<String, dynamic> calculateLocalStatistics() {
    try {
      final totalOrders = _userOrders.length;
      final totalSpent = _userOrders.fold<double>(
        0.0,
        (sum, order) => sum + order.totalAmount,
      );

      final deliveredOrders = _userOrders
          .where((order) => order.isDelivered)
          .length;
      final pendingOrders = _userOrders
          .where((order) => order.canBeCancelled)
          .length;
      final cancelledOrders = _userOrders
          .where((order) => order.status == OrderStatus.cancelled)
          .length;

      final averageOrderValue = totalOrders > 0
          ? totalSpent / totalOrders
          : 0.0;

      return {
        'total_orders': totalOrders,
        'total_spent': totalSpent,
        'delivered_orders': deliveredOrders,
        'pending_orders': pendingOrders,
        'cancelled_orders': cancelledOrders,
        'average_order_value': averageOrderValue,
        'formatted_total_spent': '₹${totalSpent.toStringAsFixed(2)}',
        'formatted_average_value': '₹${averageOrderValue.toStringAsFixed(2)}',
        'calculated_at': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      LogService.error('Error calculating local statistics: $e');
      return {};
    }
  }

  /// Get order count
  int getOrdersCount() {
    return _userOrders.length;
  }

  /// Check if user has any orders
  bool hasOrders() {
    return _userOrders.isNotEmpty;
  }

  /// Get most recent order
  Order? getMostRecentOrder() {
    if (_userOrders.isEmpty) return null;

    final sortedOrders = getOrdersSortedByDate();
    return sortedOrders.first;
  }

  /// Get total amount spent
  double getTotalAmountSpent() {
    return _userOrders.fold<double>(
      0.0,
      (sum, order) => sum + order.totalAmount,
    );
  }

  // ============================================================================
  // SEARCH AND FILTER
  // ============================================================================

  /// Search orders by order ID or product name
  List<Order> searchOrders(String query) {
    if (query.isEmpty) return _userOrders.toList();

    final lowercaseQuery = query.toLowerCase();

    return _userOrders.where((order) {
      // Search by order ID
      if (order.id.toLowerCase().contains(lowercaseQuery)) {
        return true;
      }

      // Search by product names in order items
      return order.items.any(
        (item) => item.productName.toLowerCase().contains(lowercaseQuery),
      );
    }).toList();
  }

  /// Filter orders by total amount range
  List<Order> filterOrdersByAmountRange(double minAmount, double maxAmount) {
    return _userOrders.where((order) {
      return order.totalAmount >= minAmount && order.totalAmount <= maxAmount;
    }).toList();
  }

  // ============================================================================
  // CLEANUP
  // ============================================================================

  /// Clear all cached order data
  Future<void> clearOrderCache() async {
    try {
      LogService.info('Clearing order cache');

      await _storage.remove(_ordersKey);
      await _storage.remove(_ordersLastUpdateKey);
      await _storage.remove(_orderStatisticsKey);

      _userOrders.clear();
      _lastUpdate.value = null;
      _orderStatistics.clear();

      LogService.info('Order cache cleared successfully');
    } catch (e) {
      LogService.error('Error clearing order cache: $e');
    }
  }

  /// Force refresh cache (mark as expired)
  void forceRefresh() {
    _lastUpdate.value = DateTime.now().subtract(const Duration(days: 1));
    LogService.info('Order cache marked for refresh');
  }

  /// Get cache information
  Map<String, dynamic> getCacheInfo() {
    return {
      'orders_count': _userOrders.length,
      'last_update': _lastUpdate.value?.toIso8601String(),
      'cache_valid': isCacheValid(),
      'cache_age_minutes': getCacheAgeInMinutes(),
      'needs_refresh': needsRefresh(),
    };
  }
}
