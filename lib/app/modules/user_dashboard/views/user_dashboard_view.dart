// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports (relative)
import '../controllers/user_dashboard_controller.dart';
import 'widgets/bottom_nav_bar.dart';
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
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.selectedNavIndex.value = index;
        },
        physics:
            const ClampingScrollPhysics(), // Better physics for smoother navigation
        children: const [
          HomePage(),
          CategoriesPage(),
          WishlistPage(),
          OffersPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: buildBottomNavBar(),
      // Temporary test button to add items to cart (only show on home page)
      floatingActionButton: Obx(
        () => controller.selectedNavIndex.value == 0
            ? FloatingActionButton(
                onPressed: controller.addDemoItemToCart,
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.add_shopping_cart,
                  color: AppColors.white,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
