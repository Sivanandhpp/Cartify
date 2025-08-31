import 'package:cartify/app/modules/seller_panel/seller_home/controllers/seller_home_controller.dart';
import 'package:cartify/app/modules/seller_panel/seller_products/controllers/seller_products_controller.dart';
import 'package:get/get.dart';

import '../controllers/seller_dashboard_controller.dart';

class SellerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerDashboardController>(() => SellerDashboardController());
    Get.lazyPut<SellerHomeController>(() => SellerHomeController());
    Get.lazyPut<SellerProductsController>(() => SellerProductsController());
  }
}
