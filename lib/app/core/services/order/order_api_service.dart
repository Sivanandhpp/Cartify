/// Order API Service for Cartify
/// Handles all order-related API calls including placing orders,
/// fetching order history, and retrieving order details

import 'package:get/get.dart';

import '../../models/order_models.dart';
import '../api_service.dart';
import '../log_service.dart';
import '../error_service.dart';

/// Service for order API calls
class OrderApiService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // ============================================================================
  // ORDER OPERATIONS
  // ============================================================================

  /// Place a new order from cart
  /// This creates an order, decrements stock, and clears the cart
  Future<Order?> placeOrder(String addressId) async {
    try {
      LogService.info('Placing order with address: $addressId');

      final requestData = CreateOrderDto(addressId: addressId);

      final response = await _apiService.post(
        '/orders',
        data: requestData.toJson(),
      );

      if (response.statusCode == 201) {
        final order = Order.fromJson(response.data);
        LogService.info('Order placed successfully: ${order.id}');
        ErrorService.showSuccess('Order placed successfully!');
        return order;
      } else {
        LogService.error('Failed to place order: ${response.statusCode}');
        ErrorService.showError('Failed to place order. Please try again.');
        return null;
      }
    } catch (e) {
      LogService.error('Error placing order: $e');
      ErrorService.showError('Failed to place order. Please try again.');
      return null;
    }
  }

  /// Get user's order history
  /// Returns all orders for the current user
  Future<List<Order>> getOrderHistory() async {
    try {
      LogService.info('Fetching order history');

      final response = await _apiService.get('/orders');

      if (response.statusCode == 200) {
        final List<dynamic> ordersData = response.data ?? [];
        final orders = ordersData.map((data) => Order.fromJson(data)).toList();

        LogService.info('Fetched ${orders.length} orders');
        return orders;
      } else {
        LogService.error(
          'Failed to fetch order history: ${response.statusCode}',
        );
        ErrorService.showError('Failed to load orders. Please try again.');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching order history: $e');
      ErrorService.showError('Failed to load orders. Please try again.');
      return [];
    }
  }

  /// Get specific order details by ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      LogService.info('Fetching order details: $orderId');

      final response = await _apiService.get('/orders/$orderId');

      if (response.statusCode == 200) {
        final order = Order.fromJson(response.data);
        LogService.info('Order details fetched successfully');
        return order;
      } else {
        LogService.error(
          'Failed to fetch order details: ${response.statusCode}',
        );
        ErrorService.showError(
          'Failed to load order details. Please try again.',
        );
        return null;
      }
    } catch (e) {
      LogService.error('Error fetching order details: $e');
      ErrorService.showError('Failed to load order details. Please try again.');
      return null;
    }
  }

  // ============================================================================
  // ORDER FILTERING AND SORTING
  // ============================================================================

  /// Get orders by status
  Future<List<Order>> getOrdersByStatus(OrderStatus status) async {
    try {
      LogService.info('Fetching orders by status: ${status.name}');

      final allOrders = await getOrderHistory();
      final filteredOrders = allOrders
          .where((order) => order.status == status)
          .toList();

      LogService.info(
        'Found ${filteredOrders.length} orders with status: ${status.name}',
      );
      return filteredOrders;
    } catch (e) {
      LogService.error('Error fetching orders by status: $e');
      return [];
    }
  }

  /// Get recent orders (last 30 days)
  Future<List<Order>> getRecentOrders({int days = 30}) async {
    try {
      LogService.info('Fetching recent orders (last $days days)');

      final allOrders = await getOrderHistory();
      final cutoffDate = DateTime.now().subtract(Duration(days: days));

      final recentOrders = allOrders
          .where((order) => order.createdAt.isAfter(cutoffDate))
          .toList();

      LogService.info('Found ${recentOrders.length} recent orders');
      return recentOrders;
    } catch (e) {
      LogService.error('Error fetching recent orders: $e');
      return [];
    }
  }

  /// Get pending orders (orders that can be cancelled)
  Future<List<Order>> getPendingOrders() async {
    try {
      LogService.info('Fetching pending orders');

      final allOrders = await getOrderHistory();
      final pendingOrders = allOrders
          .where((order) => order.canBeCancelled)
          .toList();

      LogService.info('Found ${pendingOrders.length} pending orders');
      return pendingOrders;
    } catch (e) {
      LogService.error('Error fetching pending orders: $e');
      return [];
    }
  }

  /// Get delivered orders
  Future<List<Order>> getDeliveredOrders() async {
    try {
      LogService.info('Fetching delivered orders');

      final allOrders = await getOrderHistory();
      final deliveredOrders = allOrders
          .where((order) => order.isDelivered)
          .toList();

      LogService.info('Found ${deliveredOrders.length} delivered orders');
      return deliveredOrders;
    } catch (e) {
      LogService.error('Error fetching delivered orders: $e');
      return [];
    }
  }

  /// Get orders in progress (confirmed, processing, shipped)
  Future<List<Order>> getOrdersInProgress() async {
    try {
      LogService.info('Fetching orders in progress');

      final allOrders = await getOrderHistory();
      final ordersInProgress = allOrders
          .where((order) => order.isInProgress)
          .toList();

      LogService.info('Found ${ordersInProgress.length} orders in progress');
      return ordersInProgress;
    } catch (e) {
      LogService.error('Error fetching orders in progress: $e');
      return [];
    }
  }

  // ============================================================================
  // ORDER STATISTICS
  // ============================================================================

  /// Get order statistics for the user
  Future<Map<String, dynamic>> getOrderStatistics() async {
    try {
      LogService.info('Calculating order statistics');

      final allOrders = await getOrderHistory();

      final totalOrders = allOrders.length;
      final totalSpent = allOrders.fold<double>(
        0.0,
        (sum, order) => sum + order.totalAmount,
      );

      final deliveredOrders = allOrders
          .where((order) => order.isDelivered)
          .length;
      final pendingOrders = allOrders
          .where((order) => order.canBeCancelled)
          .length;
      final cancelledOrders = allOrders
          .where((order) => order.status == OrderStatus.cancelled)
          .length;

      final averageOrderValue = totalOrders > 0
          ? totalSpent / totalOrders
          : 0.0;

      final stats = {
        'total_orders': totalOrders,
        'total_spent': totalSpent,
        'delivered_orders': deliveredOrders,
        'pending_orders': pendingOrders,
        'cancelled_orders': cancelledOrders,
        'average_order_value': averageOrderValue,
        'formatted_total_spent': '₹${totalSpent.toStringAsFixed(2)}',
        'formatted_average_value': '₹${averageOrderValue.toStringAsFixed(2)}',
      };

      LogService.info('Order statistics calculated successfully');
      return stats;
    } catch (e) {
      LogService.error('Error calculating order statistics: $e');
      return {};
    }
  }

  // ============================================================================
  // ORDER VALIDATION
  // ============================================================================

  /// Validate order before placing
  Future<bool> validateOrderPlacement(String addressId) async {
    try {
      LogService.info('Validating order placement');

      // Check if address ID is provided
      if (addressId.isEmpty) {
        ErrorService.showError('Please select a delivery address');
        return false;
      }

      LogService.info('Order validation passed');
      return true;
    } catch (e) {
      LogService.error('Error validating order placement: $e');
      ErrorService.showError('Failed to validate order. Please try again.');
      return false;
    }
  }

  // ============================================================================
  // ORDER TRACKING
  // ============================================================================

  /// Track order status (this would typically call a different endpoint)
  Future<Order?> trackOrder(String orderId) async {
    // For now, this just fetches the order details
    // In a real implementation, this might call a specific tracking endpoint
    return await getOrderById(orderId);
  }

  /// Get order status history (if supported by backend)
  Future<List<Map<String, dynamic>>> getOrderStatusHistory(
    String orderId,
  ) async {
    try {
      LogService.info('Fetching order status history: $orderId');

      // This would typically call a specific endpoint for order history
      // For now, we'll return a mock implementation
      final order = await getOrderById(orderId);
      if (order == null) return [];

      // Mock status history based on current status
      final statusHistory = <Map<String, dynamic>>[];

      statusHistory.add({
        'status': 'pending',
        'timestamp': order.createdAt.toIso8601String(),
        'description': 'Order placed successfully',
      });

      if (order.status != OrderStatus.pending) {
        statusHistory.add({
          'status': 'confirmed',
          'timestamp': order.createdAt
              .add(const Duration(hours: 1))
              .toIso8601String(),
          'description': 'Order confirmed and being prepared',
        });
      }

      if (order.status == OrderStatus.delivered && order.deliveredAt != null) {
        statusHistory.add({
          'status': 'delivered',
          'timestamp': order.deliveredAt!.toIso8601String(),
          'description': 'Order delivered successfully',
        });
      }

      LogService.info('Order status history fetched');
      return statusHistory;
    } catch (e) {
      LogService.error('Error fetching order status history: $e');
      return [];
    }
  }
}
