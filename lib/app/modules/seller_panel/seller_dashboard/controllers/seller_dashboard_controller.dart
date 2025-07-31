import 'package:get/get.dart';
import '../../../../core/services/secure_storage_service.dart';

class SellerDashboardController extends GetxController {
  //TODO: Implement SellerDashboardController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  /// Logout method to clear authentication data and navigate to login
  Future<void> logout() async {
    try {
      // Clear authentication data
      final secureStorage = SecureStorageService();
      await secureStorage.clearAuthData();

      // Navigate to login screen
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
