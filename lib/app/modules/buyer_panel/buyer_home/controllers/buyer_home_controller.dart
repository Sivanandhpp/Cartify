import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/controllers/buyer_dashboard_controller.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/controllers/product_sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerHomeController extends GetxController {
  final DashboardService _dashboardService = Get.find<DashboardService>();
  final CartService _cartService = Get.find<CartService>();
  final ProductSheetController _productSheetController =
      Get.find<ProductSheetController>();

  // Reactive variables for dashboard data
  final Rx<DashboardModel?> _dashboardData = Rx<DashboardModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Cart related reactive variables
  final Rx<CartModel?> _cartData = Rx<CartModel?>(null);
  final RxBool _isCartLoading = false.obs;

  // Getters for reactive variables
  DashboardModel? get dashboardData => _dashboardData.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;

  // Cart getters
  CartModel? get cartData => _cartData.value;
  bool get isCartLoading => _isCartLoading.value;
  int get cartItemsCount => _cartData.value?.items.length ?? 0;
  double get cartTotalPrice => _cartData.value?.totalPrice ?? 0.0;

  final Rxn<CategoryModel> selectedCategory =
      Rxn<CategoryModel>(); // null means "All" is selected

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    // selectedCategory remains null by default (meaning "All" is selected)
  }

  /// Loads dashboard data from the API
  Future<void> loadDashboardData() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final dashboard = await _dashboardService.getDashboard();

      if (dashboard != null) {
        _dashboardData.value = dashboard;
      } else {
        _errorMessage.value = 'Failed to load dashboard data';
      }
    } catch (e) {
      _errorMessage.value = 'Error loading dashboard: $e';
      LogService.error('Dashboard loading error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Refreshes dashboard data
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  /// Loads cart data from the API
  Future<void> _loadCart() async {
    try {
      final cart = await _cartService.getCart();
      _cartData.value = cart;
    } catch (e) {
      LogService.error('Cart loading error: $e');
    }
  }

  /// Increments product quantity in cart (adds if not exists)
  Future<void> incrementProductQuantity(String productId) async {
    final success = await _cartService.incrementProductQuantity(productId);
    if (!success) {
      Get.snackbar(
        'Error',
        'Failed to update cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Decrements product quantity in cart (removes if quantity becomes 0)
  Future<void> decrementProductQuantity(String productId) async {
    final success = await _cartService.decrementProductQuantity(productId);
    if (!success) {
      Get.snackbar(
        'Error',
        'Failed to update cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Gets quantity of a specific product in cart
  int getProductQuantityInCart(String productId) {
    return _cartService.getProductQuantityInCart(productId);
  }

  /// Handle category selection from app bar
  void onCategoryTap(CategoryModel? category) {
    selectedCategory.value = category; // Can be null for "All"

    try {
      // Get the dashboard controller to navigate internally
      final dashboardController = Get.find<BuyerDashboardController>();

      if (category == null) {
        // "All" selected - navigate to categories page without pre-selection
        dashboardController.navigateToCategoriesShowAll();
      } else {
        // Specific category selected - navigate with pre-selection
        dashboardController.navigateToCategories(selectedCategory: category);
      }
    } catch (e) {
      LogService.error('Dashboard navigation error', e);
      // Fallback: show error message
      Get.snackbar(
        'Navigation Error',
        'Unable to navigate to categories',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Helper methods for easy access to dashboard sections

  /// Gets promotional banners for display
  List<BannerModel> getPromotionalBanners() {
    return _dashboardData.value?.promotionalBanners ?? [];
  }

  /// Gets categories for the categories grid
  List<CategoryModel> getCategories() {
    return _dashboardData.value?.categories ?? [];
  }

  /// Gets featured products
  List<ProductModel> getFeaturedProducts() {
    return _dashboardData.value?.featuredProducts ?? [];
  }

  /// Gets the title for featured products section
  String getFeaturedProductsTitle() {
    return _dashboardData.value?.featuredProductsTitle ?? 'Featured Products';
  }

  /// Checks if promotional banners are available
  bool hasPromotionalBanners() {
    return getPromotionalBanners().isNotEmpty;
  }

  /// Checks if categories are available
  bool hasCategories() {
    return getCategories().isNotEmpty;
  }

  /// Checks if featured products are available
  bool hasFeaturedProducts() {
    return getFeaturedProducts().isNotEmpty;
  }

  /// Gets a specific section by type
  DashboardSection? getSection(String type) {
    final dashboard = _dashboardData.value;
    if (dashboard == null) return null;

    try {
      return dashboard.sections.firstWhere((section) => section.type == type);
    } catch (e) {
      return null;
    }
  }

  /// Checks if a specific section exists and has data
  bool hasSectionData(String type) {
    final section = getSection(type);
    return section != null && section.data.isNotEmpty;
  }

  /// Gets all available section types
  List<String> getAvailableSectionTypes() {
    final dashboard = _dashboardData.value;
    if (dashboard == null) return [];

    return dashboard.sections.map((section) => section.type).toList();
  }

  /// Gets the number of items in a specific section
  int getSectionItemCount(String type) {
    final section = getSection(type);
    return section?.data.length ?? 0;
  }

  // Show Product sheet
  void showProductSheet(BuildContext context, ProductModel product) {
    _productSheetController.showProductSheet(context, product);
  }
}
