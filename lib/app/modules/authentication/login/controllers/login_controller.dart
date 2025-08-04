import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  /// Injects the [AuthenticationService] to handle authentication logic.
  LoginController(this._authenticationService);

  final AuthenticationService _authenticationService;

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
  /// Validates the phone number input field.
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
  /// Triggered when the "Send OTP" button is pressed.
  void onSendOtpPressed() {
    if (isLoading.value) return;
    _sendOtp();
  }

  /// Legacy method name for backward compatibility with existing UI.
  Future<void> sendOtp() => _sendOtp();

  /// Validates the form and calls the authentication service to request an OTP.
  Future<void> _sendOtp() async {
    if (!formKey.currentState!.validate()) {
      LogService.warning('Form validation failed');
      ErrorService.showError(AppStrings.otpsendError);
      return;
    }

    isLoading.value = true;
    final phoneNumber = phoneController.text;
    LogService.info('Requesting OTP for: $phoneNumber');

    try {
      final requestDto = RequestOtpDto(phoneNumber: phoneNumber);
      final success = await _authenticationService.requestOtp(requestDto);

      if (success) {
        LogService.info('OTP requested successfully for $phoneNumber');
        ErrorService.showSuccess('OTP has been sent successfully.');

        Get.toNamed(Routes.OTP_CHECK, arguments: {'mobile': phoneNumber});
      } else {
        LogService.error('Failed to request OTP for $phoneNumber');
        ErrorService.showError('Failed to send OTP. Please try again.');
      }
    } catch (error) {
      LogService.error('An unexpected error occurred while sending OTP', error);
      ErrorService.showError(AppStrings.otpsendError);
    } finally {
      isLoading.value = false;
    }
  }
}
