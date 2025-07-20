import 'package:get/get.dart';

import '../controllers/user_panel_categories_controller.dart';

class UserPanelCategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserPanelCategoriesController>(
      () => UserPanelCategoriesController(),
    );
  }
}
