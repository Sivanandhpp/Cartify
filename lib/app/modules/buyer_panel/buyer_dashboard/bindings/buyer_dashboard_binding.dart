import 'package:get/get.dart';

import '../controllers/buyer_dashboard_controller.dart';

class BuyerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerDashboardController>(
      () => BuyerDashboardController(),
    );
  }
}
