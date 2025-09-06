import 'package:cartify/app/core/models/order/order_item_model.dart';
import 'package:cartify/app/core/models/order/update_order_item_dto.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/seller_panel/seller_dashboard/controllers/seller_data_controller.dart';

class SellerOrdersController extends GetxController {
  // ===================== DEPENDENCIES =====================
  final SellerDataController _dataController = Get.find<SellerDataController>();
  final OrderService _orderService = Get.find<OrderService>();

  // ===================== UI STATE =====================
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString selectedFilter = 'All'.obs;
  final RxString searchQuery = ''.obs;

  // ===================== COMPUTED PROPERTIES =====================

  /// Get all orders from centralized data controller
  List<OrderModel> get allOrders => _dataController.orders;

  /// Get filtered orders based on selected tab and search query
  List<OrderModel> get filteredOrders {
    return _dataController.getFilteredOrders(
      status: selectedFilter.value,
      searchQuery: searchQuery.value,
    );
  }

  /// Statistics
  int get totalOrdersCount => allOrders.length;
  int get pendingOrdersCount =>
      allOrders.where((o) => o.status == OrderStatus.PENDING).length;
  int get todaysOrdersCount {
    final today = DateTime.now();
    return allOrders
        .where(
          (order) =>
              order.createdAt.year == today.year &&
              order.createdAt.month == today.month &&
              order.createdAt.day == today.day,
        )
        .length;
  }

  double get totalRevenue => allOrders
      .where(
        (order) => !order.items.every(
          (item) => item.status == OrderItemStatus.CANCELLED,
        ),
      )
      .fold(0.0, (sum, order) => sum + order.sellerAmount);

  // ===================== LIFECYCLE METHODS =====================

  @override
  void onInit() {
    super.onInit();
    _initializeController();

    // Listen to search changes
    debounce(
      searchQuery,
      (_) => update(),
      time: const Duration(milliseconds: 500),
    );
  }

  void _initializeController() async {
    await _ensureDataLoaded();
    update();
  }

  /// Ensure data is loaded, fetch if not available
  Future<void> _ensureDataLoaded() async {
    if (!_dataController.isDataLoaded.value) {
      await _dataController.fetchAllData();
    }
  }

  // ===================== DATA OPERATIONS =====================

  /// Refresh orders using centralized data controller
  Future<void> refreshOrders() async {
    try {
      isRefreshing.value = true;
      LogService.info('Refreshing seller orders');
      await _dataController.refreshOrders();
      update();
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

  // ===================== ORDER ACTIONS =====================

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
            UpdateOrderItemDto(status: OrderItemStatus.ACCEPTED),
          );
          if (updatedItem == null) {
            allUpdated = false;
            break;
          }
        }
      }

      if (allUpdated) {
        await _dataController.refreshOrders();
        update();
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
        await _dataController.refreshOrders();
        update();
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
        await _dataController.refreshOrders();
        update();
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
        if (item.status == OrderItemStatus.PENDING ||
            item.status == OrderItemStatus.ACCEPTED) {
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
        await _dataController.refreshOrders();
        update();
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

  // ===================== FILTERING & SEARCH =====================

  /// Change filter tab
  void changeFilter(String filter) {
    selectedFilter.value = filter;
    update();
    LogService.debug('Filter changed', {'newFilter': filter});
  }

  /// Search orders
  void searchOrders(String query) {
    searchQuery.value = query;
    // update() will be called by debounce
  }

  // ===================== NAVIGATION =====================

  /// View order details
  void viewOrderDetails(String orderId) {
    LogService.business('Viewing order details', {'orderId': orderId});
    final order = allOrders.firstWhere((o) => o.id == orderId);
    Get.toNamed(Routes.BUYER_ORDER_STATUS, arguments: order);
  }

  // ===================== STATUS HELPERS =====================

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

  bool canAcceptOrder(OrderModel order) =>
      order.items.any((item) => item.status == OrderItemStatus.PENDING);

  bool canMarkAsShipped(OrderModel order) =>
      order.items.any((item) => item.status == OrderItemStatus.ACCEPTED);

  bool canMarkAsDelivered(OrderModel order) =>
      order.items.any((item) => item.status == OrderItemStatus.SHIPPED);

  bool canCancelOrder(OrderModel order) => order.items.any(
        (item) =>
            item.status == OrderItemStatus.PENDING ||
            item.status == OrderItemStatus.ACCEPTED,
      );

  Color getStatusColor(OrderItemStatus status) {
    switch (status) {
      case OrderItemStatus.PENDING:
        return Colors.orange;
      case OrderItemStatus.ACCEPTED:
        return Colors.blue;
      case OrderItemStatus.SHIPPED:
        return Colors.purple;
      case OrderItemStatus.DELIVERED:
        return Colors.green;
      case OrderItemStatus.CANCELLED:
        return Colors.red;
      case OrderItemStatus.RETURNED:
        return Colors.brown;
    }
  }

  String getStatusText(OrderItemStatus status) {
    switch (status) {
      case OrderItemStatus.PENDING:
        return 'PENDING';
      case OrderItemStatus.ACCEPTED:
        return 'ACCEPTED';
      case OrderItemStatus.SHIPPED:
        return 'SHIPPED';
      case OrderItemStatus.DELIVERED:
        return 'DELIVERED';
      case OrderItemStatus.CANCELLED:
        return 'CANCELLED';
      case OrderItemStatus.RETURNED:
        return 'RETURNED';
    }
  }

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

  List<String> get filterOptions => [
        'All',
        'Pending',
        'Accepted',
        'Shipped',
        'Delivered',
        'Cancelled',
        'Returned',
      ];
}