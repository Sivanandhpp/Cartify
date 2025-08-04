// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports for UI models
import '../../buyer_home/models/category_model.dart';

class BuyerCategoriesController extends GetxController {
  // Navigation bar visibility control
  final isNavBarVisible = true.obs;
  double _lastScrollOffset = 0.0;

  // Loading states
  final RxBool isLoading = false.obs;

  // Data
  final RxList<ProductModel> products = <ProductModel>[].obs;

  // Sample categories data - in production this would come from API
  // Expose categories for the view
  List<UICategoryModel> get categories => _allCategories;

  static final List<UICategoryModel> _allCategories = [
    UICategoryModel(label: 'Fresh Fruits & Vegetables', icon: Icons.eco),
    UICategoryModel(label: 'Dairy & Bakery', icon: Icons.bakery_dining),
    UICategoryModel(label: 'Beverages', icon: Icons.local_drink),
    UICategoryModel(label: 'Snacks & Branded Foods', icon: Icons.local_dining),
    UICategoryModel(label: 'Personal Care', icon: Icons.spa),
    UICategoryModel(label: 'Home & Kitchen', icon: Icons.kitchen),
    UICategoryModel(label: 'Baby Care', icon: Icons.child_care),
    UICategoryModel(label: 'Electronics', icon: Icons.devices),
    UICategoryModel(label: 'Fashion', icon: Icons.shopping_bag),
    UICategoryModel(label: 'Books & Stationery', icon: Icons.book),
    UICategoryModel(label: 'Sports & Fitness', icon: Icons.fitness_center),
    UICategoryModel(label: 'Health & Wellness', icon: Icons.health_and_safety),
  ];

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

  // Navigate to category details
  void onCategoryTap(UICategoryModel category) {
    LogService.info('Navigating to category: ${category.label}');
    // TODO: Implement navigation to category products
    // Get.toNamed(Routes.CATEGORY_PRODUCTS, arguments: category);
  }

  // Handle search
  void onSearch(String query) {
    LogService.info('Searching categories for: $query');
    // TODO: Implement search functionality
  }
}
