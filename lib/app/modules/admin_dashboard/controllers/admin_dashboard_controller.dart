// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/dashboard_models.dart';
import '../models/product_model.dart' as admin_models;

class AdminDashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final storage = GetStorage();

  // Observable variables
  var selectedIndex = 0.obs;
  var dashboardStats = DashboardStats().obs;
  var products = <admin_models.Product>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var isSidebarOpen = false.obs; // Start with sidebar closed

  // Animation controller for iOS-style transitions
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  // Menu items with iOS-style icons and colors
  final List<AdminMenuItem> menuItems = [
    AdminMenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard_rounded,
      route: '/admin/dashboard',
      color: Colors.blue,
    ),
    AdminMenuItem(
      title: 'Products',
      icon: Icons.inventory_2_rounded,
      route: '/admin/products',
      color: Colors.orange,
    ),
    AdminMenuItem(
      title: 'Orders',
      icon: Icons.shopping_bag_rounded,
      route: '/admin/orders',
      color: Colors.green,
    ),
    AdminMenuItem(
      title: 'Customers',
      icon: Icons.people_rounded,
      route: '/admin/customers',
      color: Colors.purple,
    ),
    AdminMenuItem(
      title: 'Analytics',
      icon: Icons.analytics_rounded,
      route: '/admin/analytics',
      color: Colors.indigo,
    ),
    AdminMenuItem(
      title: 'Settings',
      icon: Icons.settings_rounded,
      route: '/admin/settings',
      color: Colors.grey,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    loadDashboardData();
    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void selectMenuItem(int index) {
    selectedIndex.value = index;
    animationController.reset();
    animationController.forward();
    // Close sidebar when menu item is selected
    isSidebarOpen.value = false;
  }

  void toggleSidebar() {
    isSidebarOpen.value = !isSidebarOpen.value;
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      // Simulate API call with loading
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock data with realistic numbers
      dashboardStats.value = DashboardStats(
        totalProducts: 1247,
        totalOrders: 8932,
        totalUsers: 2847,
        totalRevenue: 542867.50,
        lowStockProducts: 23,
        pendingOrders: 156,
        monthlyRevenue: 89420.75,
        growthPercentage: 23.4,
      );

      // Load sample products
      loadSampleProducts();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loadSampleProducts() {
    products.value = [
      admin_models.Product(
        id: '1',
        name: 'iPhone 15 Pro',
        description: 'Latest iPhone with titanium design and A17 Pro chip',
        price: 999.99,
        discountPrice: 899.99,
        category: 'Electronics',
        subcategory: 'Smartphones',
        brand: 'Apple',
        images: ['assets/images/products/product1.png'],
        specifications: {
          'Storage': '128GB',
          'Color': 'Natural Titanium',
          'Display': '6.1-inch Super Retina XDR',
        },
        tags: ['smartphone', 'apple', 'premium'],
        stockQuantity: 45,
        isActive: true,
        isFeatured: true,
        rating: 4.8,
        reviewCount: 234,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
      admin_models.Product(
        id: '2',
        name: 'MacBook Air M3',
        description: 'Supercharged by the M3 chip, incredibly thin and light',
        price: 1299.99,
        category: 'Electronics',
        subcategory: 'Laptops',
        brand: 'Apple',
        images: ['assets/images/products/product2.png'],
        specifications: {
          'Processor': 'Apple M3',
          'Memory': '8GB',
          'Storage': '256GB SSD',
        },
        tags: ['laptop', 'apple', 'productivity'],
        stockQuantity: 28,
        isActive: true,
        isFeatured: true,
        rating: 4.7,
        reviewCount: 156,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      ),
      admin_models.Product(
        id: '3',
        name: 'Nike Air Max 90',
        description: 'Classic sneaker with modern comfort and style',
        price: 129.99,
        discountPrice: 99.99,
        category: 'Fashion',
        subcategory: 'Shoes',
        brand: 'Nike',
        images: ['assets/images/products/product3.png'],
        specifications: {
          'Size': '10.5',
          'Color': 'White/Black',
          'Material': 'Leather and Mesh',
        },
        tags: ['shoes', 'nike', 'sneakers'],
        stockQuantity: 87,
        isActive: true,
        isFeatured: false,
        rating: 4.5,
        reviewCount: 89,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    // Implement search logic here
  }

  void addProduct(admin_models.Product product) {
    products.add(product);
    dashboardStats.value = dashboardStats.value.copyWith(
      totalProducts: dashboardStats.value.totalProducts + 1,
    );
    Get.snackbar(
      'Success',
      'Product added successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  void updateProduct(admin_models.Product product) {
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
      Get.snackbar(
        'Success',
        'Product updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade800,
        icon: const Icon(Icons.edit, color: Colors.blue),
      );
    }
  }

  void deleteProduct(String productId) {
    products.removeWhere((p) => p.id == productId);
    dashboardStats.value = dashboardStats.value.copyWith(
      totalProducts: dashboardStats.value.totalProducts - 1,
    );
    Get.snackbar(
      'Success',
      'Product deleted successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
      icon: const Icon(Icons.delete, color: Colors.red),
    );
  }

  void logOut() {
    // 💾 Storage Configuration - Clear centralized login data
    storage.remove(AppConfig.loginStatusKey);
    storage.remove(AppConfig.userRoleKey);
    Get.offAllNamed(Routes.LOGIN);
  }
}
