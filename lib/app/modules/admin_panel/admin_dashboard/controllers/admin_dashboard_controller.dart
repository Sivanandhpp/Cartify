import 'package:cartify/app/core/index.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  final AuthenticationService _authService = Get.find<AuthenticationService>();

  /// Handles user logout
  Future<void> logout() async {
    try {
      LogService.info('User logging out');
      await _authService.logout();
    } catch (e) {
      LogService.error('Logout failed: $e');
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to logout',
      );
    }
  }
}
