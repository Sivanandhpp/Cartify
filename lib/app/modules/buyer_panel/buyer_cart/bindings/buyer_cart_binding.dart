import 'package:get/get.dart';
import '../controllers/buyer_cart_controller.dart';

class BuyerCartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerCartController>(() => BuyerCartController());
  }
}
