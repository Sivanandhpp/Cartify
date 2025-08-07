import 'package:get/get.dart';

import '../controllers/buyer_wishlist_controller.dart';

class BuyerWishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerWishlistController>(
      () => BuyerWishlistController(),
    );
  }
}
