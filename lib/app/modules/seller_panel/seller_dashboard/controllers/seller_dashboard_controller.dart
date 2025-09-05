import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerDashboardController extends GetxController {
  // State for Bottom Navigation Bar
  final selectedNavIndex = 0.obs;
  late final PageController pageController;
  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
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
    }
  }

  /// Reset state (call this on logout)
  void resetDashboard() {
    selectedNavIndex.value = 0;
    pageController.jumpToPage(0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
