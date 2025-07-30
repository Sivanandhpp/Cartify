// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final storage = GetStorage();
  final secureStorage = SecureStorageService();

  @override
  void onReady() {
    // Check onboarding status
    final isBoarded = storage.read(AppConfig.onboardingStatusKey) ?? false;

    if (isBoarded) {
      // Check authentication status using SecureStorageService
      final isLoggedIn = secureStorage.isLoggedIn;
      final userRole = secureStorage.userRole;

      if (isLoggedIn && secureStorage.isAuthenticated) {
        if (userRole == 'admin') {
          Get.offAllNamed(Routes.ADMIN_DASHBOARD);
        } else {
          Get.offAllNamed(Routes.BUYER_DASHBOARD);
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
