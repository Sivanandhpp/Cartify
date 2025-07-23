// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports (relative)
import '../controllers/user_dashboard_controller.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/cart_tracking_widget.dart';
import 'home/home_page.dart';
import 'categories/categories_page.dart';
import 'wishlist/wishlist_page.dart';
import 'offers/offers_page.dart';
import 'profile/profile_page.dart';

class UserDashboardView extends GetView<UserDashboardController> {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main content with pages
          PageView(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.selectedNavIndex.value = index;
            },
            physics: const ClampingScrollPhysics(),
            children: const [
              HomePage(),
              CategoriesPage(),
              WishlistPage(),
              OffersPage(),
              ProfilePage(),
            ],
          ),

          // Bottom components that stay above pages
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bottom navigation bar with scroll-based visibility
                Obx(
                  () => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform: Matrix4.translationValues(
                      0,
                      controller.isNavBarVisible.value ? 0 : 100,
                      0,
                    ),
                    child: buildBottomNavBar(),
                  ),
                ),
              ],
            ),
          ),

          // Cart tracking widget with dynamic positioning
          Obx(
            () => Positioned(
              left: 0,
              right: 0,
              bottom: controller.isNavBarVisible.value ? 80 : 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: const CartTrackingWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
