// Core imports (absolute)
// import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/core/models/dashboard/banner_model.dart';
import 'package:cartify/app/core/models/dashboard/dashboard_model.dart';
import 'package:cartify/app/core/models/dashboard/product_model.dart' show ProductModel;
import 'package:cartify/app/core/services/cart/cart_service.dart';
import 'package:cartify/app/core/services/dashboard/dashboard_service.dart';
import 'package:cartify/app/core/services/log_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/dashboard/category_model.dart';

class BuyerHomeController extends GetxController {
  // Services
  final CartService _cartService = Get.find<CartService>();
  final DashboardService _dashboardService = Get.find<DashboardService>();

  // Loading states
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Navigation bar visibility control
  final isNavBarVisible = true.obs;
  double _lastScrollOffset = 0.0;

  // Cart reactive getter
  int get cartItemCount => _cartService.itemCount;

  // Dashboard data (reactive)
  final RxList<BannerModel> promotionalBanners = <BannerModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxString featuredProductsTitle = 'Featured Products'.obs;



  @override
  void onInit() {
    super.onInit();
    // _initializeFallbackData();
    _loadDashboardData();
  }

  // Initialize fallback data
  // void _initializeFallbackData() {
  //   fallbackCategories = [
  //     CategoryModel(label: 'All', icon: Icons.grid_view),
  //     CategoryModel(label: 'Maxxsaver', icon: Icons.local_offer),
  //     CategoryModel(label: 'Fresh', icon: Icons.eco),
  //     CategoryModel(label: 'Monsoon', icon: Icons.umbrella),
  //     CategoryModel(label: 'Gadgets', icon: Icons.phone_iphone),
  //     CategoryModel(label: 'Home', icon: Icons.home_work),
  //   ];

  //   fallbackDeals = [
  //     DealModel(
  //       title: 'UP TO\n80%\nOFF',
  //       subtitle: 'WOW DEALS',
  //       color: AppColors.white,
  //       imageUrl: AppImages.offerIcon,
  //     ),
  //     DealModel(
  //       title: 'iPhone\n16 Pro',
  //       subtitle: 'UP TO 20% OFF',
  //       color: AppColors.white,
  //       imageUrl: AppImages.product1,
  //     ),
  //     DealModel(
  //       title: 'Apple\nWatch',
  //       subtitle: 'STARTING ₹46,000/-',
  //       color: AppColors.white,
  //       imageUrl: AppImages.product2,
  //     ),
  //     DealModel(
  //       title: 'Macbook\nPro',
  //       subtitle: 'UP TO 25% OFF',
  //       color: AppColors.white,
  //       imageUrl: AppImages.product3,
  //     ),
  //   ];
  // }

  // Load dashboard data from API
  Future<void> _loadDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      LogService.info('Loading dashboard data...');
      
      final dashboardData = await _dashboardService.getDashboard();
      
      if (dashboardData != null) {
        // Update reactive lists
        promotionalBanners.value = dashboardData.promotionalBanners;
        categories.value = dashboardData.categories.cast<CategoryModel>();
        featuredProducts.value = dashboardData.featuredProducts.cast<ProductModel>();
        featuredProductsTitle.value = dashboardData.featuredProductsTitle ?? 'Featured Products';
        
        LogService.info('Dashboard data loaded successfully');
        LogService.info('- Promotional banners: ${promotionalBanners.length}');
        LogService.info('- Categories: ${categories.length}');
        LogService.info('- Featured products: ${featuredProducts.length}');
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      LogService.error('Error loading dashboard data', e);
      hasError.value = true;
      errorMessage.value = 'Failed to load dashboard data. Please try again.';
      
      // Use fallback data or show error
      // _loadFallbackData();
    } finally {
      isLoading.value = false;
    }
  }

  // Load fallback data when API fails
  // void _loadFallbackData() {
  //   LogService.info('Loading fallback data...');
    
  //   // Convert fallback deals to promotional banners
  //   promotionalBanners.value = fallbackDeals.map((deal) => PromotionalBanner(
  //     title: deal.title,
  //     description: deal.subtitle,
  //     imageUrl: deal.imageUrl,
  //     backgroundColor: '#FFFFFF',
  //   )).toList();
    
  //   // Convert fallback categories to category items
  //   categories.value = fallbackCategories.map((category) => CategoryItem(
  //     name: category.label,
  //     imageUrl: '', // You might want to add image URLs to CategoryModel
  //     categoryId: category.label.toLowerCase(),
  //   )).toList();
  // }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    await _loadDashboardData();
  }

  // // Navigate to category
  // void navigateToCategory(CategoryItem category) {
  //   LogService.info('Navigating to category: ${category.name}');
  //   // Navigate to category screen with categoryId
  //   Get.toNamed('/category', arguments: {
  //     'categoryId': category.categoryId,
  //     'categoryName': category.name,
  //   });
  // }

  // // Navigate to product details
  // void navigateToProduct(FeaturedProduct product) {
  //   LogService.info('Navigating to product: ${product.name}');
  //   Get.toNamed('/product-details', arguments: {
  //     'productId': product.productId,
  //   });
  // }

  // // Handle promotional banner tap
  // void onPromotionalBannerTap(PromotionalBanner banner) {
  //   LogService.info('Promotional banner tapped: ${banner.title}');
    
  //   if (banner.targetId != null) {
  //     // Navigate based on target_id
  //     // You can implement specific navigation logic here
  //     Get.toNamed('/promotion', arguments: {
  //       'targetId': banner.targetId,
  //     });
  //   }
  // }

  // // Add product to cart
  // void addToCart(FeaturedProduct product) {
  //   // Convert FeaturedProduct to your cart item model
  //   // This depends on your CartService implementation
  //   LogService.info('Adding product to cart: ${product.name}');
    
  //   // Example:
  //   // _cartService.addItem(CartItem(
  //   //   id: product.productId,
  //   //   name: product.name,
  //   //   price: product.priceAsDouble,
  //   //   imageUrl: product.imageUrl,
  //   // ));
  // }

  // Method to handle scroll changes for nav bar visibility
  void handleScrollUpdate(double offset) {
    const double threshold = 50.0;

    if (offset > _lastScrollOffset + threshold) {
      if (isNavBarVisible.value) {
        isNavBarVisible.value = false;
      }
    } else if (offset < _lastScrollOffset - threshold) {
      if (!isNavBarVisible.value) {
        isNavBarVisible.value = true;
      }
    }

    _lastScrollOffset = offset;
  }
}