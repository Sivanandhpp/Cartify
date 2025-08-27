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

  /// Reset state (call this on logout)
  void resetDashboard() {
    selectedNavIndex.value = 0;
    _pageController.jumpToPage(0);
  }

  @override
  void onClose() {
    _pageController.dispose();
    super.onClose();
  }
}
