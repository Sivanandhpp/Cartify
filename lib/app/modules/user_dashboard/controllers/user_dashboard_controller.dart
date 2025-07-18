// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Local imports (relative)
import '../models/category_model.dart';
import '../models/deal_model.dart';

class UserDashboardController extends GetxController {
  final storage = GetStorage();
  final CartService _cartService = Get.find<CartService>();

  // State for Bottom Navigation Bar
  final selectedNavIndex = 0.obs;

  // Cart reactive getter
  int get cartItemCount => _cartService.itemCount;

  // Method to add a demo item to cart for testing
  void addDemoItemToCart() {
    // This is just for testing the cart badge functionality
    // In real app, this would be called from product listing
    _cartService.addToCart(
      Product(
        id: 'demo-1',
        name: 'Demo Product',
        description: 'Demo product for testing cart functionality',
        price: 99.0,
        discountPrice: 79.0,
        imageUrl: 'assets/images/products/product1.png',
        category: 'demo',
        brand: 'Demo Brand',
        rating: 4.5,
        reviewCount: 10,
        stockQuantity: 50,
        isInStock: true,
        isFeatured: true,
        isOnSale: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  // Data for UI sections
  late final List<CategoryModel> categories;
  late final List<DealModel> deals;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  // A private method to initialize all the data for the screen.
  // API call.
  void _loadData() {
    categories = [
      CategoryModel(label: 'All', icon: Icons.grid_view),
      CategoryModel(label: 'Maxxsaver', icon: Icons.local_offer),
      CategoryModel(label: 'Fresh', icon: Icons.eco),
      CategoryModel(label: 'Monsoon', icon: Icons.umbrella),
      CategoryModel(label: 'Gadgets', icon: Icons.phone_iphone),
      CategoryModel(label: 'Home', icon: Icons.home_work),
    ];

    deals = [
      DealModel(
        title: 'UP TO\n80%\nOFF',
        subtitle: 'WOW DEALS',
        color: AppColors.white,
        imageUrl: AppImages.offerIcon,
      ),
      DealModel(
        title: 'iPhone\n16 Pro',
        subtitle: 'UP TO 20% OFF',
        color: AppColors.white,
        imageUrl: AppImages.product1,
      ),
      DealModel(
        title: 'Apple\nWatch',
        subtitle: 'STARTING ₹46,000/-',
        color: AppColors.white,
        imageUrl: AppImages.product2,
      ),
      DealModel(
        title: 'Macbook\nPro',
        subtitle: 'UP TO 25% OFF',
        color: AppColors.white,
        imageUrl: AppImages.product3,
      ),
    ];
  }

  void onNavItemTapped(int index) {
    // Navigate to specific pages based on bottom nav selection
    switch (index) {
      case 0:
        // Home - already on dashboard, just update index
        selectedNavIndex.value = index;
        break;
      case 1:
        // Categories - navigate to categories page (if exists)
        selectedNavIndex.value = index;
        // Get.toNamed(Routes.CATEGORIES);
        break;
      case 2:
        // Reorder - navigate to reorder page (if exists)
        selectedNavIndex.value = index;
        // Get.toNamed(Routes.REORDER);
        break;
      case 3:
        // Offers - navigate to offers page (if exists)
        selectedNavIndex.value = index;
        // Get.toNamed(Routes.OFFERS);
        break;
      case 4:
        // Cart - navigate to cart page but don't update index yet
        // Reset to home index after navigation
        Get.toNamed(Routes.CART)?.then((_) {
          selectedNavIndex.value = 0; // Reset to home after returning from cart
        });
        break;
    }
  }

  void logOut() {
    // 💾 Storage Configuration - Clear centralized login data
    storage.remove(AppConfig.loginStatusKey);
    storage.remove(AppConfig.userRoleKey);
    Get.offAllNamed(Routes.LOGIN);
  }
}
