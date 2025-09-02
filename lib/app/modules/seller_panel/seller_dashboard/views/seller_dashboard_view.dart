import 'package:cartify/app/modules/seller_panel/seller_dashboard/views/widgets/bottom_nav_bar.dart';
import 'package:cartify/app/modules/seller_panel/seller_home/views/seller_home_view.dart';
import 'package:cartify/app/modules/seller_panel/seller_orders/views/seller_orders_view.dart';
import 'package:cartify/app/modules/seller_panel/seller_products/views/seller_products_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/seller_dashboard_controller.dart';

class SellerDashboardView extends GetView<SellerDashboardController> {
  const SellerDashboardView({super.key});
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
          SellerHomeView(),
          SellerOrdersView(),
          SellerProductsView()
        ],
      ),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }
}
