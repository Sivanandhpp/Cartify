import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpCheckController extends GetxController {

final formKey = GlobalKey<FormState>();
final otpControllers = List.generate(4, (_) => TextEditingController());

void verifyOtp() {
  String otp = otpControllers.map((c) => c.text).join();
  // Add your OTP verification logic here
  if (otp.length == 4) {
    Get.snackbar('Success', 'OTP Verified!');
    // Navigate to next page or perform action
  } else {
    Get.snackbar('Error', 'Please enter the 4-digit OTP');
  }
}

void resendOtp(String mobile) {
  // Add your resend OTP logic here
  Get.snackbar('OTP', 'Resent OTP to +91 $mobile');
}



  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
void onClose() {
  for (var c in otpControllers) {
    c.dispose();
  }
  super.onClose();
}

}
