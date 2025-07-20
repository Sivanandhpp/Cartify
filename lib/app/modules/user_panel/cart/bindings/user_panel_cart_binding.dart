import 'package:get/get.dart';

import '../controllers/user_panel_cart_controller.dart';

class UserPanelCartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPanelCartController>(
      () => UserPanelCartController(),
    );
  }
}
