import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDashboardController extends GetxController {
  // State for Bottom Navigation Bar
  final selectedNavIndex = 0.obs;
  PageController? _pageController;

  PageController get pageController {
    _pageController ??= PageController(initialPage: 0);
    return _pageController!;
  }

  @override
  void onInit() {
    super.onInit();
    _initializePageController();
  }

  void _initializePageController() {
    _pageController?.dispose();
    _pageController = PageController(initialPage: selectedNavIndex.value);
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

    @override
  void onReady() {
    super.onReady();
    // Ensure page controller is ready when the view is ready
    if (_pageController == null) {
      _initializePageController();
    }
  }

@override
  void onClose() {
    _pageController?.dispose();
    _pageController = null;
    super.onClose();
  }


}
