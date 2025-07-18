import 'package:bevco/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OtpCheckController extends GetxController {
  // --- public --------------------------------------------------------------
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final otpLength = 4;

  // rx
  final filled = <bool>[].obs;

  // --- private -------------------------------------------------------------
  final _storage = GetStorage();
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
      Get.snackbar('Success', 'Welcome back admin!');
      _goToDashboard(isAdmin: true);
    } else if (otp.length == otpLength) {
      Get.snackbar('Success', 'OTP Verified!');
      _goToDashboard(isAdmin: false);
    } else {
      Get.snackbar('Error', 'Please enter the 4‑digit OTP');
    }
  }

  void resendOtp(String mobile) {
    Get.snackbar('OTP', 'Resent OTP to +91 $mobile');
  }

  // -------------------------------------------------------------------------
  void _goToDashboard({required bool isAdmin}) {
    _storage.write('isLoggedIn', true);
    _storage.write('userRole', isAdmin ? 'admin' : 'user');
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
