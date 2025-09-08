import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/seller_panel/seller_dashboard/controllers/seller_data_controller.dart';
import 'package:cartify/app/modules/seller_panel/seller_home/controllers/seller_home_controller.dart';
import 'package:get/get.dart';

class SellerAnalyticsController extends GetxController {
  // ===================== DEPENDENCIES =====================
  final SellerDataController _dataController = Get.find<SellerDataController>();

  // ===================== UI STATE =====================
  final RxBool isLoading = false.obs;

  // ===================== PRODUCT ANALYTICS =====================
  int get totalProducts => _dataController.products.length;
  int get activeProducts =>
      _dataController.products.where((p) => p.isActive == true).length;
  int get inactiveProducts =>
      _dataController.products.where((p) => p.isActive == false).length;
  int get lowStockProducts =>
      _dataController.products.where((p) => p.stockQuantity < 10).length;

  // ===================== ORDER ANALYTICS =====================
  int get totalOrders => _dataController.orders.length;
  int get pendingOrders => _dataController.orders
      .where((o) => o.status == OrderStatus.PENDING)
      .length;
  int get todaysOrders {
    final today = DateTime.now();
    return _dataController.orders
        .where(
          (order) =>
              order.createdAt.year == today.year &&
              order.createdAt.month == today.month &&
              order.createdAt.day == today.day,
        )
        .length;
  }

  int get thisMonthOrders {
    final now = DateTime.now();
    return _dataController.orders
        .where(
          (o) => o.createdAt.month == now.month && o.createdAt.year == now.year,
        )
        .length;
  }

  // ===================== REVENUE ANALYTICS =====================
  double get totalRevenue => _dataController.orders
      .where(
        (order) => !order.items.every(
          (item) => item.status == OrderItemStatus.CANCELLED,
        ),
      )
      .fold(0.0, (sum, order) => sum + order.sellerAmount);

  double get todayRevenue {
    final today = DateTime.now();
    return _dataController.orders
        .where(
          (order) =>
              order.createdAt.year == today.year &&
              order.createdAt.month == today.month &&
              order.createdAt.day == today.day,
        )
        .fold(0.0, (sum, order) => sum + order.sellerAmount);
  }

  double get monthlyRevenue {
    final now = DateTime.now();
    return _dataController.orders
        .where(
          (o) => o.createdAt.month == now.month && o.createdAt.year == now.year,
        )
        .fold(0.0, (sum, order) => sum + order.sellerAmount);
  }

  double get monthlyGrowth {
    final now = DateTime.now();
    final lastMonthOrders = _dataController.orders.where(
      (o) => o.createdAt.month == now.month - 1 && o.createdAt.year == now.year,
    );
    final lastMonthRevenue = lastMonthOrders.fold(
      0.0,
      (sum, order) => sum + order.sellerAmount,
    );
    return lastMonthRevenue > 0
        ? ((monthlyRevenue - lastMonthRevenue) / lastMonthRevenue) * 100
        : 0.0;
  }

  // ===================== CHART DATA =====================
  final RxList<RevenueDataPoint> revenueData = <RevenueDataPoint>[].obs;
  final RxList<OrderDataPoint> orderData = <OrderDataPoint>[].obs;

  @override
  void onInit() {
    super.onInit();
    _generateChartData();
  }

  void _generateChartData() {
    try {
      final now = DateTime.now();
      final Map<DateTime, double> dailyRevenue = {};
      final Map<DateTime, int> dailyOrders = {};

      // Initialize last 30 days with zero values
      for (int i = 29; i >= 0; i--) {
        final date = DateTime(now.year, now.month, now.day - i);
        dailyRevenue[date] = 0.0;
        dailyOrders[date] = 0;
      }

      // Process orders and aggregate by date
      for (final order in _dataController.orders) {
        final orderDate = DateTime(
          order.createdAt.year,
          order.createdAt.month,
          order.createdAt.day,
        );
        if (dailyRevenue.containsKey(orderDate)) {
          dailyRevenue[orderDate] =
              dailyRevenue[orderDate]! + order.sellerAmount;
          dailyOrders[orderDate] = dailyOrders[orderDate]! + 1;
        }
      }

      // Convert to chart data points
      revenueData.clear();
      orderData.clear();

      int dayIndex = 1;
      dailyRevenue.forEach((date, revenue) {
        revenueData.add(
          RevenueDataPoint(day: dayIndex, amount: revenue, date: date),
        );
        dayIndex++;
      });

      dayIndex = 1;
      dailyOrders.forEach((date, orderCount) {
        orderData.add(
          OrderDataPoint(day: dayIndex, orders: orderCount, date: date),
        );
        dayIndex++;
      });
    } catch (e) {
      LogService.error('Failed to generate chart data', e);
    }
  }

  // ===================== REFRESH METHOD =====================
  Future<void> refreshAnalytics() async {
    try {
      isLoading.value = true;
      await _dataController.refreshData();
      _generateChartData();
    } catch (e) {
      LogService.error('Failed to refresh analytics', e);
      NotificationService.showError(
        title: 'Refresh Failed',
        message: 'Failed to refresh analytics data. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===================== HELPER METHODS =====================

  /// Helper function to format numbers with K suffix
  String formatNumber(double value, {bool isCurrency = false}) {
    if (value >= 1000) {
      double formattedValue = value / 1000;
      String formatted = formattedValue.toStringAsFixed(1);
      if (formatted.endsWith('.0')) {
        formatted = formatted.substring(0, formatted.length - 2);
      }
      return isCurrency ? '₹${formatted}K' : '${formatted}K';
    } else {
      return isCurrency ? '₹${value.toInt()}' : value.toInt().toString();
    }
  }
}
