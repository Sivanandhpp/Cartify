// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../login/data/auth_service.dart';

class OtpCheckController extends GetxController {
  // --- public --------------------------------------------------------------
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final otpLength = 4;

  // rx
  final filled = <bool>[].obs;
  final RxBool isResending = false.obs;

  // --- private -------------------------------------------------------------
  final _storage = GetStorage();
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

  void verifyOtp() {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp == '1234') {
      NotificationService.showSuccess(
        title: 'Success',
        message: 'Welcome back admin!',
      );
      _goToDashboard(isAdmin: true);
    } else if (otp.length == otpLength) {
      NotificationService.showSuccess(
        title: 'Success',
        message: 'OTP Verified!',
      );
      _goToDashboard(isAdmin: false);
    } else {
      NotificationService.showError(
        title: 'Error',
        message: 'Please enter the 4-digit OTP',
      );
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
  void _goToDashboard({required bool isAdmin}) {
    _storage.write(AppConfig.loginStatusKey, true);
    _storage.write(AppConfig.userRoleKey, isAdmin ? 'admin' : 'user');
    Get.offAllNamed(isAdmin ? Routes.ADMIN_DASHBOARD : Routes.USER_DASHBOARD);
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
