import 'package:bevco/app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_pages.dart';
import '../data/auth_service.dart';

class LoginController extends GetxController {
  LoginController(this._authService);

  final AuthService _authService;

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final RxBool isLoading = false.obs;

  /* ---------- lifecycle ---------- */
  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  /* ---------- validation ---------- */
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return AppStrings.loginErrEmpty;
    if (!AppRegex.phone.hasMatch(value)) return AppStrings.loginErrNumberlength;
    return null;
  }

  /* ---------- actions ---------- */
  void onSendOtpPressed() {
    if (isLoading.value) return;
    sendOtp();
  }

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) {
      _showError(AppStrings.otpsendError);
      return;
    }
    isLoading.value = true;
    try {
      await _authService.sendOtp(phoneController.text);
      _showSuccess(
        AppStrings.otpSent,
        '${AppStrings.otpSentMessage} ${phoneController.text}',
      );
      Get.toNamed(
        Routes.OTP_CHECK,
        arguments: {'mobile': phoneController.text},
      );
    } catch (_) {
      _showError(AppStrings.otpsendError);
    } finally {
      isLoading.value = false;
    }
  }

  /* ---------- helpers ---------- */
  void _showSuccess(String title, String message) => Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    duration: AppDurations.otpSnackbar,
  );

  void _showError(String message) => Get.snackbar(
    AppStrings.error,
    message,
    snackPosition: SnackPosition.TOP,
    duration: AppDurations.otpSnackbar,
  );
}
