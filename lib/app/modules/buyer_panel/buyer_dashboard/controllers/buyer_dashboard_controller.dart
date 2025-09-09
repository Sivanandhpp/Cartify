import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_categories/controllers/buyer_categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDashboardController extends GetxController {
  final selectedNavIndex = 0.obs;
  late PageController _pageController;

  PageController get pageController => _pageController;

  @override
  void onInit() {
    super.onInit();
    _pageController = PageController(initialPage: selectedNavIndex.value);
  }

  void onNavItemTapped(int index) {
    if (selectedNavIndex.value != index) {
      selectedNavIndex.value = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Method to navigate to categories with optional category pre-selection
  void navigateToCategories({CategoryModel? selectedCategory}) {
    // Navigate to categories page (index 1)
    selectedNavIndex.value = 1;
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // If a specific category is provided, pass it to the categories controller
    if (selectedCategory != null) {
      // Wait a bit for the page to load, then select the category
      Future.delayed(const Duration(milliseconds: 100), () {
        try {
          final categoriesController = Get.find<BuyerCategoriesController>();
          categoriesController.selectCategoryDirectly(selectedCategory);
        } catch (e) {
          LogService.error('Categories controller not found', e);
        }
      });
    }
  }

  /// Navigate to categories and clear any selection (show all categories)
  void navigateToCategoriesShowAll() {
    selectedNavIndex.value = 1;
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Clear any category selection
    Future.delayed(const Duration(milliseconds: 100), () {
      try {
        final categoriesController = Get.find<BuyerCategoriesController>();
        categoriesController.clearSelection();
      } catch (e) {
        LogService.error('Categories controller not found', e);
      }
    });
  }

  /// Reset state (call this on logout)
  void resetDashboard() {
    selectedNavIndex.value = 0;
  }

  @override
  void onClose() {
    _pageController.dispose();
    super.onClose();
  }
}
