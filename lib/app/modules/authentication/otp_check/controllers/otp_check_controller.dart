// Core imports (absolute)
import 'dart:async';

import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpCheckController extends GetxController {
  // --- Public ----------------------------------------------------------------
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final otpLength = 4;
  final AuthenticationService _authService = Get.find<AuthenticationService>();
  final UserController userController = Get.find<UserController>();

  // Reactive variables
  final filled = <bool>[].obs;
  final RxBool isResending = false.obs;
  final RxBool isVerifying = false.obs;
  final RxInt resendCountdown = 0.obs;
  final RxBool canResend = true.obs;

  // Timer for countdown
  Timer? _countdownTimer;

  // --- Private ---------------------------------------------------------------
  late final List<TextEditingController> _otpControllers;
  late final List<FocusNode> _otpFocusNodes;
  late final List<FocusNode> _rawKeyboardNodes;

  // Getters for controllers and focus nodes
  List<TextEditingController> get otpControllers => _otpControllers;
  List<FocusNode> get otpFocusNodes => _otpFocusNodes;
  List<FocusNode> get rawKeyboardNodes => _rawKeyboardNodes;

  // Get phone number from navigation arguments
  String get phoneNumber => Get.arguments?['phoneNumber'] ?? '';

  // ---------------------------------------------------------------------------
  @override
  void onInit() {
    super.onInit();
    _otpControllers = List.generate(otpLength, (_) => TextEditingController());
    _otpFocusNodes = List.generate(otpLength, (_) => FocusNode());
    _rawKeyboardNodes = List.generate(otpLength, (_) => FocusNode());
    filled.assignAll(List.filled(otpLength, false));
  }

  // ---------------------------------------------------------------------------
  /// Called when a digit in the OTP field changes.
  void onDigitChanged(int index, String value) {
    filled[index] = value.isNotEmpty;

    // Move focus forward/back as needed
    if (value.isNotEmpty && index < otpLength - 1) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty && index == otpLength - 1) {
      FocusManager.instance.primaryFocus?.unfocus();
      onVerifyOtpPressed();
    }
  }

  /// Handles backspace press in OTP fields.
  void onBackspacePressed(int index) {
    if (_otpControllers[index].text.isEmpty && index > 0) {
      _otpControllers[index - 1].clear();
      filled[index - 1] = false;
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  /// Clears all OTP fields and resets focus.
  void clearOtpFields() {
    for (int i = 0; i < _otpControllers.length; i++) {
      _otpControllers[i].clear();
      filled[i] = false;
    }
    if (_otpFocusNodes.isNotEmpty) {
      _otpFocusNodes[0].requestFocus();
    }
  }

  // ---------------------------------------------------------------------------
  /// Validates the OTP and phone number input.
  /// Returns an error message if validation fails, otherwise null.
  String? validateOtpInput() {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != otpLength) {
      return 'Please enter the complete 4-digit OTP';
    }
    if (phoneNumber.isEmpty) {
      return 'Phone number not found. Please go back and try again.';
    }
    return null;
  }

  /// Handles the OTP verification process.
  Future<void> verifyOtp() async {
    if (isVerifying.value) return;
    // --- Actual Verification ---
    final otp = _otpControllers.map((c) => c.text).join();
    try {
      isVerifying.value = true;
      LogService.info('Verifying OTP: $otp for mobile: $phoneNumber');

      final dto = VerifyOtpDto(phoneNumber: phoneNumber, otpCode: otp);
      final status = await _authService.verifyOtp(dto);

      if (status) {
        LogService.info('OTP verified successfully');
        // Store authentication status
        await StorageService().storeAuthStatus(true);

        // Get user role from userController (default to 'buyer' if null)
        final userRole = userController.user?.role ?? 'buyer';
        LogService.info('User loaded with role: $userRole');
        _navigateBasedOnRole(userRole);
      } else {
        LogService.error('OTP verification failed');
        // Clear OTP fields when verification fails
        clearOtpFields();
        NotificationService.showError(
          title: 'Verification Failed',
          message: 'Invalid OTP. Please try again.',
        );
      }
    } catch (e) {
      LogService.error('Error verifying OTP', e);
      // Clear OTP fields when there's an error
      clearOtpFields();
      NotificationService.showError(
        title: 'Verification Failed',
        message: AppStrings.networkError,
      );
    } finally {
      isVerifying.value = false;
    }
  }

  /// Navigates user to the appropriate dashboard based on their role.
  void _navigateBasedOnRole(String userRole) {
    LogService.info('Navigating user based on role: $userRole');

    switch (userRole.toLowerCase()) {
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

  /// Requests a new OTP for the given mobile number.
  Future<void> resendOtp(String mobile) async {
    if (isResending.value || !canResend.value) return;

    try {
      isResending.value = true;
      LogService.info('Resending OTP to: $mobile');

      final dto = RequestOtpDto(phoneNumber: mobile);
      final success = await _authService.requestOtp(dto);

      if (success) {
        NotificationService.showSuccess(
          title: 'OTP Resent',
          message: 'A new OTP has been sent to your phone number.',
        );
        LogService.info('OTP resent successfully to: $mobile');

        // Clear current OTP fields
        clearOtpFields();

        // Start countdown timer
        _startCountdownTimer();
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

  /// Starts the 5-minute countdown timer for resend restriction.
  void _startCountdownTimer() {
    canResend.value = false;
    resendCountdown.value = 300; // 5 minutes in seconds

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  /// Formats the countdown time to MM:SS format.
  String get formattedCountdown {
    final minutes = resendCountdown.value ~/ 60;
    final seconds = resendCountdown.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /* ---------- Actions ---------- */
  /// Called when the verify OTP button is pressed.
  void onVerifyOtpPressed() {
    // --- Validation ---
    final validationError = validateOtpInput();
    if (validationError != null) {
      NotificationService.showError(title: 'Error', message: validationError);
      return;
    }
    verifyOtp();
  }

  /// Called when the resend OTP button is pressed.
  void onResendOtpPressed() {
    final mobile = phoneNumber;
    if (mobile.isNotEmpty) {
      resendOtp(mobile);
    } else {
      NotificationService.showError(
        title: 'Error',
        message: 'Phone number not found. Please go back and try again.',
      );
    }
  }

  /// Navigates back to the login screen.
  void goToLogin() {
    Get.back();
  }

  // ---------------------------------------------------------------------------
  @override
  void onClose() {
    scrollController.dispose();
    _countdownTimer?.cancel();
    for (final n in [..._otpFocusNodes, ..._rawKeyboardNodes]) {
      n.dispose();
    }
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
