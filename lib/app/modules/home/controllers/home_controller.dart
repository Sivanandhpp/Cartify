import 'package:bevco/app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final formKey = GlobalKey<FormState>();
    final phoneController = TextEditingController();

    String? validatePhone(String? value) {
      if (value == null || value.isEmpty) {
        return AppStrings.loginErrEmpty;
      }
      final phoneRegExp = RegExp(r'^[6-9]\d{9}$');
      if (!phoneRegExp.hasMatch(value)) {
        return AppStrings.loginErrNumberlength;
      }
      return null;
    }

    void sendOtp() {
      if (formKey.currentState!.validate()) {
        Get.snackbar(
          AppStrings.otpSent,
          '${AppStrings.otpSentMessage} ${phoneController.text}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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
    super.onClose();
  }

}
