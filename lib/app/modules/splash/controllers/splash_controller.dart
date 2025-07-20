// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final storage = GetStorage();

  @override
  void onReady() {
    // 💾 Storage Configuration - Using centralized AppConfig keys
    final isBoarded = storage.read(AppConfig.onboardingStatusKey) ?? false;
    final isLoggedIn = storage.read(AppConfig.loginStatusKey) ?? false;
    final userRole = storage.read(AppConfig.userRoleKey) ?? 'user';
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



