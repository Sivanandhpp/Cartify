import 'package:cartify/app/modules/seller_panel/seller_analytics/controllers/seller_analytics_controller.dart';
import 'package:cartify/app/modules/seller_panel/seller_create_product/controllers/seller_create_product_controller.dart';
import 'package:cartify/app/modules/seller_panel/seller_dashboard/controllers/seller_data_controller.dart';
import 'package:cartify/app/modules/seller_panel/seller_home/controllers/seller_home_controller.dart';
import 'package:cartify/app/modules/seller_panel/seller_orders/controllers/seller_orders_controller.dart';
import 'package:cartify/app/modules/seller_panel/seller_products/controllers/seller_products_controller.dart';
import 'package:cartify/app/modules/seller_panel/seller_profile/controllers/seller_profile_controller.dart';
import 'package:get/get.dart';

import '../controllers/seller_dashboard_controller.dart';

class SellerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SellerDataController>(SellerDataController());
    Get.put<SellerDashboardController>(SellerDashboardController(), permanent: true);
    Get.lazyPut<SellerHomeController>(() => SellerHomeController());
    Get.lazyPut<SellerCreateProductController>(() => SellerCreateProductController(),);
    Get.lazyPut<SellerOrdersController>(() => SellerOrdersController());
    Get.lazyPut<SellerProductsController>(() => SellerProductsController());
    Get.lazyPut<SellerAnalyticsController>(() => SellerAnalyticsController(),);
    Get.lazyPut<SellerProfileController>(() => SellerProfileController(),);
  }
}
