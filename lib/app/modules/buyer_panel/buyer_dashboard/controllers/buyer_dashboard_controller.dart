// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BuyerDashboardController extends GetxController {
  final storage = GetStorage();
  final CartService _cartService = Get.find<CartService>();

  // State for Bottom Navigation Bar
  final selectedNavIndex = 0.obs;
  late final PageController pageController;

  // Cart reactive getter
  int get cartItemCount => _cartService.itemCount;

  // Wishlist items
  final RxList<Product> wishlistItems = <Product>[].obs;

  // User profile data
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize page controller
    pageController = PageController(initialPage: 0);

    _loadUserProfile();
    _loadWishlistItems();
  }

  // Load user profile data
  void _loadUserProfile() {
    userProfile.value = {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+91 9876543210',
      'avatar': 'https://via.placeholder.com/100',
      'totalOrders': 25,
      'totalSpent': 45650.75,
      'loyaltyPoints': 1250,
      'memberSince': '2023-01-15',
    };
  }

  // Load wishlist items
  void _loadWishlistItems() {
    wishlistItems.value = [
      const Product(
        id: 'wish_1',
        name: 'Premium Whiskey',
        brand: 'Highland Reserve',
        category: 'Spirits',
        subCategory: 'Whiskey',
        volume: '750ml',
        alcoholContentABV: 40.0,
        priceINR: 4999.0,
        offerPercentage: 20,
        offerPrice: 3999.0,
        rating: 4.5,
        reviewCount: 150,
        description: 'Premium aged whiskey with rich flavor profile',
        imageUrl: AppImages.product1,
      ),
      const Product(
        id: 'wish_2',
        name: 'Craft Beer Pack',
        brand: 'BrewMaster',
        category: 'Beer',
        subCategory: 'Craft Beer',
        volume: '330ml x 6',
        alcoholContentABV: 5.2,
        priceINR: 899.0,
        offerPercentage: 15,
        offerPrice: 764.0,
        rating: 4.7,
        reviewCount: 320,
        description: 'Premium craft beer variety pack with unique flavors',
        imageUrl: AppImages.product2,
      ),
    ];
  }

  void onNavItemTapped(int index) {
    if (selectedNavIndex.value != index) {
      selectedNavIndex.value = index;

      // Animate to the selected page
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // No need to reset fade animation for bottom nav taps
      // This prevents the white screen flash between page transitions
    }
  }

  // Method to add/remove item from wishlist
  void toggleWishlist(Product product) {
    final existingIndex = wishlistItems.indexWhere(
      (item) => item.id == product.id,
    );
    if (existingIndex != -1) {
      wishlistItems.removeAt(existingIndex);
      NotificationService.showInfo(
        title: 'Removed from Wishlist',
        message: '${product.name} removed from your wishlist',
      );
    } else {
      wishlistItems.add(product);
      NotificationService.showSuccess(
        title: 'Added to Wishlist',
        message: '${product.name} added to your wishlist',
      );
    }
  }

  // Check if product is in wishlist
  bool isInWishlist(String productId) {
    return wishlistItems.any((item) => item.id == productId);
  }


  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void logOut() {
    // Use SecureStorageService for proper logout
    final secureStorage = SecureStorageService();
    secureStorage.clearAuthData();
    Get.offAllNamed(Routes.LOGIN);
  }
}
