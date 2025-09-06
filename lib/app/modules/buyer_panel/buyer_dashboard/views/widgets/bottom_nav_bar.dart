// Local imports (relative)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/index.dart';
import '../../controllers/buyer_dashboard_controller.dart';

BuyerDashboardController bottomNavController =
    Get.find<BuyerDashboardController>();

Widget buildBottomNavBar() {
  return Obx(
    () => Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            blurRadius: 6, // Blur radius for the shadow
            offset: const Offset(
              0,
              -2,
            ), // Offset to make the shadow appear above
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: bottomNavController.selectedNavIndex.value,
        onTap: bottomNavController.onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        showUnselectedLabels: true,
        elevation: 0,
        iconSize: 26,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Offers',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    ),
  );
}
