import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/seller_panel/seller_dashboard/controllers/seller_dashboard_controller.dart';
import 'package:cartify/app/modules/seller_panel/seller_dashboard/controllers/seller_data_controller.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerHomeController extends GetxController {
  // ===================== DEPENDENCIES =====================
  final SellerDataController _dataController = Get.find<SellerDataController>();
  final AuthenticationService authService = Get.find<AuthenticationService>();
  final UserController userController = Get.find<UserController>();

  // ===================== UI STATE =====================
  final RxBool isRevenueLoading = false.obs;

  // ===================== DASHBOARD STATS =====================
  final RxDouble todayRevenue = 0.0.obs;
  final RxDouble monthlyRevenue = 0.0.obs;
  final RxDouble monthlyGrowth = 0.0.obs;

  // ===================== USER PROFILE =====================
  final RxString userName = ''.obs;
  final RxString profileImageUrl = ''.obs;

  // ===================== CHART DATA =====================
  final RxList<RevenueDataPoint> revenueData = <RevenueDataPoint>[].obs;
  final RxList<OrderDataPoint> orderData = <OrderDataPoint>[].obs;

  // ===================== RECENT ACTIVITY =====================
  final RxList<ActivityItem> recentActivities = <ActivityItem>[].obs;

  // ===================== COMPUTED PROPERTIES =====================

  List<ProductModel> get products => _dataController.products;
  List<OrderModel> get orders => _dataController.orders;
  bool get isLoading => _dataController.isLoading.value;
  int get totalProducts => products.length;
  int get totalOrders => orders.length;
  int get pendingOrders =>
      orders.where((o) => o.status == OrderStatus.PENDING).length;
  int get activeProducts => products.where((p) => p.isActive == true).length;
  int get lowStockProducts =>
      products.where((p) => p.stockQuantity < 10).length;
  bool get isDataFresh => _dataController.isDataLoaded.value;

  // ===================== LIFECYCLE METHODS =====================

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  void _initializeController() {
    loadUserProfile();
    _ensureDataLoaded();

    // Listen to data changes from centralized controller
    ever(_dataController.products, (_) => _calculateStats());
    ever(_dataController.orders, (_) => _calculateStats());

    // Calculate initial stats if data is already available
    if (_dataController.isDataLoaded.value) {
      _calculateStats();
    }
  }

  Future<void> _ensureDataLoaded() async {
    if (!_dataController.isDataLoaded.value) {
      await _dataController.fetchAllData();
    }
  }

  // ===================== DATA OPERATIONS =====================

  void loadUserProfile() {
    try {
      final user = userController.user;
      userName.value = user?.name ?? 'Seller';
      profileImageUrl.value = user?.profilePhotoUrl ?? '';
    } catch (e) {
      LogService.error('Failed to load user profile', e);
    }
  }

  Future<void> refreshDashboard() async {
    try {
      LogService.info('Refreshing seller dashboard');
      await _dataController.refreshData();
      LogService.info('Dashboard refreshed successfully');
    } catch (e) {
      LogService.error('Failed to refresh dashboard', e);
      NotificationService.showError(
        title: 'Refresh Failed',
        message: 'Failed to refresh dashboard data. Please try again.',
      );
    }
  }

  // ===================== STATISTICS CALCULATION =====================

  void _calculateStats() {
    _calculateRevenueStats();
    _generateChartData();
    _generateActivities();
  }

  void _calculateRevenueStats() {
    final now = DateTime.now();

    // Filter orders for this month
    final thisMonthOrders = orders.where(
      (o) => o.createdAt.month == now.month && o.createdAt.year == now.year,
    );

    // Filter orders for today
    final todayOrders = orders.where(
      (o) =>
          o.createdAt.day == now.day &&
          o.createdAt.month == now.month &&
          o.createdAt.year == now.year,
    );

    // Calculate monthly revenue
    monthlyRevenue.value = thisMonthOrders.fold(
      0.0,
      (sum, order) => sum + order.sellerAmount,
    );

    // Calculate today's revenue
    todayRevenue.value = todayOrders.fold(
      0.0,
      (sum, order) => sum + order.sellerAmount,
    );

    // Calculate growth percentage (compared to last month)
    final lastMonthOrders = orders.where(
      (o) => o.createdAt.month == now.month - 1 && o.createdAt.year == now.year,
    );

    final lastMonthRevenue = lastMonthOrders.fold(
      0.0,
      (sum, order) => sum + order.sellerAmount,
    );

    monthlyGrowth.value = lastMonthRevenue > 0
        ? ((monthlyRevenue.value - lastMonthRevenue) / lastMonthRevenue) * 100
        : 100;
  }

  void _generateChartData() {
    try {
      // Only set loading if we have data to process
      if (orders.isNotEmpty) {
        isRevenueLoading.value = true;
      }

      final now = DateTime.now();
      final Map<DateTime, double> dailyRevenue = {};
      final Map<DateTime, int> dailyOrders = {};

      // Initialize last 10 days with zero values
      for (int i = 9; i >= 0; i--) {
        final date = DateTime(now.year, now.month, now.day - i);
        dailyRevenue[date] = 0.0;
        dailyOrders[date] = 0;
      }

      // Process orders and aggregate by date
      for (final order in orders) {
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
    } finally {
      isRevenueLoading.value = false;
    }
  }

  void _generateActivities() {
    recentActivities.clear();

    // Recent orders (last 7 days)
    final recentOrders =
        orders
            .where(
              (order) => order.createdAt.isAfter(
                DateTime.now().subtract(const Duration(days: 7)),
              ),
            )
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Add recent order activities
    for (final order in recentOrders.take(3)) {
      recentActivities.add(
        ActivityItem(
          title: 'New Order #${order.id.substring(0, 8)}',
          subtitle:
              '₹${order.sellerAmount.toStringAsFixed(2)} • ${order.items.length} items',
          time: _formatTimeAgo(order.createdAt),
          icon: Icons.shopping_cart_outlined,
          color: _getOrderStatusColor(order.status),
        ),
      );
    }

    // Low stock alerts
    final lowStockItems =
        products.where((product) => product.stockQuantity < 10).toList()
          ..sort((a, b) => a.stockQuantity.compareTo(b.stockQuantity));

    // Add low stock activities
    for (final product in lowStockItems.take(2)) {
      recentActivities.add(
        ActivityItem(
          title: 'Low Stock Alert',
          subtitle: '${product.name} (${product.stockQuantity} left)',
          time: 'Now',
          icon: Icons.warning_outlined,
          color: Colors.orange,
        ),
      );
    }
  }

  // ===================== NAVIGATION METHODS =====================

  void navigateToAddProduct() => Get.toNamed(Routes.SELLER_CREATE_PRODUCT);

  void navigateToViewProducts() =>
      Get.find<SellerDashboardController>().onNavItemTapped(2);

  void navigateToViewOrders() =>
      Get.find<SellerDashboardController>().onNavItemTapped(1);

  void navigateToProfile() => Get.toNamed('/seller/profile');

  // ===================== UTILITY METHODS =====================

  String get greetingMessage {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Color _getOrderStatusColor(OrderStatus status) {
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
      default:
        return Colors.grey;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}

// ===================== DATA MODELS =====================

class RevenueDataPoint {
  final int day;
  final double amount;
  final DateTime date;

  RevenueDataPoint({
    required this.day,
    required this.amount,
    required this.date,
  });
}

class OrderDataPoint {
  final int day;
  final int orders;
  final DateTime date;

  OrderDataPoint({required this.day, required this.orders, required this.date});
}

class ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });
}
