import 'package:get/get.dart';

class SellerHomeController extends GetxController {
  // Dashboard stats
  final totalProducts = 245.obs;
  final totalOrders = 89.obs;
  final pendingOrders = 12.obs;
  final totalRevenue = 15420.50.obs;
  final todaySales = 2340.0.obs;
  final monthlyGrowth = 12.5.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loadDashboardData() {
    // Simulate loading data
    // In real app, fetch data from API
  }

  void navigateToAddProduct() {
    // Navigate to add product page
    Get.snackbar('Navigation', 'Navigate to Add Product');
    
  }

  void navigateToViewProducts() {
    // Navigate to view products page
    Get.snackbar('Navigation', 'Navigate to View Products');
  }

  void navigateToViewOrders() {
    // Navigate to view orders page
    Get.snackbar('Navigation', 'Navigate to View Orders');
  }

  void navigateToAnalytics() {
    // Navigate to analytics page
    Get.snackbar('Navigation', 'Navigate to Analytics');
  }

  void navigateToSettings() {
    // Navigate to settings page
    Get.snackbar('Navigation', 'Navigate to Settings');
  }

  void navigateToProfile() {
    // Navigate to profile page
    Get.snackbar('Navigation', 'Navigate to Profile');
  }
}
