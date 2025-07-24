// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports (relative)
import '../data/auth_service.dart';

class LoginController extends GetxController {
  LoginController(this._authService);

  final AuthService _authService;

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final RxBool isLoading = false.obs;

  /* ---------- lifecycle ---------- */
  @override
  void onInit() {
    super.onInit();
    LogService.info('LoginController initialized');
  }

  @override
  void onClose() {
    phoneController.dispose();
    LogService.info('LoginController disposed');
    super.onClose();
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
      await _authService.sendOtp(phoneController.text);

      LogService.info('OTP sent successfully');
      ErrorService.showSuccess(
        '${AppStrings.otpSentMessage} ${phoneController.text}',
      );

      Get.toNamed(
        Routes.OTP_CHECK,
        arguments: {'mobile': phoneController.text},
      );
    } catch (error) {
      LogService.error('Failed to send OTP', error);
      ErrorService.showError(AppStrings.otpsendError);
    } finally {
      isLoading.value = false;
    }
  }
}
