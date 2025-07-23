// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
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
  late final PageController pageController;

  // Cart reactive getter
  int get cartItemCount => _cartService.itemCount;

  // Data for UI sections
  late final List<CategoryModel> categories;
  late final List<DealModel> deals;

  // Wishlist items
  final RxList<Product> wishlistItems = <Product>[].obs;

  // User profile data
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize page controller
    pageController = PageController(initialPage: 0);

    _loadData();
    _loadUserProfile();
    _loadWishlistItems();
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
      Product(
        id: 'wish_1',
        name: 'Wireless Headphones',
        description: 'Premium sound quality wireless headphones',
        price: 4999.0,
        discountPrice: 3999.0,
        imageUrl: AppImages.product1,
        category: 'electronics',
        brand: 'SoundMax',
        rating: 4.5,
        reviewCount: 150,
        stockQuantity: 25,
        isInStock: true,
        isFeatured: true,
        isOnSale: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'wish_2',
        name: 'Smart Watch',
        description: 'Feature-rich smartwatch with health tracking',
        price: 8999.0,
        discountPrice: 6999.0,
        imageUrl: AppImages.product2,
        category: 'electronics',
        brand: 'TechWear',
        rating: 4.7,
        reviewCount: 320,
        stockQuantity: 15,
        isInStock: true,
        isFeatured: true,
        isOnSale: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
    // 💾 Storage Configuration - Clear centralized login data
    storage.remove(AppConfig.loginStatusKey);
    storage.remove(AppConfig.userRoleKey);
    Get.offAllNamed(Routes.LOGIN);
  }
}
