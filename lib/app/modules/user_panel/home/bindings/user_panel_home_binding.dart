import 'package:get/get.dart';

import '../controllers/user_panel_home_controller.dart';

class UserPanelHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPanelHomeController>(
      () => UserPanelHomeController(),
    );
  }
}
