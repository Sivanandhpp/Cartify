// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/data/auth_service.dart';

class OtpCheckController extends GetxController {
  // --- public --------------------------------------------------------------
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final otpLength = 4;

  // rx
  final filled = <bool>[].obs;
  final RxBool isResending = false.obs;
  final RxBool isVerifying = false.obs;

  // --- private -------------------------------------------------------------
  final _authService = AuthService();
  late final List<TextEditingController> _otpControllers;
  late final List<FocusNode> _otpFocusNodes;
  late final List<FocusNode> _rawKeyboardNodes;

  List<TextEditingController> get otpControllers => _otpControllers;
  List<FocusNode> get otpFocusNodes => _otpFocusNodes;
  List<FocusNode> get rawKeyboardNodes => _rawKeyboardNodes;

  // -------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();
    _otpControllers = List.generate(otpLength, (_) => TextEditingController());
    _otpFocusNodes = List.generate(otpLength, (_) => FocusNode());
    _rawKeyboardNodes = List.generate(otpLength, (_) => FocusNode());
    filled.assignAll(List.filled(otpLength, false));
  }

  // -------------------------------------------------------------------------
  void onDigitChanged(int index, String value) {
    filled[index] = value.isNotEmpty;

    // Move focus forward/back as needed
    if (value.isNotEmpty && index < otpLength - 1) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty && index == otpLength - 1) {
      FocusManager.instance.primaryFocus?.unfocus();
      verifyOtp();
    }
  }

  void onBackspacePressed(int index) {
    if (_otpControllers[index].text.isEmpty && index > 0) {
      _otpControllers[index - 1].clear();
      filled[index - 1] = false;
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifyOtp() async {
    if (isVerifying.value) return;

    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != otpLength) {
      NotificationService.showError(
        title: 'Error',
        message: 'Please enter the complete 4-digit OTP',
      );
      return;
    }

    // Get mobile number from navigation arguments
    final mobile = Get.arguments?['mobile'] ?? '';
    if (mobile.isEmpty) {
      NotificationService.showError(
        title: 'Error',
        message: 'Phone number not found. Please go back and try again.',
      );
      return;
    }

    try {
      isVerifying.value = true;
      LogService.info('Verifying OTP: $otp for mobile: $mobile');

      final result = await _authService.verifyOtp(mobile, otp);

      if (result['success'] == true) {
        LogService.info('OTP verified successfully');

        NotificationService.showSuccess(
          title: 'Success',
          message: result['message'] ?? 'OTP Verified!',
        );

        // Get user role and navigate accordingly
        final userRole = _authService.getUserRole();
        _navigateBasedOnRole(userRole);
      } else {
        LogService.error('OTP verification failed: ${result['message']}');
        NotificationService.showError(
          title: 'Verification Failed',
          message: result['message'] ?? 'Invalid OTP. Please try again.',
        );
      }
    } catch (e) {
      LogService.error('Error verifying OTP', e);
      NotificationService.showError(
        title: 'Verification Failed',
        message: AppStrings.networkError,
      );
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> resendOtp(String mobile) async {
    if (isResending.value) return;

    try {
      isResending.value = true;
      LogService.info('Resending OTP to: $mobile');

      final result = await _authService.sendOtp(mobile);

      if (result['success'] == true) {
        NotificationService.showSuccess(
          title: 'OTP Resent',
          message: result['message'],
        );
        LogService.info('OTP resent successfully to: $mobile');
      } else {
        NotificationService.showError(
          title: 'Resend Failed',
          message: result['message'],
        );
        LogService.error('Failed to resend OTP: ${result['message']}');
      }
    } catch (e) {
      LogService.error('Error resending OTP', e);
      NotificationService.showError(
        title: 'Resend Failed',
        message: AppStrings.networkError,
      );
    } finally {
      isResending.value = false;
    }
  }

  // -------------------------------------------------------------------------
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

  void goToLogin() {
    Get.back();
  }

  // -------------------------------------------------------------------------
  @override
  void onClose() {
    scrollController.dispose();
    for (final n in [..._otpFocusNodes, ..._rawKeyboardNodes]) {
      n.dispose();
    }
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
