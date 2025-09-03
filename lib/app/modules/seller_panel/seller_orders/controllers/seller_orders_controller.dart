import 'package:cartify/app/core/models/order/order_item_model.dart';
import 'package:cartify/app/core/models/order/update_order_item_dto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';

class SellerOrdersController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();

  // Observable lists for different order categories
  final RxList<OrderModel> allOrders = <OrderModel>[].obs;
  final RxList<OrderModel> pendingOrders = <OrderModel>[].obs;
  final RxList<OrderModel> confirmedOrders = <OrderModel>[].obs;
  final RxList<OrderModel> shippedOrders = <OrderModel>[].obs;
  final RxList<OrderModel> deliveredOrders = <OrderModel>[].obs;
  final RxList<OrderModel> cancelledOrders = <OrderModel>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  // Filter and search
  final RxString selectedFilter = 'All'.obs;
  final RxString searchQuery = ''.obs;

  // Statistics
  final RxInt totalOrdersCount = 0.obs;
  final RxInt pendingOrdersCount = 0.obs;
  final RxInt todaysOrdersCount = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;

  // Current filtered orders based on selected tab
  RxList<OrderModel> get currentOrders {
    switch (selectedFilter.value) {
      case 'Pending':
        return pendingOrders;
      case 'Confirmed':
        return confirmedOrders;
      case 'Shipped':
        return shippedOrders;
      case 'Delivered':
        return deliveredOrders;
      case 'Cancelled':
        return cancelledOrders;
      default:
        return allOrders;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadOrders();

    // Listen to search changes
    debounce(
      searchQuery,
      (_) => filterOrders(),
      time: const Duration(milliseconds: 500),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Load all seller orders from API
  Future<void> loadOrders() async {
    try {
      isLoading.value = true;

      LogService.info('Loading seller orders');

      final fetchedOrders = await _orderService.getMyIncomingOrders();

      if (fetchedOrders.isNotEmpty) {
        allOrders.assignAll(fetchedOrders);
        categorizeOrders();
        updateStatistics();

        LogService.info(
          'Successfully loaded ${fetchedOrders.length} seller orders',
        );
      } else {
        // Handle empty result
        clearAllOrders();
        LogService.info('No orders found for seller');
      }
    } catch (e) {
      LogService.error('Failed to load seller orders', e);

      NotificationService.showError(
        title: 'Loading Failed',
        message: 'Failed to load orders. Please try again.',
      );

      clearAllOrders();
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh orders (pull to refresh)
  Future<void> refreshOrders() async {
    try {
      isRefreshing.value = true;
      LogService.info('Refreshing seller orders');

      await loadOrders();

      LogService.info('Orders refreshed successfully');
    } catch (e) {
      LogService.error('Failed to refresh orders', e);

      NotificationService.showError(
        title: 'Refresh Failed',
        message: 'Failed to refresh orders. Please try again.',
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Categorize orders by status using the correct enum values
  void categorizeOrders() {
    pendingOrders.clear();
    confirmedOrders.clear();
    shippedOrders.clear();
    deliveredOrders.clear();
    cancelledOrders.clear();

    for (final order in allOrders) {
      // Use the order's overall status directly
      switch (order.status) {
        case OrderStatus.PENDING:
          pendingOrders.add(order);
          break;
        case OrderStatus.CONFIRMED:
          confirmedOrders.add(order);
          break;
        case OrderStatus.SHIPPED:
          shippedOrders.add(order);
          break;
        case OrderStatus.DELIVERED:
          deliveredOrders.add(order);
          break;
        case OrderStatus.CANCELLED:
          cancelledOrders.add(order);
          break;
      }
    }

    LogService.debug('Orders categorized', {
      'pending': pendingOrders.length,
      'confirmed': confirmedOrders.length,
      'shipped': shippedOrders.length,
      'delivered': deliveredOrders.length,
      'cancelled': cancelledOrders.length,
    });
  }

  /// Update statistics
  void updateStatistics() {
    totalOrdersCount.value = allOrders.length;
    pendingOrdersCount.value = pendingOrders.length;

    // Calculate today's orders
    final today = DateTime.now();
    todaysOrdersCount.value = allOrders
        .where(
          (order) =>
              order.createdAt.year == today.year &&
              order.createdAt.month == today.month &&
              order.createdAt.day == today.day,
        )
        .length;

    // Calculate total revenue (exclude cancelled orders)
    totalRevenue.value = allOrders
        .where(
          (order) => !order.items.every(
            (item) => item.status == OrderItemStatus.CANCELLED,
          ),
        )
        .fold(0.0, (sum, order) => sum + order.sellerAmount);

    LogService.debug('Statistics updated', {
      'total': totalOrdersCount.value,
      'pending': pendingOrdersCount.value,
      'todays': todaysOrdersCount.value,
      'revenue': totalRevenue.value,
    });
  }

  /// Accept/Confirm a pending order
  Future<void> acceptOrder(String orderId) async {
    try {
      LogService.business('Accepting order', {'orderId': orderId});

      final order = allOrders.firstWhere((o) => o.id == orderId);

      bool allUpdated = true;
      for (final item in order.items) {
        if (item.status == OrderItemStatus.PENDING) {
          final updatedItem = await _orderService.updateOrderItemStatus(
            item.id,
            UpdateOrderItemDto(
              status: OrderItemStatus.ACCEPTED,
            ), // Changed to ACCEPTED
          );

          if (updatedItem == null) {
            allUpdated = false;
            break;
          }
        }
      }

      if (allUpdated) {
        await loadOrders();

        NotificationService.showSuccess(
          title: 'Order Accepted',
          message:
              'Order #${orderId.substring(0, 8)} has been accepted successfully',
        );

        LogService.business('Order accepted successfully', {
          'orderId': orderId,
        });
      } else {
        throw Exception('Failed to update all order items');
      }
    } catch (e) {
      LogService.error('Failed to accept order', {
        'orderId': orderId,
        'error': e.toString(),
      });

      NotificationService.showError(
        title: 'Accept Failed',
        message: 'Failed to accept order. Please try again.',
      );
    }
  }

  /// Mark order as shipped
  Future<void> markAsShipped(String orderId) async {
    try {
      LogService.business('Marking order as shipped', {'orderId': orderId});

      final order = allOrders.firstWhere((o) => o.id == orderId);

      bool allUpdated = true;
      for (final item in order.items) {
        if (item.status == OrderItemStatus.ACCEPTED) {
          // Changed from CONFIRMED to ACCEPTED
          final updatedItem = await _orderService.updateOrderItemStatus(
            item.id,
            UpdateOrderItemDto(status: OrderItemStatus.SHIPPED),
          );

          if (updatedItem == null) {
            allUpdated = false;
            break;
          }
        }
      }

      if (allUpdated) {
        await loadOrders();

        NotificationService.showSuccess(
          title: 'Order Shipped',
          message:
              'Order #${orderId.substring(0, 8)} has been marked as shipped',
        );

        LogService.business('Order marked as shipped successfully', {
          'orderId': orderId,
        });
      } else {
        throw Exception('Failed to update all order items');
      }
    } catch (e) {
      LogService.error('Failed to mark order as shipped', {
        'orderId': orderId,
        'error': e.toString(),
      });

      NotificationService.showError(
        title: 'Update Failed',
        message: 'Failed to mark order as shipped. Please try again.',
      );
    }
  }

  /// Mark order as delivered
  Future<void> markAsDelivered(String orderId) async {
    try {
      LogService.business('Marking order as delivered', {'orderId': orderId});

      final order = allOrders.firstWhere((o) => o.id == orderId);

      bool allUpdated = true;
      for (final item in order.items) {
        if (item.status == OrderItemStatus.SHIPPED) {
          final updatedItem = await _orderService.updateOrderItemStatus(
            item.id,
            UpdateOrderItemDto(status: OrderItemStatus.DELIVERED),
          );

          if (updatedItem == null) {
            allUpdated = false;
            break;
          }
        }
      }

      if (allUpdated) {
        await loadOrders(); // Refresh to get updated data

        NotificationService.showSuccess(
          title: 'Order Delivered',
          message:
              'Order #${orderId.substring(0, 8)} has been marked as delivered',
        );

        LogService.business('Order marked as delivered successfully', {
          'orderId': orderId,
        });
      } else {
        throw Exception('Failed to update all order items');
      }
    } catch (e) {
      LogService.error('Failed to mark order as delivered', {
        'orderId': orderId,
        'error': e.toString(),
      });

      NotificationService.showError(
        title: 'Update Failed',
        message: 'Failed to mark order as delivered. Please try again.',
      );
    }
  }

  /// Cancel order (if allowed)
  Future<void> cancelOrder(String orderId) async {
    try {
      LogService.business('Cancelling order', {'orderId': orderId});

      final order = allOrders.firstWhere((o) => o.id == orderId);

      bool allUpdated = true;
      for (final item in order.items) {
        // Only allow cancellation of pending or accepted orders
        if (item.status == OrderItemStatus.PENDING ||
            item.status == OrderItemStatus.ACCEPTED) {
          // Changed from CONFIRMED
          final updatedItem = await _orderService.updateOrderItemStatus(
            item.id,
            UpdateOrderItemDto(status: OrderItemStatus.CANCELLED),
          );

          if (updatedItem == null) {
            allUpdated = false;
            break;
          }
        }
      }

      if (allUpdated) {
        await loadOrders();

        NotificationService.showSuccess(
          title: 'Order Cancelled',
          message: 'Order #${orderId.substring(0, 8)} has been cancelled',
        );

        LogService.business('Order cancelled successfully', {
          'orderId': orderId,
        });
      } else {
        throw Exception('Failed to cancel all order items');
      }
    } catch (e) {
      LogService.error('Failed to cancel order', {
        'orderId': orderId,
        'error': e.toString(),
      });

      NotificationService.showError(
        title: 'Cancel Failed',
        message: 'Failed to cancel order. Please try again.',
      );
    }
  }

  /// Change filter tab
  void changeFilter(String filter) {
    selectedFilter.value = filter;
    LogService.debug('Filter changed', {'newFilter': filter});
  }

  /// Search orders
  void searchOrders(String query) {
    searchQuery.value = query;
  }

  /// Filter orders based on search query
  void filterOrders() {
    // This will be handled in the UI by filtering the currentOrders list
    LogService.debug('Filtering orders', {'query': searchQuery.value});
  }

  /// Get orders filtered by search query
  List<OrderModel> get filteredOrders {
    if (searchQuery.value.isEmpty) {
      return currentOrders.toList();
    }

    return currentOrders.where((order) {
      // Search by order ID
      if (order.id.toLowerCase().contains(searchQuery.value.toLowerCase())) {
        return true;
      }

      // Search by customer name
      if (order.shippingAddress.recipientName.toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      )) {
        return true;
      }

      // Search by product names
      return order.items.any(
        (item) => item.productName.toLowerCase().contains(
          searchQuery.value.toLowerCase(),
        ),
      );
    }).toList();
  }

  /// View order details
  void viewOrderDetails(String orderId) {
    LogService.business('Viewing order details', {'orderId': orderId});

    // Navigate to order details page with order data
    final order = allOrders.firstWhere((o) => o.id == orderId);
    Get.toNamed('/seller/order-details', arguments: order);
  }

  /// Helper methods
  void clearAllOrders() {
    allOrders.clear();
    pendingOrders.clear();
    confirmedOrders.clear();
    shippedOrders.clear();
    deliveredOrders.clear();
    cancelledOrders.clear();
    updateStatistics();
  }

  /// Get primary status for an order
  OrderItemStatus getPrimaryOrderStatus(OrderModel order) {
    final statusCounts = <OrderItemStatus, int>{};
    for (final item in order.items) {
      statusCounts[item.status] = (statusCounts[item.status] ?? 0) + 1;
    }

    OrderItemStatus primaryStatus = OrderItemStatus.PENDING;
    int maxCount = 0;
    statusCounts.forEach((status, count) {
      if (count > maxCount) {
        maxCount = count;
        primaryStatus = status;
      }
    });

    return primaryStatus;
  }

  /// Check if order can be accepted
  bool canAcceptOrder(OrderModel order) {
    // Check if any items are pending (using OrderItemStatus.PENDING)
    return order.items.any((item) => item.status == OrderItemStatus.PENDING);
  }

  /// Check if order can be marked as shipped
  bool canMarkAsShipped(OrderModel order) {
    // For OrderItemStatus, use ACCEPTED instead of CONFIRMED based on the enum
    return order.items.any((item) => item.status == OrderItemStatus.ACCEPTED);
  }

  /// Check if order can be marked as delivered
  bool canMarkAsDelivered(OrderModel order) {
    return order.items.any((item) => item.status == OrderItemStatus.SHIPPED);
  }

  /// Check if order can be cancelled
  bool canCancelOrder(OrderModel order) {
    return order.items.any(
      (item) =>
          item.status == OrderItemStatus.PENDING ||
          item.status ==
              OrderItemStatus.ACCEPTED, // Changed from CONFIRMED to ACCEPTED
    );
  }

  /// Get status color for UI (using OrderItemStatus)
  Color getStatusColor(OrderItemStatus status) {
    switch (status) {
      case OrderItemStatus.PENDING:
        return Colors.orange;
      case OrderItemStatus.ACCEPTED: // Changed from CONFIRMED to ACCEPTED
        return Colors.blue;
      case OrderItemStatus.SHIPPED:
        return Colors.purple;
      case OrderItemStatus.DELIVERED:
        return Colors.green;
      case OrderItemStatus.CANCELLED:
        return Colors.red;
      case OrderItemStatus.RETURNED: // Added RETURNED status
        return Colors.brown;
    }
  }

  /// Get status text for UI (using OrderItemStatus)
  String getStatusText(OrderItemStatus status) {
    switch (status) {
      case OrderItemStatus.PENDING:
        return 'PENDING';
      case OrderItemStatus.ACCEPTED: // Changed from CONFIRMED to ACCEPTED
        return 'ACCEPTED';
      case OrderItemStatus.SHIPPED:
        return 'SHIPPED';
      case OrderItemStatus.DELIVERED:
        return 'DELIVERED';
      case OrderItemStatus.CANCELLED:
        return 'CANCELLED';
      case OrderItemStatus.RETURNED: // Added RETURNED status
        return 'RETURNED';
    }
  }

  /// Additional helper method for OrderStatus (if needed for overall order status)
  Color getOrderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.PENDING:
        return Colors.orange;
      case OrderStatus.CONFIRMED:
        return Colors.blue;
      case OrderStatus.SHIPPED:
        return Colors.purple;
      case OrderStatus.DELIVERED:
        return Colors.green;
      case OrderStatus.CANCELLED:
        return Colors.red;
    }
  }

  /// Additional helper method for OrderStatus text
  String getOrderStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.PENDING:
        return 'PENDING';
      case OrderStatus.CONFIRMED:
        return 'CONFIRMED';
      case OrderStatus.SHIPPED:
        return 'SHIPPED';
      case OrderStatus.DELIVERED:
        return 'DELIVERED';
      case OrderStatus.CANCELLED:
        return 'CANCELLED';
    }
  }

  /// Update the filter options to match actual enum values
  List<String> get filterOptions => [
    'All',
    'Pending',
    'Accepted', // Changed from 'Confirmed' to 'Accepted'
    'Shipped',
    'Delivered',
    'Cancelled',
    'Returned', // Added 'Returned' option
  ];
}
