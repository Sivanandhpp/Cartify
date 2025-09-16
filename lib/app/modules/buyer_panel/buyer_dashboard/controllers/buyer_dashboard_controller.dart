import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_categories/controllers/buyer_categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing buyer dashboard navigation and state.
class BuyerDashboardController extends GetxController {
  // -----------------------
  // Reactive Variables
  // -----------------------
  final RxInt selectedNavIndex = 0.obs;

  // -----------------------
  // Private Variables
  // -----------------------
  late final PageController _pageController;

  // -----------------------
  // Getters
  // -----------------------
  PageController get pageController => _pageController;

  // -----------------------
  // Lifecycle
  // -----------------------
  @override
  void onInit() {
    super.onInit();
    _pageController = PageController(initialPage: selectedNavIndex.value);
  }

  @override
  void onClose() {
    _pageController.dispose();
    super.onClose();
  }

  // -----------------------
  // Navigation Methods
  // -----------------------

  /// Handles bottom navigation item taps.
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

  /// Navigates to categories page with optional category pre-selection.
  void navigateToCategories({CategoryModel? selectedCategory}) {
    selectedNavIndex.value = 1;
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    if (selectedCategory != null) {
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

  /// Navigates to categories page and clears any selection (show all).
  void navigateToCategoriesShowAll() {
    selectedNavIndex.value = 1;
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      try {
        final categoriesController = Get.find<BuyerCategoriesController>();
        categoriesController.clearSelection();
      } catch (e) {
        LogService.error('Categories controller not found', e);
      }
    });
  }

  /// Navigates to profile page.
  void navigateToProfile() {
    selectedNavIndex.value = 4;
    _pageController.animateToPage(
      4,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // -----------------------
  // Helper Methods
  // -----------------------

  /// Resets dashboard state (e.g., on logout).
  void resetDashboard() {
    selectedNavIndex.value = 0;
  }
}
