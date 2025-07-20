import 'package:get/get.dart';

import '../controllers/user_panel_wishlist_controller.dart';

class UserPanelWishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPanelWishlistController>(
      () => UserPanelWishlistController(),
    );
  }
}
