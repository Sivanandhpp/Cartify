import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';

class BuyerOrdersController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  /// Load buyer's order history
  Future<void> loadOrders() async {
    try {
      isLoading.value = true;

      LogService.info('Loading buyer orders');

      final fetchedOrders = await _orderService.getBuyerOrderHistory();
      LogService.info('failed 1 Loading buyer orders');

      orders.assignAll(fetchedOrders);
      LogService.info('failed 2 Loading buyer orders');

      LogService.info('Loaded ${orders.length} buyer orders');
    } catch (e) {
      LogService.error('Error loading buyer orders', e);

      NotificationService.showError(
        title: 'Error',
        message: 'Failed to load your orders. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh orders (pull to refresh)
  Future<void> refreshOrders() async {
    await loadOrders();
  }

  /// View order details
  void viewOrderDetails(String orderId) {
    LogService.business('Viewing order details', {'orderId': orderId});

    // Navigate to order details page
    Get.toNamed(Routes.BUYER_ORDER_STATUS, arguments: orderId);
  }

  /// Cancel an order
  Future<void> cancelOrder(String orderId) async {
    try {
      // Show confirmation dialog
      final shouldCancel = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Cancel Order'),
          content: const Text('Are you sure you want to cancel this order?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (shouldCancel != true) return;

      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      LogService.business('Cancelling order', {'orderId': orderId});

      // Here you would call the cancel order API
      // For now, we'll simulate success
      await Future.delayed(const Duration(seconds: 1));

      // Close loading dialog
      Get.back();

      // Show success message
      NotificationService.showSuccess(
        title: 'Order Cancelled',
        message: 'Your order has been cancelled successfully.',
      );

      // Refresh orders to update the list
      await refreshOrders();
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      LogService.error('Error cancelling order', e);

      NotificationService.showError(
        title: 'Error',
        message: 'Failed to cancel order. Please try again.',
      );
    }
  }

  /// Get orders by status
  List<OrderModel> getOrdersByStatus(OrderStatus status) {
    return orders.where((order) => order.status == status).toList();
  }

  /// Get total number of orders
  int get totalOrders => orders.length;

  /// Get total amount spent
  double get totalAmountSpent {
    return orders.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  /// Check if user has any pending orders
  bool get hasPendingOrders {
    return orders.any((order) => order.status == OrderStatus.PENDING);
  }

  /// Get recent orders (last 5)
  List<OrderModel> get recentOrders {
    final sortedOrders = List<OrderModel>.from(orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return sortedOrders.take(5).toList();
  }

  /// Filter orders by date range
  List<OrderModel> getOrdersByDateRange(DateTime startDate, DateTime endDate) {
    return orders.where((order) {
      return order.createdAt.isAfter(startDate) &&
          order.createdAt.isBefore(endDate);
    }).toList();
  }

  /// Search orders by order ID or item name
  List<OrderModel> searchOrders(String query) {
    if (query.isEmpty) return orders;

    return orders.where((order) {
      // Search by order ID
      if (order.id.toLowerCase().contains(query.toLowerCase())) {
        return true;
      }

      // Search by item names
      return order.items.any(
        (item) => item.productName.toLowerCase().contains(query.toLowerCase()),
      );
    }).toList();
  }
}
