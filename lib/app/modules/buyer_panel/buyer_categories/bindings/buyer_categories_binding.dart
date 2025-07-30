import 'package:get/get.dart';

import '../controllers/buyer_categories_controller.dart';

class BuyerCategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerCategoriesController>(
      () => BuyerCategoriesController(),
    );
  }
}
