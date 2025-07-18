// Local imports (relative)
import '../../controllers/user_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';

UserDashboardController controller = Get.find<UserDashboardController>();

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
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.reorder),
          label: 'Reorder',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: 'Offers',
        ),
        BottomNavigationBarItem(icon: _buildCartIcon(), label: 'Cart'),
      ],
    ),
  );
}

Widget _buildCartIcon() {
  return Obx(() {
    final itemCount = controller.cartItemCount;
    return Stack(
      children: [
        const Icon(Icons.shopping_cart),
        if (itemCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.white, width: 1),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                itemCount > 99 ? '99+' : itemCount.toString(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  });
}
