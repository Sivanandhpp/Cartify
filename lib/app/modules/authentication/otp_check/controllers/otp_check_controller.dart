// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpCheckController extends GetxController {
  // Use new authentication services
  final AuthApiService _authApiService = Get.find<AuthApiService>();
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();
  final UserApiService _userApiService = Get.find<UserApiService>();
  // --- public --------------------------------------------------------------
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final otpLength = 4;

  // rx
  final filled = <bool>[].obs;
  final RxBool isResending = false.obs;
  final RxBool isVerifying = false.obs;

  // --- private -------------------------------------------------------------
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

      // Verify OTP using new authentication API
      final authTokens = await _authApiService.verifyOtp(mobile, otp);

      if (authTokens != null) {
        LogService.info('OTP verified successfully');

        // Save authentication tokens
        await _authStorageService.saveAuthTokens(authTokens);

        // Fetch and save user profile
        final userProfile = await _userApiService.getUserProfile();
        if (userProfile != null) {
          await _authStorageService.saveUserProfile(userProfile);
        }

        NotificationService.showSuccess(
          title: 'Success',
          message: 'OTP Verified Successfully!',
        );

        // Navigate based on user role
        _navigateBasedOnRole();
      } else {
        LogService.error('OTP verification failed');
        NotificationService.showError(
          title: 'Verification Failed',
          message: 'Invalid OTP. Please try again.',
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

      final success = await _authApiService.requestOtp(mobile);

      if (success) {
        NotificationService.showSuccess(
          title: 'OTP Resent',
          message: 'OTP sent successfully to $mobile',
        );
        LogService.info('OTP resent successfully to: $mobile');
      } else {
        NotificationService.showError(
          title: 'Resend Failed',
          message: 'Failed to resend OTP. Please try again.',
        );
        LogService.error('Failed to resend OTP');
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
  void _navigateBasedOnRole() {
    final user = _authStorageService.currentUser;
    final userRole = user?.role ?? 'BUYER';

    LogService.info('Navigating user based on role: $userRole');

    switch (userRole.toUpperCase()) {
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
