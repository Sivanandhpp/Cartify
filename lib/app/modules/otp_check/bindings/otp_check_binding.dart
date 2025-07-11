import 'package:get/get.dart';

import '../controllers/otp_check_controller.dart';

class OtpCheckBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpCheckController>(
      () => OtpCheckController(),
    );
  }
}
