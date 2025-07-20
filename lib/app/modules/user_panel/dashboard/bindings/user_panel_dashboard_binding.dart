import 'package:get/get.dart';

import '../controllers/user_panel_dashboard_controller.dart';

class UserPanelDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPanelDashboardController>(
      () => UserPanelDashboardController(),
    );
  }
}
