import 'package:cartify/app/modules/buyer_panel/buyer_categories/views/buyer_categories_view.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/views/widgets/bottom_nav_bar.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_home/views/buyer_home_view.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_offers/views/buyer_offers_view.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_profile/views/buyer_profile_view.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_wishlist/views/buyer_wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/buyer_dashboard_controller.dart';

class BuyerDashboardView extends GetView<BuyerDashboardController> {
  const BuyerDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.selectedNavIndex.value = index;
        },
        physics: const ClampingScrollPhysics(),
        children: const [
          BuyerHomeView(),
          BuyerCategoriesView(),
          BuyerWishlistView(),
          BuyerOffersView(),
          BuyerProfileView(),
        ],
      ),
      // floating action button right above the bottom navigation bar
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Container(
      //   padding: const EdgeInsets.all(16),
      //   color: AppColors.primaryBrand,
      //   width: double.infinity,
      //   height: 60,
      //   child: const Column(children: [Text("1 item")]),
      // ),

      bottomNavigationBar: buildBottomNavBar(),
    );
  }
}
