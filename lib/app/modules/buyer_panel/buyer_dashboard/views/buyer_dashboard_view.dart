// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports (relative)
import '../controllers/buyer_dashboard_controller.dart';
import '../controllers/cart_tracking_controller.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/cart_tracking_card.dart';
import '../../buyer_home/views/buyer_home_view.dart';
import '../../buyer_categories/views/buyer_categories_view.dart';
import '../../buyer_wishlist/views/buyer_wishlist_view.dart';
import '../../buyer_offers/views/buyer_offers_view.dart';
import '../../buyer_profile/views/buyer_profile_view.dart';

class BuyerDashboardView extends GetView<BuyerDashboardController> {
  BuyerDashboardView({super.key});
  final CartTrackingController widgetController =
      Get.find<CartTrackingController>();

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
              BuyerHomeView(),
              BuyerCategoriesView(),
              // BuyerWishlistView(),
              BuyerOffersView(),
              BuyerProfileView(),
            ],
          ),
          // Cart tracking widget with dynamic positioning
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: AnimatedContainer(
          //     duration: const Duration(milliseconds: 300),
          //     child: const CartTrackingWidget(),
          //   ),
          // ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() {
              // Hide widget if cart is empty, based on controller's state
              if (widgetController.isCartEmpty) {
                return const SizedBox.shrink();
              }

              // The UI is now a separate, "dumb" widget.
              // We pass it the data and functions it needs from the controller.
              return CartTrackingCard(
                itemCount: widgetController.itemCount,
                totalQuantity: widgetController.totalQuantity,
                savings: widgetController.totalSavings,
                onTap: widgetController.showExpandedCart,
                onGoToCart: widgetController.goToCart,
                // You can also pass the amount needed for free delivery from the controller
                // deliveryThresholdInfo: 'Shop for ₹10 more to unlock',
              );
            }),
          ),
        ],
      ),
      // Bottom navigation bar
      bottomNavigationBar: buildBottomNavBar(),
    );
  }
}
