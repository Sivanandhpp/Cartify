import 'package:cartify/app/core/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../controllers/buyer_cart_controller.dart';

class BuyerCartBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure core services are available
    Get.lazyPut<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
      fenix: true,
    );
    Get.lazyPut<ApiClient>(
      () => ApiClient(Get.find<FlutterSecureStorage>()),
      fenix: true,
    );
    Get.lazyPut<CartService>(
      () => CartService(Get.find<ApiClient>()),
      fenix: true,
    );

    // Controller
    Get.lazyPut<BuyerCartController>(() => BuyerCartController());
  }
}
