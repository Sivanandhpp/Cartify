// Local imports (relative)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/index.dart';
import '../../controllers/buyer_dashboard_controller.dart';

BuyerDashboardController controller = Get.find<BuyerDashboardController>();

Widget buildBottomNavBar() {
  return Obx(
    () => BottomNavigationBar(
      currentIndex: controller.selectedNavIndex.value,
      onTap: controller.onNavItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      showUnselectedLabels: true,
      elevation: 8,
      iconSize: 26,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
        const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
        const BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Offers'),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    ),
  );
}
