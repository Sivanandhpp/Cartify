import 'package:get/get.dart';

import '../controllers/user_panel_offers_controller.dart';

class UserPanelOffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPanelOffersController>(
      () => UserPanelOffersController(),
    );
  }
}
