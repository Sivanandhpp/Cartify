import 'package:bevco/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OtpCheckController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final otpControllers = List.generate(4, (_) => TextEditingController());
  final otpFocusNodes = List.generate(4, (_) => FocusNode());
  final rawKeyboardNodes = List.generate(4, (_) => FocusNode());

  final filled = List.generate(4, (_) => false).obs;
  final scrollController = ScrollController();
  final storage = GetStorage();

  void goToUserDashboard() {
    storage.write('isLoggedIn', true);
    storage.write('userRole', 'user');
    Get.offAllNamed(Routes.USER_DASHBOARD);
  }

  void goToAdminDashboard() {
    storage.write('isLoggedIn', true);
    storage.write('userRole', 'admin');
    Get.offAllNamed(Routes.ADMIN_DASHBOARD);
  }

  void verifyOtp() {
    String otp = otpControllers.map((c) => c.text).join();
    if (otp == '1234') {
      Get.snackbar('Success', 'Welcome back admin!');
      goToAdminDashboard();
    } else if (otp.length == 4) {
      Get.snackbar('Success', 'OTP Verified!');
      goToUserDashboard();
    } else {
      Get.snackbar('Error', 'Please enter the 4-digit OTP');
    }
  }

  void resendOtp(String mobile) {
    Get.snackbar('OTP', 'Resent OTP to +91 $mobile');
  }

  @override
  void onClose() {
    scrollController.dispose();
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    for (var node in rawKeyboardNodes) {
      node.dispose();
    }
    for (var c in otpControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
