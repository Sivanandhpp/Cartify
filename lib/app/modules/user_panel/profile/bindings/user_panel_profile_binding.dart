import 'package:get/get.dart';

import '../controllers/user_panel_profile_controller.dart';

class UserPanelProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPanelProfileController>(
      () => UserPanelProfileController(),
    );
  }
}
