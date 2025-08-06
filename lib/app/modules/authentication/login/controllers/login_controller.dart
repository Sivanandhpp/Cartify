// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports (relative)

class LoginController extends GetxController {
  // Use new authentication services
  final AuthApiService _authApiService = Get.find<AuthApiService>();
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final RxBool isLoading = false.obs;

  /* ---------- lifecycle ---------- */
  @override
  void onInit() {
    super.onInit();
    LogService.info('LoginController initialized');
    _checkAuthenticationStatus();
  }

  @override
  void onClose() {
    phoneController.dispose();
    LogService.info('LoginController disposed');
    super.onClose();
  }

  /* ---------- authentication status ---------- */
  /// Check if user is already authenticated and redirect if needed
  void _checkAuthenticationStatus() {
    if (_authStorageService.isLoggedIn) {
      LogService.info('User already authenticated, redirecting to dashboard');
      _navigateBasedOnUserRole();
    }
  }

  /// Navigate user based on their role
  void _navigateBasedOnUserRole() {
    final user = _authStorageService.currentUser;
    if (user != null) {
      switch (user.role.toUpperCase()) {
        case 'ADMIN':
          Get.offAllNamed(Routes.ADMIN_DASHBOARD);
          break;
        case 'SELLER':
          Get.offAllNamed(Routes.SELLER_DASHBOARD);
          break;
        case 'BUYER':
        default:
          Get.offAllNamed(Routes.BUYER_DASHBOARD);
          break;
      }
    } else {
      Get.offAllNamed(Routes.BUYER_DASHBOARD);
    }
  }

  /* ---------- validation ---------- */
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.loginErrEmpty;
    }
    if (!AppRegex.mobileNumber.hasMatch(value)) {
      return AppStrings.loginErrNumber;
    }
    return null;
  }

  /* ---------- actions ---------- */
  void onSendOtpPressed() {
    if (isLoading.value) return;
    sendOtp();
  }

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) {
      LogService.warning('Form validation failed');
      ErrorService.showError(AppStrings.otpsendError);
      return;
    }

    isLoading.value = true;
    LogService.info('Sending OTP to: ${phoneController.text}');

    try {
      final success = await _authApiService.requestOtp(phoneController.text);

      if (success) {
        LogService.info('OTP sent successfully');
        ErrorService.showSuccess(
          'OTP sent successfully to ${phoneController.text}',
        );

        Get.toNamed(
          Routes.OTP_CHECK,
          arguments: {'mobile': phoneController.text},
        );
      } else {
        LogService.error('Failed to send OTP');
        ErrorService.showError('Failed to send OTP. Please try again.');
      }
    } catch (error) {
      LogService.error('Failed to send OTP', error);
      ErrorService.showError(AppStrings.otpsendError);
    } finally {
      isLoading.value = false;
    }
  }
}
