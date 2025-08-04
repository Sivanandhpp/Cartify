import 'package:cartify/app/core/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Dependencies for AuthenticationService
    Get.lazyPut<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
      fenix: true,
    );
    Get.lazyPut<ApiClient>(
      () => ApiClient(Get.find<FlutterSecureStorage>()),
      fenix: true,
    );
    Get.lazyPut<AuthenticationService>(
      () => AuthenticationService(
        Get.find<ApiClient>(),
        Get.find<FlutterSecureStorage>(),
      ),
      fenix: true,
    );

    // Controller
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<AuthenticationService>()),
    );
  }
}
