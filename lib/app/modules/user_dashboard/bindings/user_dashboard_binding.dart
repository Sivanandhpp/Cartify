import 'package:get/get.dart';

import '../controllers/user_dashboard_controller.dart';
import '../controllers/product_sheet_controller.dart';

class UserDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserDashboardController>(
      () => UserDashboardController(),
      fenix: true,
    );
    Get.lazyPut<ProductSheetController>(() => ProductSheetController());
  }
}
