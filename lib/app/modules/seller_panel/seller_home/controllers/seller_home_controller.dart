import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/seller_panel/seller_dashboard/controllers/seller_dashboard_controller.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerHomeController extends GetxController {
  // Service dependencies
  final AuthenticationService authService = Get.find<AuthenticationService>();
  final ProductService productService = Get.find<ProductService>();
  final OrderService orderService = Get.find<OrderService>();
  final UserController userController = Get.find<UserController>();

  // Loading states (consolidated to one main loading state)
  final RxBool isLoading = true.obs;
  final RxBool isRevenueLoading = true.obs;

  // Dashboard stats
  final RxInt totalProducts = 0.obs;
  final RxInt totalOrders = 0.obs;
  final RxInt pendingOrders = 0.obs;
  final RxInt activeProducts = 0.obs;
  final RxInt lowStockProducts = 0.obs;
  final RxDouble todayRevenue = 0.0.obs;
  final RxDouble monthlyRevenue = 0.0.obs;
  final RxDouble monthlyGrowth = 0.0.obs;

  // User profile
  final RxString userName = ''.obs;
  final RxString profileImageUrl = ''.obs;

  // Chart data
  final RxList<RevenueDataPoint> revenueData = <RevenueDataPoint>[].obs;
  final RxList<OrderDataPoint> orderData = <OrderDataPoint>[].obs;

  // Recent activity
  final RxList<ActivityItem> recentActivities = <ActivityItem>[].obs;

  // Cache data (simplified)
  List<ProductModel> _cachedProducts = [];
  List<OrderModel> _cachedOrders = [];
  DateTime? _lastDataFetch;
  static const Duration _cacheDuration = Duration(minutes: 5);

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    loadUserProfile();
    await loadDashboardData();
  }

  // Load user profile
  void loadUserProfile() {
    try {
      final user = userController.user;
      userName.value = user?.name ?? 'Seller';
      profileImageUrl.value = user?.profilePhotoUrl ?? '';
    } catch (e) {
      LogService.error('Failed to load user profile', e);
    }
  }

  // Main data loading method
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      // Use cache if valid, otherwise fetch fresh data
      if (_isCacheValid()) {
        _loadFromCache();
      } else {
        await _fetchFreshData();
      }
    } catch (e) {
      LogService.error('Failed to load dashboard data', e);
      NotificationService.showError(
        title: 'Loading Error',
        message: 'Failed to load dashboard data. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Check if cache is valid
  bool _isCacheValid() {
    return _lastDataFetch != null &&
        DateTime.now().difference(_lastDataFetch!) < _cacheDuration &&
        _cachedProducts.isNotEmpty &&
        _cachedOrders.isNotEmpty;
  }

  // Load data from cache
  void _loadFromCache() {
    _calculateStats();
    _generateChartData();
    _generateActivities();
  }

  // Fetch fresh data
  Future<void> _fetchFreshData() async {
    final results = await Future.wait([
      productService.getMyProducts(),
      orderService.getMyIncomingOrders(),
    ]);

    _cachedProducts = results[0] as List<ProductModel>;
    _cachedOrders = results[1] as List<OrderModel>;
    _lastDataFetch = DateTime.now();

    _calculateStats();
    _generateChartData();
    _generateActivities();
  }

  // Calculate all statistics
  void _calculateStats() {
    _calculateProductStats();
    _calculateOrderStats();
    _calculateRevenueStats();
  }

  // Product statistics
  void _calculateProductStats() {
    totalProducts.value = _cachedProducts.length;
    activeProducts.value = _cachedProducts
        .where((p) => p.isActive == true)
        .length;
    lowStockProducts.value = _cachedProducts
        .where((p) => p.stockQuantity < 10)
        .length;
  }

  // Order statistics
  void _calculateOrderStats() {
    totalOrders.value = _cachedOrders.length;
    pendingOrders.value = _cachedOrders
        .where((o) => o.status == OrderStatus.PENDING)
        .length;
  }

  // Revenue statistics
  void _calculateRevenueStats() {
    final now = DateTime.now();
    final thisMonth = _cachedOrders.where(
      (o) => o.createdAt.month == now.month && o.createdAt.year == now.year,
    );
    final today = _cachedOrders.where(
      (o) =>
          o.createdAt.day == now.day &&
          o.createdAt.month == now.month &&
          o.createdAt.year == now.year,
    );

    monthlyRevenue.value = thisMonth.fold(
      0.0,
      (sum, o) => sum + o.sellerAmount,
    );
    todayRevenue.value = today.fold(0.0, (sum, o) => sum + o.sellerAmount);

    // Calculate growth (simplified)
    final lastMonth = _cachedOrders.where(
      (o) => o.createdAt.month == now.month - 1 && o.createdAt.year == now.year,
    );
    final lastMonthRevenue = lastMonth.fold(
      0.0,
      (sum, o) => sum + o.sellerAmount,
    );
    monthlyGrowth.value = lastMonthRevenue > 0
        ? ((monthlyRevenue.value - lastMonthRevenue) / lastMonthRevenue) * 100
        : 0.0;
  }

  // Generate chart data
  void _generateChartData() {
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

      // Process orders
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
    } catch (e) {
      LogService.error('Failed to generate chart data', e);
    } finally {
      isRevenueLoading.value = false;
    }
  }

  // Generate recent activities
  void _generateActivities() {
    recentActivities.clear();

    // Recent orders
    final recentOrders =
        _cachedOrders
            .where(
              (o) => o.createdAt.isAfter(
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

    // Low stock alerts
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
  }

  // Helper methods
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

  String get greetingMessage {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // Navigation methods
  void navigateToAddProduct() => Get.toNamed(Routes.SELLER_CREATE_PRODUCT);
  void navigateToViewProducts() =>
      Get.find<SellerDashboardController>().onNavItemTapped(2);
  void navigateToViewOrders() =>
      Get.find<SellerDashboardController>().onNavItemTapped(1);
  void navigateToProfile() => Get.toNamed('/seller/profile');
  void logout() => authService.logout();

  // Refresh data
  Future<void> refreshDashboard() async {
    _lastDataFetch = null;
    await loadDashboardData();
  }

  // Getters
  List<ProductModel> get products => _cachedProducts;
  List<OrderModel> get orders => _cachedOrders;
  bool get isDataFresh => _isCacheValid();
}

// Data models (consider moving to separate file)
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
