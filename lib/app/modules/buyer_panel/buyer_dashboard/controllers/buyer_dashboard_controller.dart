// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDashboardController extends GetxController {
  // Use new services from core
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();
  final CartApiService _cartApiService = Get.find<CartApiService>();
  final CartStorageService _cartStorageService = Get.find<CartStorageService>();
  final ProductStorageService _productStorageService =
      Get.find<ProductStorageService>();
  final DashboardApiService _dashboardApiService =
      Get.find<DashboardApiService>();
  final DashboardStorageService _dashboardStorageService =
      Get.find<DashboardStorageService>();

  // State for Bottom Navigation Bar
  final selectedNavIndex = 0.obs;
  late final PageController pageController;

  // Observable state
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  // Cart reactive getter
  int get cartItemCount => _cartStorageService.currentCart?.items.length ?? 0;

  // Wishlist items from storage
  List<Product> get wishlistItems =>
      _productStorageService.getWishlistProducts();

  // User profile data from auth storage
  UserProfile? get userProfile => _authStorageService.currentUser;

  // Dashboard data
  final RxList<DashboardSection> dashboardSections = <DashboardSection>[].obs;
  final RxList<Product> featuredProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize page controller
    pageController = PageController(initialPage: 0);

    // Load initial data
    _loadDashboardData();
    _loadFeaturedProducts();
  }

  /// Load dashboard data from API or cache
  Future<void> _loadDashboardData() async {
    try {
      isLoading.value = true;

      // Try to get cached data first
      final cachedSections = _dashboardStorageService.dashboardSections;
      if (cachedSections.isNotEmpty) {
        dashboardSections.value = cachedSections;
      }

      // Fetch fresh data from API
      final sections = await _dashboardApiService.getDashboardData();
      if (sections.isNotEmpty) {
        dashboardSections.value = sections;
        await _dashboardStorageService.saveDashboardData(sections);
      }
    } catch (e) {
      LogService.error('Error loading dashboard data: $e');
      ErrorService.showError('Failed to load dashboard data');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load featured products
  Future<void> _loadFeaturedProducts() async {
    try {
      // Try cached data first
      final cachedProducts = _productStorageService.getCachedFeaturedProducts();
      if (cachedProducts.isNotEmpty) {
        featuredProducts.value = cachedProducts;
      }

      // Fetch fresh data from API
      final ProductApiService productApiService = Get.find<ProductApiService>();
      final products = await productApiService.getFeaturedProducts();
      if (products.isNotEmpty) {
        featuredProducts.value = products;
        await _productStorageService.saveFeaturedProducts(products);
      }
    } catch (e) {
      LogService.error('Error loading featured products: $e');
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    try {
      isRefreshing.value = true;

      // Refresh dashboard sections
      final sections = await _dashboardApiService.getDashboardData();
      if (sections.isNotEmpty) {
        dashboardSections.value = sections;
        await _dashboardStorageService.saveDashboardData(sections);
      }

      // Refresh featured products
      final ProductApiService productApiService = Get.find<ProductApiService>();
      final products = await productApiService.getFeaturedProducts();
      if (products.isNotEmpty) {
        featuredProducts.value = products;
        await _productStorageService.saveFeaturedProducts(products);
      }

      ErrorService.showSuccess('Dashboard refreshed successfully');
    } catch (e) {
      LogService.error('Error refreshing dashboard: $e');
      ErrorService.showError('Failed to refresh dashboard');
    } finally {
      isRefreshing.value = false;
    }
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

  /// Add/remove item from wishlist using product storage service
  Future<void> toggleWishlist(Product product) async {
    try {
      final isCurrentlyInWishlist = _productStorageService.isInWishlist(
        product.id,
      );

      if (isCurrentlyInWishlist) {
        await _productStorageService.removeFromWishlist(product.id);
        NotificationService.showInfo(
          title: 'Removed from Wishlist',
          message: '${product.name} removed from your wishlist',
        );
      } else {
        await _productStorageService.addToWishlist(product);
        NotificationService.showSuccess(
          title: 'Added to Wishlist',
          message: '${product.name} added to your wishlist',
        );
      }
    } catch (e) {
      LogService.error('Error toggling wishlist: $e');
      ErrorService.showError('Failed to update wishlist');
    }
  }

  /// Check if product is in wishlist
  bool isInWishlist(String productId) {
    return _productStorageService.isInWishlist(productId);
  }

  /// Add product to cart
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      final cartItem = await _cartApiService.addItemToCart(
        product.id,
        quantity,
      );
      if (cartItem != null) {
        // Refresh cart data by fetching latest cart
        await _cartApiService.getCart();

        NotificationService.showSuccess(
          title: 'Added to Cart',
          message: '${product.name} added to your cart',
        );
      }
    } catch (e) {
      LogService.error('Error adding to cart: $e');
      ErrorService.showError('Failed to add item to cart');
    }
  }

  /// Navigate to product details
  void navigateToProduct(String productId) {
    // Using existing routes or fallback routes
    Get.toNamed('/product-details', arguments: {'productId': productId});
  }

  /// Navigate to category products
  void navigateToCategory(String categoryId) {
    Get.toNamed('/category-products', arguments: {'categoryId': categoryId});
  }

  /// Navigate to search
  void navigateToSearch({String? query}) {
    Get.toNamed('/search', arguments: query != null ? {'query': query} : null);
  }

  /// Navigate to cart
  void navigateToCart() {
    Get.toNamed(Routes.CART);
  }

  /// Navigate to orders
  void navigateToOrders() {
    // Use available route or fallback
    Get.toNamed('/orders');
  }

  /// Navigate to profile
  void navigateToProfile() {
    // Use available route or fallback
    Get.toNamed('/profile');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// Logout user and clear all data
  Future<void> logOut() async {
    try {
      LogService.info('Logging out user');

      // Clear authentication data
      await _authStorageService.clearAuthData();

      // Navigate to login
      Get.offAllNamed(Routes.LOGIN);

      NotificationService.showSuccess(
        title: 'Logged Out',
        message: 'You have been logged out successfully',
      );
    } catch (e) {
      LogService.error('Error during logout: $e');
      // Still navigate to login even if there's an error
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
