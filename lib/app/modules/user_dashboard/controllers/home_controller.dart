// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/user_dashboard/controllers/user_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports (relative)
import '../models/category_model.dart';
import '../models/deal_model.dart';
import 'base_dashboard_controller.dart';

/// Home page controller that manages home-specific data and logic
/// Extends base controller for common dashboard functionality
class HomeController extends UserDashboardController {
  // Data for home page sections
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<DealModel> deals = <DealModel>[].obs;
  final RxList<Map<String, dynamic>> hotDealsProducts =
      <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  // Cart service reference
  final CartService _cartService = Get.find<CartService>();

  @override
  void onInit() {
    super.onInit();
    _loadHomeData();
  }

  /// Load home page data
  /// In production, this would make API calls to fetch real data
  Future<void> _loadHomeData() async {
    isLoading.value = true;

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Load categories data
      _loadCategories();

      // Load deals data
      _loadDeals();

      // Load hot deals products
      _loadHotDealsProducts();
    } catch (e) {
      // Handle error - show error message or retry option
      LogService.error('Failed to load home data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load categories data
  /// This would typically fetch from an API or local database
  void _loadCategories() {
    categories.value = [
      CategoryModel(label: 'All', icon: Icons.grid_view),
      CategoryModel(label: 'Maxxsaver', icon: Icons.local_offer),
      CategoryModel(label: 'Fresh', icon: Icons.eco),
      CategoryModel(label: 'Monsoon', icon: Icons.umbrella),
      CategoryModel(label: 'Gadgets', icon: Icons.phone_iphone),
      CategoryModel(label: 'Home', icon: Icons.home_work),
    ];
  }

  /// Load deals data
  /// This would typically fetch from an API or local database
  void _loadDeals() {
    deals.value = [
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

  /// Load hot deals products data
  /// This would typically fetch from an API or local database
  void _loadHotDealsProducts() {
    hotDealsProducts.value = [
      {
        'id': 'onion_01',
        'imageUrl': AppImages.product1,
        'name': 'Onion (Savala)',
        'weight': '1 kg',
        'offerPercentage': 20,
        'originalPrice': 35.0,
        'discountedPrice': 32.0,
      },
      {
        'id': 'lays_01',
        'imageUrl': AppImages.product2,
        'name': "Lay's Hot & Sweet Chilli Potato Chips",
        'weight': '52 g',
        'offerPercentage': 10,
        'originalPrice': 20.0,
        'discountedPrice': 18.0,
        'rating': 4.2,
        'reviewCount': 128,
      },
      {
        'id': 'tomato_01',
        'imageUrl': AppImages.product3,
        'name': 'Tomato (Local)',
        'weight': '500 g',
        'offerPercentage': 15,
        'originalPrice': 25.0,
        'discountedPrice': 21.25,
        'rating': 4.0,
        'reviewCount': 56,
      },
    ];
  }

  /// Refresh home data
  /// Called when user pulls to refresh
  Future<void> refreshData() async {
    await _loadHomeData();
  }

  /// Handle category tap
  /// Navigate to category page or show category products
  ///
  /// [category] - The tapped category
  void onCategoryTapped(CategoryModel category) {
    LogService.info('Category tapped: ${category.label}');
    // TODO: Navigate to category page or filter products
  }

  /// Handle deal tap
  /// Navigate to deal details or product list
  ///
  /// [deal] - The tapped deal
  void onDealTapped(DealModel deal) {
    LogService.info('Deal tapped: ${deal.title}');
    // TODO: Navigate to deal page or show deal products
  }

  /// Handle hot deals "See All" button tap
  void onHotDealsSeeAllTapped() {
    LogService.info('See All button pressed in Hot Deals');
    // TODO: Navigate to all hot deals page
  }

  /// Handle product card tap in hot deals
  /// Navigate to product details sheet
  ///
  /// [product] - The tapped product data
  void onProductTapped(Map<String, dynamic> product) {
    LogService.info('Product card tapped: ${product['name']}');

    // Import the showProductSheet function and call it with product data
    // Note: This would need proper import of the product sheet
    // For now, we'll use Get.toNamed or similar navigation
    // showProductSheet(productData: product);
  }

  /// Add product to cart
  ///
  /// [productId] - The product ID to add to cart
  Future<void> addToCart(String productId) async {
    try {
      // Find the product in hot deals
      final product = hotDealsProducts.firstWhereOrNull(
        (p) => p['id'] == productId,
      );

      if (product == null) {
        LogService.error('Product not found: $productId');
        return;
      }

      // Create a Product model from the map data
      // In production, this would be handled differently
      LogService.info('Add to cart: $productId');

      // TODO: Implement proper cart addition with Product model
      // await _cartService.addToCart(productModel);
    } catch (e) {
      LogService.error('Failed to add product to cart: $e');
    }
  }

  /// Remove product from cart
  ///
  /// [productId] - The product ID to remove from cart
  Future<void> removeFromCart(String productId) async {
    try {
      LogService.info('Remove from cart: $productId');

      // TODO: Implement proper cart removal
      // await _cartService.removeFromCart(productId);
    } catch (e) {
      LogService.error('Failed to remove product from cart: $e');
    }
  }

  /// Get cart quantity for a product
  ///
  /// [productId] - The product ID to check quantity for
  /// Returns the quantity of the product in cart
  int getCartQuantity(String productId) {
    try {
      return _cartService.getQuantity(productId);
    } catch (e) {
      LogService.error('Failed to get cart quantity for $productId: $e');
      return 0;
    }
  }
}
