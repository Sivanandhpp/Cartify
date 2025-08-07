// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final storageService = StorageService();
  // Use existing UserController from dependency injection
  final userController = Get.find<UserController>();
  final AuthenticationService authService = Get.find<AuthenticationService>();

  @override
  void onReady() {
    super.onReady();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      // Check onboarding status
      if (storageService.isBoarded) {
        final isLoggedIn = await authService.isLoggedIn();
        // Load user data from storage (now async)
        final user = await userController.getUserFromStorage();
        // Check authentication status
        if (user != null && isLoggedIn) {
          // Get user role with proper null handling
          final userRole = userController.user?.role ?? 'buyer';
          LogService.info('User loaded with role: $userRole');
          _navigateBasedOnRole(userRole);
        } else {
          LogService.info('User not authenticated, navigating to login');
          Get.offAllNamed(Routes.LOGIN);
        }
      } else {
        LogService.info('User not onboarded, navigating to onboarding');
        Get.offAllNamed(Routes.ONBOARDING);
      }
    } catch (e) {
      LogService.error('Error during app initialization', e);
      // Fallback to login on any error
      Get.offAllNamed(Routes.LOGIN);
    }
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
