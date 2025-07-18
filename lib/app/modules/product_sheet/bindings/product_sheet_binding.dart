import 'package:get/get.dart';

import '../controllers/product_sheet_controller.dart';

class ProductSheetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductSheetController>(
      () => ProductSheetController(),
    );
  }
}

