// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports
import '../../buyer_home/models/category_model.dart';

class BuyerCategoriesController extends GetxController {
  // Navigation bar visibility control
  final isNavBarVisible = true.obs;
  double _lastScrollOffset = 0.0;

  // Sample categories data - in production this would come from API
  final List<CategoryModel> categories = [
    CategoryModel(
      label: 'Fruits & Vegetables',
      icon: Icons.local_grocery_store,
    ),
    CategoryModel(label: 'Dairy & Bakery', icon: Icons.bakery_dining),
    CategoryModel(label: 'Beverages', icon: Icons.local_drink),
    CategoryModel(label: 'Snacks & Branded Foods', icon: Icons.local_dining),
    CategoryModel(label: 'Personal Care', icon: Icons.spa),
    CategoryModel(label: 'Home & Kitchen', icon: Icons.kitchen),
    CategoryModel(label: 'Baby Care', icon: Icons.child_care),
    CategoryModel(label: 'Electronics', icon: Icons.devices),
    CategoryModel(label: 'Fashion', icon: Icons.shopping_bag),
    CategoryModel(label: 'Books & Stationery', icon: Icons.book),
    CategoryModel(label: 'Sports & Fitness', icon: Icons.fitness_center),
    CategoryModel(label: 'Health & Wellness', icon: Icons.health_and_safety),
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
  void onCategoryTap(CategoryModel category) {
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
