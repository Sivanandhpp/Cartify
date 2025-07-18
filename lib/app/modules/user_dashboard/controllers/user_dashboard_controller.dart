// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Local imports (relative)
import '../models/category_model.dart';
import '../models/deal_model.dart';

class UserDashboardController extends GetxController {
  final storage = GetStorage();
  // State for Bottom Navigation Bar
  final selectedNavIndex = 0.obs;

  // Data for UI sections
  late final List<CategoryModel> categories;
  late final List<DealModel> deals;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  // A private method to initialize all the data for the screen.
  // API call.
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
        imageUrl: AppImages.offer80,
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

  void onNavItemTapped(int index) {
    selectedNavIndex.value = index;
  }

  void logOut() {
    // storage.erase();
    // TODO:
    storage.remove('isLoggedIn');
    storage.remove('userRole');
    Get.offAllNamed(Routes.LOGIN);
  }
}
