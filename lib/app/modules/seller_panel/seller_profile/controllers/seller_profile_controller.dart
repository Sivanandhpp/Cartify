import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/seller_panel/seller_dashboard/controllers/seller_dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerProfileController extends GetxController {
    final AuthenticationService _authService = Get.find<AuthenticationService>();

  /// Shows logout confirmation dialog
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

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
    } finally {
      Get.find<SellerDashboardController>().resetDashboard();
    }
  }
}
