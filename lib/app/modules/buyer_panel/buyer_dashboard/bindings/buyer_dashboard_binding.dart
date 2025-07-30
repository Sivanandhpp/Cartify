import 'package:get/get.dart';

import '../controllers/buyer_dashboard_controller.dart';
import '../../buyer_home/bindings/buyer_home_binding.dart';

class BuyerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerDashboardController>(() => BuyerDashboardController());

    // Initialize buyer home dependencies
    BuyerHomeBinding().dependencies();
  }
}
