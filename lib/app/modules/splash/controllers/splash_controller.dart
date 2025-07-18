// Core imports (absolute)
import 'package:cartify/app/routes/index.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final storage = GetStorage();

  @override
  void onReady() {
    final isBoarded = storage.read('isBoarded') ?? false;
    final isLoggedIn = storage.read('isLoggedIn') ?? false;
    final userRole = storage.read('userRole') ?? 'user';
    if (isBoarded) {
      if (isLoggedIn) {
        if (userRole == 'admin') {
          Get.offAllNamed(Routes.ADMIN_DASHBOARD);
        } else {
          Get.offAllNamed(Routes.USER_DASHBOARD);
        }
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      Get.offAllNamed(Routes.ONBOARDING);
    }

    super.onReady();
  }
}










