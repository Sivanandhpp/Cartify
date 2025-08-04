import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpCheckController extends GetxController {
  /// Injects the [AuthenticationService] to handle OTP verification and resend logic.
  /// Injects the [UserService] to fetch user profile for role-based navigation.
  OtpCheckController(this._authenticationService, this._userService);

  final AuthenticationService _authenticationService;
  final UserService _userService;

  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final otpLength = 4;

  // --- Reactive State ---
  final filled = <bool>[].obs;
  final RxBool isResending = false.obs;
  final RxBool isVerifying = false.obs;

  // --- UI Controllers ---
  late final List<TextEditingController> otpControllers;
  late final List<FocusNode> otpFocusNodes;
  late final List<FocusNode> rawKeyboardNodes;

  /* ---------- Lifecycle ---------- */
  @override
  void onInit() {
    super.onInit();
    // Initialize controllers and focus nodes for each OTP digit field.
    otpControllers = List.generate(otpLength, (_) => TextEditingController());
    otpFocusNodes = List.generate(otpLength, (_) => FocusNode());
    rawKeyboardNodes = List.generate(otpLength, (_) => FocusNode());
    filled.assignAll(List.filled(otpLength, false));
    LogService.info('OtpCheckController initialized');
  }

  @override
  void onClose() {
    // Dispose all controllers and focus nodes to prevent memory leaks.
    scrollController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    for (var node in rawKeyboardNodes) {
      node.dispose();
    }
    LogService.info('OtpCheckController disposed');
    super.onClose();
  }

  /* ---------- UI Event Handlers ---------- */
  /// Handles changes in an OTP digit field.
  void onDigitChanged(int index, String value) {
    filled[index] = value.isNotEmpty;

    if (value.isNotEmpty && index < otpLength - 1) {
      // Move focus to the next field if a digit is entered.
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty && index == otpLength - 1) {
      // If the last digit is entered, unfocus and trigger verification.
      FocusManager.instance.primaryFocus?.unfocus();
      onVerifyOtpPressed();
    }
  }

  /// Handles the backspace key press in an OTP field.
  void onBackspacePressed(int index) {
    if (otpControllers[index].text.isEmpty && index > 0) {
      // If the current field is empty, clear the previous one and move focus back.
      otpControllers[index - 1].clear();
      filled[index - 1] = false;
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  /* ---------- Actions ---------- */
  /// Triggered when the "Verify OTP" action is initiated.
  void onVerifyOtpPressed() {
    if (isVerifying.value) return;
    verifyOtp();
  }

  /// Gathers the OTP, validates it, and calls the authentication service.
  Future<void> verifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length != otpLength) {
      ErrorService.showError('Please enter the complete 4-digit OTP.');
      return;
    }

    final phoneNumber = Get.arguments?['mobile'] as String?;
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ErrorService.showError(
        'Phone number not found. Please go back and try again.',
      );
      return;
    }

    isVerifying.value = true;
    LogService.info('Verifying OTP: $otp for phone: $phoneNumber');

    try {
      final dto = VerifyOtpDto(phoneNumber: phoneNumber, otpCode: otp);
      final success = await _authenticationService.verifyOtp(dto);

      if (success) {
        LogService.info('OTP verified successfully for $phoneNumber');
        ErrorService.showSuccess('Login Successful!');

        // Fetch user profile to determine role-based navigation
        await _navigateBasedOnUserRole();
      } else {
        LogService.error('OTP verification failed for $phoneNumber');
        ErrorService.showError('Invalid or expired OTP. Please try again.');
      }
    } catch (error) {
      LogService.error(
        'An unexpected error occurred during OTP verification',
        error,
      );
      ErrorService.showError('An unexpected error occurred. Please try again.');
    } finally {
      isVerifying.value = false;
    }
  }

  /// Triggered when the "Resend OTP" button is pressed.
  void onResendOtpPressed() {
    if (isResending.value) return;
    resendOtp();
  }

  /// Legacy method names for backward compatibility with existing UI.
  // Future<void> verifyOtp() => _verifyOtp();
  // Future<void> resendOtp([String? mobile]) => _resendOtp();

  /// Navigation method for backward compatibility.
  void goToLogin() {
    Get.back();
  }

  /// Calls the authentication service to request a new OTP.
  Future<void> resendOtp() async {
    final phoneNumber = Get.arguments?['mobile'] as String?;
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ErrorService.showError('Phone number not found. Cannot resend OTP.');
      return;
    }

    isResending.value = true;
    LogService.info('Resending OTP to: $phoneNumber');

    try {
      final requestDto = RequestOtpDto(phoneNumber: phoneNumber);
      final success = await _authenticationService.requestOtp(requestDto);

      if (success) {
        LogService.info('OTP resent successfully to $phoneNumber');
        ErrorService.showSuccess('A new OTP has been sent.');
      } else {
        LogService.error('Failed to resend OTP to $phoneNumber');
        ErrorService.showError('Failed to resend OTP. Please try again.');
      }
    } catch (error) {
      LogService.error(
        'An unexpected error occurred while resending OTP',
        error,
      );
      ErrorService.showError('An unexpected error occurred. Please try again.');
    } finally {
      isResending.value = false;
    }
  }

  /// Fetches the user profile and navigates to the appropriate screen based on their role.
  Future<void> _navigateBasedOnUserRole() async {
    try {
      LogService.info('Fetching user profile for role-based navigation');
      final userProfile = await _userService.getUserProfile();

      if (userProfile != null) {
        LogService.info(
          'User profile fetched successfully. Role: ${userProfile.role}',
        );
        _navigateToRoleBasedScreen(userProfile.role);
      } else {
        LogService.error('Failed to fetch user profile after login');
        ErrorService.showError(
          'Unable to load user profile. Please try again.',
        );
        // Default fallback to login screen if profile fetch fails
        Get.offAllNamed('/login');
      }
    } catch (error) {
      LogService.error('Error fetching user profile for navigation', error);
      ErrorService.showError('An error occurred. Please try logging in again.');
      Get.offAllNamed('/login');
    }
  }

  /// Navigates to the appropriate screen based on the user's role.
  void _navigateToRoleBasedScreen(String role) {
    switch (role.toLowerCase()) {
      case 'buyer':
        LogService.info('Navigating to Buyer Panel');
        Get.offAllNamed('/buyer-panel');
        break;
      case 'seller':
        LogService.info('Navigating to Seller Panel');
        Get.offAllNamed('/seller-panel');
        break;
      case 'admin':
        LogService.info('Navigating to Admin Dashboard');
        Get.offAllNamed('/admin-dashboard');
        break;
      default:
        LogService.warning(
          'Unknown user role: $role. Defaulting to buyer panel.',
        );
        Get.offAllNamed('/buyer-panel');
        break;
    }
  }
}
