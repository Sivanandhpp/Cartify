// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports - using aliases to avoid conflicts
import '../models/category_model.dart';
import '../models/deal_model.dart';

class BuyerHomeController extends GetxController {
  // Services
  final CartService _cartService = Get.find<CartService>();

  // Navigation bar visibility control
  final isNavBarVisible = true.obs;
  double _lastScrollOffset = 0.0;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingProducts = false.obs;

  // Cart data
  final Rx<CartModel?> _cart = Rx<CartModel?>(null);
  int get cartItemCount {
    if (_cart.value?.items == null) return 0;
    return _cart.value!.items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Data for UI sections
  final RxList<UICategoryModel> categories = <UICategoryModel>[].obs;
  final RxList<DealModel> deals = <DealModel>[].obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
    _loadCartData();
  }

  // Initialize all the data for the home screen
  void _loadData() {
    categories.assignAll([
      UICategoryModel(label: 'All', icon: Icons.grid_view),
      UICategoryModel(label: 'Maxxsaver', icon: Icons.local_offer),
      UICategoryModel(label: 'Fresh', icon: Icons.eco),
      UICategoryModel(label: 'Monsoon', icon: Icons.umbrella),
      UICategoryModel(label: 'Gadgets', icon: Icons.phone_iphone),
      UICategoryModel(label: 'Home', icon: Icons.home_work),
    ]);

    deals.assignAll([
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
    ]);
  }

  // Method to handle scroll changes for nav bar visibility
  void handleScrollUpdate(double offset) {
    const double threshold =
        50.0; // Minimum scroll distance to trigger hide/show

    if (offset > _lastScrollOffset + threshold) {
      // Scrolling down - hide nav bar
      if (isNavBarVisible.value) {
        isNavBarVisible.value = false;
      }
    } else if (offset < _lastScrollOffset - threshold) {
      // Scrolling up - show nav bar
      if (!isNavBarVisible.value) {
        isNavBarVisible.value = true;
      }
    }

    _lastScrollOffset = offset;
  }

  // Cart operations
  Future<void> _loadCartData() async {
    try {
      final cartData = await _cartService.getCart();
      _cart.value = cartData;
    } catch (e) {
      print('Error loading cart: $e');
    }
  }

  // Navigation methods
  void navigateToCategory(UICategoryModel category) {
    Get.toNamed('/buyer/products', arguments: {'category': category.label});
  }

  void navigateToProduct(ProductModel product) {
    Get.toNamed('/buyer/product-detail', arguments: {'product': product});
  }

  void navigateToCart() {
    Get.toNamed('/buyer/cart');
  }

  void navigateToProfile() {
    Get.toNamed('/buyer/profile');
  }

  void navigateToOrders() {
    Get.toNamed('/buyer/orders');
  }

  void navigateToSearch() {
    Get.toNamed('/buyer/search');
  }

  void navigateToNotifications() {
    Get.toNamed('/buyer/notifications');
  }

  // Refresh functionality
  Future<void> refreshData() async {
    await Future.wait([_loadCartData()]);
  }
}
