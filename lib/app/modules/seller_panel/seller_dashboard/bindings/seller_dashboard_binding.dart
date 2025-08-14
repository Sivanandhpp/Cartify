import 'package:cartify/app/modules/seller_panel/product_form/controllers/product_form_controller.dart';
import 'package:cartify/app/modules/seller_panel/seller_home/controllers/seller_home_controller.dart';
import 'package:get/get.dart';

import '../controllers/seller_dashboard_controller.dart';

class SellerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerDashboardController>(() => SellerDashboardController());
    Get.lazyPut<SellerHomeController>(() => SellerHomeController());
    Get.lazyPut<ProductFormController>(() => ProductFormController());
  }
}
