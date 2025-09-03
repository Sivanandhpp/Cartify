import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/seller_panel/seller_dashboard/controllers/seller_dashboard_controller.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SellerHomeController extends GetxController {
  final AuthenticationService authService = Get.find<AuthenticationService>();
  final ProductService productService = Get.find<ProductService>();
  final OrderService orderService = Get.find<OrderService>();
  final UserController userController = Get.find<UserController>();

  // Loading states
  final RxBool isLoading = true.obs;
  final RxBool isDashboardLoading = true.obs;
  final RxBool isRevenueLoading = true.obs;

  // Dashboard stats
  final RxInt totalProducts = 0.obs;
  final RxInt totalOrders = 0.obs;
  final RxInt pendingOrders = 0.obs;
  final RxInt confirmedOrders = 0.obs;
  final RxInt shippedOrders = 0.obs;
  final RxInt deliveredOrders = 0.obs;
  final RxInt activeProducts = 0.obs;
  final RxInt inactiveProducts = 0.obs;
  final RxInt lowStockProducts = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxDouble todayRevenue = 0.0.obs;
  final RxDouble monthlyRevenue = 0.0.obs;
  final RxDouble monthlyGrowth = 0.0.obs;

  // User profile
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString profileImageUrl = ''.obs;

  // Revenue chart data
  final RxList<RevenueDataPoint> revenueData = <RevenueDataPoint>[].obs;
  final RxList<OrderDataPoint> orderData = <OrderDataPoint>[].obs;

  // Recent activity
  final RxList<ActivityItem> recentActivities = <ActivityItem>[].obs;

  // Cache data to minimize API calls
  List<ProductModel> _cachedProducts = [];
  List<OrderModel> _cachedOrders = [];
  DateTime? _lastDataFetch;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    loadUserProfile();
    await loadDashboardData();
  }

  // Load user profile data from cached auth service
  void loadUserProfile() {
    try {
      // final user = authService.currentUser.value;
      final user = userController.user;
      userName.value = user?.name ?? 'Seller';
      userEmail.value = user?.email ?? '';
      profileImageUrl.value = user?.profilePhotoUrl ?? '';

      LogService.debug('User profile loaded from cache', {
        'userName': userName.value,
        'userEmail': userEmail.value,
      });
    } catch (e) {
      LogService.error('Failed to load user profile', e);
    }
  }

  // Main method to load all dashboard data efficiently
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      isDashboardLoading.value = true;

      // Check if we have valid cached data
      if (_shouldUseCachedData()) {
        LogService.info('Using cached dashboard data');
        _calculateStatsFromCache();
        _generateRevenueChartFromCache();
        _generateRecentActivitiesFromCache();
        return;
      }

      // Fetch fresh data directly from services
      await _fetchFreshDashboardData();

      LogService.info('Dashboard data loaded successfully');
    } catch (e) {
      LogService.error('Failed to load dashboard data', e);
      NotificationService.showError(
        title: 'Loading Error',
        message: 'Failed to load dashboard data. Please try again.',
      );
    } finally {
      isLoading.value = false;
      isDashboardLoading.value = false;
    }
  }

  // Check if cached data is still valid
  bool _shouldUseCachedData() {
    if (_lastDataFetch == null) return false;

    final timeSinceLastFetch = DateTime.now().difference(_lastDataFetch!);
    return timeSinceLastFetch < _cacheValidDuration &&
        _cachedProducts.isNotEmpty &&
        _cachedOrders.isNotEmpty;
  }

  // Fetch fresh data from APIs
  Future<void> _fetchFreshDashboardData() async {
    try {
      // Fetch products and orders in parallel to minimize wait time
      final results = await Future.wait([
        productService.getMyProducts(),
        orderService.getMyIncomingOrders(),
      ]);

      _cachedProducts = results[0] as List<ProductModel>;
      _cachedOrders = results[1] as List<OrderModel>;

      // Calculate stats from fetched data
      _calculateStatsFromCache();
      _generateRevenueChartFromCache();
      _generateRecentActivitiesFromCache();

      _lastDataFetch = DateTime.now();
    } catch (e) {
      LogService.error('Failed to fetch fresh dashboard data', e);
      rethrow;
    }
  }

  // Calculate all statistics from cached data
  void _calculateStatsFromCache() {
    _calculateProductStats();
    _calculateOrderStats();
    _calculateRevenueStats();
  }

  // Calculate product statistics from cached data
  void _calculateProductStats() {
    totalProducts.value = _cachedProducts.length;
    activeProducts.value = _cachedProducts
        .where((p) => p.isActive == true)
        .length;
    inactiveProducts.value = _cachedProducts
        .where((p) => p.isActive == false)
        .length;
    lowStockProducts.value = _cachedProducts
        .where((p) => p.stockQuantity < 10)
        .length;

    LogService.debug('Product stats calculated', {
      'total': totalProducts.value,
      'active': activeProducts.value,
      'inactive': inactiveProducts.value,
      'lowStock': lowStockProducts.value,
    });
  }

  // Calculate order statistics from cached data
  void _calculateOrderStats() {
    totalOrders.value = _cachedOrders.length;

    // Count orders by status using the OrderStatus enum
    pendingOrders.value = _cachedOrders
        .where((o) => o.status == OrderStatus.PENDING)
        .length;
    confirmedOrders.value = _cachedOrders
        .where((o) => o.status == OrderStatus.CONFIRMED)
        .length;
    shippedOrders.value = _cachedOrders
        .where((o) => o.status == OrderStatus.SHIPPED)
        .length;
    deliveredOrders.value = _cachedOrders
        .where((o) => o.status == OrderStatus.DELIVERED)
        .length;

    LogService.debug('Order stats calculated', {
      'total': totalOrders.value,
      'pending': pendingOrders.value,
      'confirmed': confirmedOrders.value,
      'shipped': shippedOrders.value,
      'delivered': deliveredOrders.value,
    });
  }

  // Calculate revenue statistics from cached data
  void _calculateRevenueStats() {
    // Calculate total revenue from all orders
    totalRevenue.value = _cachedOrders.fold(
      0.0,
      (sum, order) => sum + order.sellerAmount,
    );

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Today's revenue
    final todayOrders = _cachedOrders.where((order) {
      final orderDate = DateTime(
        order.createdAt.year,
        order.createdAt.month,
        order.createdAt.day,
      );
      return orderDate.isAtSameMomentAs(today);
    });
    todayRevenue.value = todayOrders.fold(
      0.0,
      (sum, order) => sum + order.sellerAmount,
    );

    // Monthly revenue
    final monthlyOrders = _cachedOrders.where(
      (order) =>
          order.createdAt.year == now.year &&
          order.createdAt.month == now.month,
    );
    monthlyRevenue.value = monthlyOrders.fold(
      0.0,
      (sum, order) => sum + order.sellerAmount,
    );

    // Calculate growth compared to previous month
    final lastMonth = DateTime(now.year, now.month - 1);
    final lastMonthOrders = _cachedOrders.where(
      (order) =>
          order.createdAt.year == lastMonth.year &&
          order.createdAt.month == lastMonth.month,
    );
    final lastMonthRevenue = lastMonthOrders.fold(
      0.0,
      (sum, order) => sum + order.sellerAmount,
    );

    if (lastMonthRevenue > 0) {
      monthlyGrowth.value =
          ((monthlyRevenue.value - lastMonthRevenue) / lastMonthRevenue) * 100;
    } else {
      monthlyGrowth.value = monthlyRevenue.value > 0 ? 100.0 : 0.0;
    }

    LogService.debug('Revenue stats calculated', {
      'total': totalRevenue.value,
      'today': todayRevenue.value,
      'monthly': monthlyRevenue.value,
      'growth': monthlyGrowth.value,
    });
  }

  // Generate revenue chart data from cached orders
  void _generateRevenueChartFromCache() {
    try {
      isRevenueLoading.value = true;

      final now = DateTime.now();
      final Map<DateTime, double> dailyRevenue = {};
      final Map<DateTime, int> dailyOrders = {};

      // Initialize last 10 days
      for (int i = 9; i >= 0; i--) {
        final date = DateTime(now.year, now.month, now.day - i);
        dailyRevenue[date] = 0.0;
        dailyOrders[date] = 0;
      }

      // Process cached orders
      for (final order in _cachedOrders) {
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

      // Convert to chart data
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

      LogService.debug('Revenue chart data generated', {
        'revenueDataPoints': revenueData.length,
        'orderDataPoints': orderData.length,
      });
    } catch (e) {
      LogService.error('Failed to generate revenue chart data', e);
    } finally {
      isRevenueLoading.value = false;
    }
  }

  // Generate recent activities from cached data
  void _generateRecentActivitiesFromCache() {
    try {
      recentActivities.clear();

      // Add recent orders (last 3)
      final recentOrders =
          _cachedOrders
              .where(
                (order) => order.createdAt.isAfter(
                  DateTime.now().subtract(const Duration(days: 7)),
                ),
              )
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

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

      // Add low stock alerts (top 2 lowest stock items)
      final lowStockItems =
          _cachedProducts.where((p) => p.stockQuantity < 10).toList()
            ..sort((a, b) => a.stockQuantity.compareTo(b.stockQuantity));

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

      // Add recent inactive products
      final recentInactive = _cachedProducts
          .where((p) => p.isActive == false)
          .take(1);

      for (final product in recentInactive) {
        recentActivities.add(
          ActivityItem(
            title: 'Product Inactive',
            subtitle: '${product.name} is currently inactive',
            time: '1h ago',
            icon: Icons.visibility_off_outlined,
            color: Colors.red,
          ),
        );
      }

      LogService.debug('Recent activities generated', {
        'activities': recentActivities.length,
      });
    } catch (e) {
      LogService.error('Failed to generate recent activities', e);
    }
  }

  // Get color based on order status
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

  // Refresh dashboard - force new API call
  Future<void> refreshDashboard() async {
    _lastDataFetch = null; // Force fresh data
    await loadDashboardData();
  }

  // Navigation methods
  void navigateToAddProduct() {
    Get.toNamed(Routes.SELLER_CREATE_PRODUCT);
  }

  void navigateToViewProducts() {
    // Navigate to products tab in seller dashboard
    try {
      Get.find<SellerDashboardController>().onNavItemTapped(2);
    } catch (e) {
      // Fallback navigation if controller not found
      Get.toNamed('/seller/products');
    }
  }

  void navigateToViewOrders() {
    // Navigate to orders tab in seller dashboard
    try {
      Get.find<SellerDashboardController>().onNavItemTapped(1);
    } catch (e) {
      // Fallback navigation if controller not found
      Get.toNamed('/seller/orders');
    }
  }

  void navigateToProfile() {
    Get.toNamed('/seller/profile');
  }

  void logout() {
    authService.logout();
  }

  // Helper methods
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String get greetingMessage {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Getters for quick access to cached data
  List<ProductModel> get products => _cachedProducts;
  List<OrderModel> get orders => _cachedOrders;

  // Check if data is fresh
  bool get isDataFresh =>
      _lastDataFetch != null &&
      DateTime.now().difference(_lastDataFetch!) < _cacheValidDuration;
}

// Data models for charts (keep the same)
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
