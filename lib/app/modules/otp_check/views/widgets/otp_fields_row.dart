import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/otp_check_controller.dart';
import 'otp_digit_field.dart';

class OtpFieldsRow extends GetView<OtpCheckController> {
  const OtpFieldsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          controller.otpLength,
          (i) => OtpDigitField(
            controller: controller.otpControllers[i],
            focusNode: controller.otpFocusNodes[i],
            keyboardNode: controller.rawKeyboardNodes[i],
            isFilled: controller.filled[i],
            autoFocus: i == 0,
            onChanged: (val) => controller.onDigitChanged(i, val),
            onBackspace: () => controller.onBackspacePressed(i),
          ),
        ),
      ),
    );
  }
}

