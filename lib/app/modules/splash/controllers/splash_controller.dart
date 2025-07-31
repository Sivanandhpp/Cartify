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
      // Check authentication status
      if (secureStorage.isAuthenticated) {
        final userRole = secureStorage.getUserRoleFromProfile();
        _navigateBasedOnRole(userRole);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      Get.offAllNamed(Routes.ONBOARDING);
    }

    super.onReady();
  }

  void _navigateBasedOnRole(String userRole) {
    LogService.info('Navigating user based on role: $userRole');

    switch (userRole) {
      case 'admin':
        Get.offAllNamed(Routes.ADMIN_DASHBOARD);
        break;
      case 'seller':
        Get.offAllNamed(Routes.SELLER_DASHBOARD);
        break;
      case 'buyer':
      default:
        Get.offAllNamed(Routes.BUYER_DASHBOARD);
        break;
    }
  }
}
