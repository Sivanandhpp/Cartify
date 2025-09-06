// Local imports (relative)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/index.dart';
import '../../controllers/seller_dashboard_controller.dart';

SellerDashboardController controller = Get.find<SellerDashboardController>();

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
        const BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Orders',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.production_quantity_limits),
          label: 'Products',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: 'Analytics',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
  );
}
