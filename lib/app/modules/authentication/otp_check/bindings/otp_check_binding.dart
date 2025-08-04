import 'package:cartify/app/core/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../controllers/otp_check_controller.dart';

class OtpCheckBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure core services are available, marked as fenix to persist across routes.
    // This prevents them from being disposed when navigating away and back.
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
    Get.lazyPut<UserService>(
      () => UserService(Get.find<ApiClient>()),
      fenix: true,
    );

    // Controller
    Get.lazyPut<OtpCheckController>(
      () => OtpCheckController(
        Get.find<AuthenticationService>(),
        Get.find<UserService>(),
      ),
    );
  }
}
