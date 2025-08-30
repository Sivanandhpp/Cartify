import 'package:get/get.dart';

import '../controllers/seller_create_product_controller.dart';

class SellerCreateProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerCreateProductController>(
      () => SellerCreateProductController(),
    );
  }
}
