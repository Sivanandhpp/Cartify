// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports
import '../models/category_model.dart';
import '../models/deal_model.dart';

class BuyerHomeController extends GetxController {
  // Cart service
  final CartService _cartService = Get.find<CartService>();

  // Navigation bar visibility control
  final isNavBarVisible = true.obs;
  double _lastScrollOffset = 0.0;

  // Cart reactive getter
  int get cartItemCount => _cartService.itemCount;

  // Data for UI sections
  late final List<CategoryModel> categories;
  late final List<DealModel> deals;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  // Initialize all the data for the home screen
  void _loadData() {
    categories = [
      CategoryModel(label: 'All', icon: Icons.grid_view),
      CategoryModel(label: 'Maxxsaver', icon: Icons.local_offer),
      CategoryModel(label: 'Fresh', icon: Icons.eco),
      CategoryModel(label: 'Monsoon', icon: Icons.umbrella),
      CategoryModel(label: 'Gadgets', icon: Icons.phone_iphone),
      CategoryModel(label: 'Home', icon: Icons.home_work),
    ];

    deals = [
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
    ];
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
}
