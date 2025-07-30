import 'package:get/get.dart';

import '../controllers/buyer_home_controller.dart';
import '../controllers/hot_deals_controller.dart';

class BuyerHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerHomeController>(() => BuyerHomeController());
    Get.lazyPut<HotDealsController>(() => HotDealsController());
  }
}
