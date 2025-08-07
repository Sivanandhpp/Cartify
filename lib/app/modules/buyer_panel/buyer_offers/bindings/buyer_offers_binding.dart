import 'package:get/get.dart';

import '../controllers/buyer_offers_controller.dart';

class BuyerOffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerOffersController>(
      () => BuyerOffersController(),
    );
  }
}
