// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BuyerDashboardController extends GetxController {
  // Services
  final storage = GetStorage();
  final CartService _cartService = Get.find<CartService>();

  // State for Bottom Navigation Bar
  final selectedNavIndex = 0.obs;
  late final PageController pageController;

  // Loading states
  final RxBool isLoading = false.obs;

  // Cart data
  final Rx<CartModel?> _cart = Rx<CartModel?>(null);
  int get cartItemCount {
    if (_cart.value?.items == null) return 0;
    return _cart.value!.items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Wishlist items - using ProductModel
  final RxList<ProductModel> wishlistItems = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize page controller
    pageController = PageController(initialPage: 0);

    _loadWishlistItems();
    _loadCartData();
  }

  // Load cart data
  Future<void> _loadCartData() async {
    try {
      final cartData = await _cartService.getCart();
      _cart.value = cartData;
    } catch (e) {
      LogService.error('Error loading cart: $e');
    }
  }

  // Load wishlist items - For demo purposes
  void _loadWishlistItems() {
    wishlistItems.value = [
      ProductModel(
        id: 'wish_1',
        name: 'Premium Whiskey',
        description: 'Premium aged whiskey with rich flavor profile',
        price: 4999.0,
        stock: 50,
        imageUrls: [AppImages.product1],
      ),
      ProductModel(
        id: 'wish_2',
        name: 'Craft Beer Pack',
        description: 'Premium craft beer collection pack',
        price: 899.0,
        stock: 100,
        imageUrls: [AppImages.product2],
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
  void toggleWishlist(ProductModel product) {
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
