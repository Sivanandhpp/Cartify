// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final RxBool isLoading = false.obs;
  final AuthenticationService _authService = Get.find<AuthenticationService>();
  final loginCountryCode = AppStrings.loginCountryCode;

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
    if (!formKey.currentState!.validate()) return;
    final loginPhoneNumber = loginCountryCode + phoneController.text;
    sendOtp(loginPhoneNumber);
  }

  // Send OTP
  Future<void> sendOtp(String phoneNumber) async {
    try {
      final dto = RequestOtpDto(phoneNumber: phoneNumber);
      final success = await _authService.requestOtp(dto);

      if (success) {
        Get.toNamed(Routes.OTP_CHECK, arguments: {'phoneNumber': phoneNumber});
      } else {
        ErrorService.showError('Failed to send OTP');
      }
    } catch (e) {
      ErrorService.showError('Network error occurred');
    }
  }
}
