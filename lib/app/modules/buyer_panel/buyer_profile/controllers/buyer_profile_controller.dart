// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BuyerProfileController extends GetxController {
  final storage = GetStorage();

  // Navigation bar visibility control
  final isNavBarVisible = true.obs;
  double _lastScrollOffset = 0.0;

  // User profile data
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  // Load user profile data - in production this would come from API
  void _loadUserProfile() {
    userProfile.value = {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+91 9876543210',
      'avatar': 'https://via.placeholder.com/100',
      'totalOrders': 25,
      'totalSpent': 45650.75,
      'loyaltyPoints': 1250,
      'memberSince': '2023-01-15',
    };
  }

  // Method to handle scroll changes for nav bar visibility
  void handleScrollUpdate(double offset) {
    const double threshold =
        50.0; // Minimum scroll distance to trigger hide/show

    if (offset > _lastScrollOffset + threshold) {
      // Scrolling down - hide nav bar
      if (isNavBarVisible.value) {
        isNavBarVisible.value = false;
      }
    } else if (offset < _lastScrollOffset - threshold) {
      // Scrolling up - show nav bar
      if (!isNavBarVisible.value) {
        isNavBarVisible.value = true;
      }
    }

    _lastScrollOffset = offset;
  }

  // Navigate to different sections
  void navigateToOrders() {
    LogService.info('Navigating to orders');
    // TODO: Implement navigation to orders
    // Get.toNamed(Routes.ORDERS);
  }

  void navigateToAddresses() {
    LogService.info('Navigating to addresses');
    // TODO: Implement navigation to addresses
    // Get.toNamed(Routes.ADDRESSES);
  }

  void navigateToSettings() {
    LogService.info('Navigating to settings');
    // TODO: Implement navigation to settings
    // Get.toNamed(Routes.SETTINGS);
  }

  void navigateToSupport() {
    LogService.info('Navigating to support');
    // TODO: Implement navigation to support
    // Get.toNamed(Routes.SUPPORT);
  }

  void navigateToAbout() {
    LogService.info('Navigating to about');
    // TODO: Implement navigation to about
    // Get.toNamed(Routes.ABOUT);
  }

  // Edit profile
  void editProfile() {
    LogService.info('Editing profile');
    // TODO: Implement profile editing
    NotificationService.showInfo(
      title: 'Coming Soon',
      message: 'Profile editing feature will be available soon',
    );
  }

  // Logout
  void logOut() {
    // Use SecureStorageService for proper logout
    final secureStorage = SecureStorageService();
    secureStorage.clearAuthData();
    Get.offAllNamed(Routes.LOGIN);
  }
}
