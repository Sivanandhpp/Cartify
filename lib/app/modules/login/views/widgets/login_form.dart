import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/app_spacers.dart';
import '../../controllers/login_controller.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_colors.dart';

class LoginForm extends GetView<LoginController> {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: controller.validatePhone,
            onFieldSubmitted: (_) => controller.sendOtp(),
            style: AppTextStyles.body,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone, color: AppColors.textPrimary),
              prefixText: AppStrings.loginCountryCode,
              prefixStyle: AppTextStyles.body,
              hintText: AppStrings.loginEnterMobileNumber,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              counterText: '',
            ),
          ),
          AppSpacers.smallHeight,
          SizedBox(
            width: double.infinity,
            child: AppButtons.primary(
              text: AppStrings.sendOtp,
              icon: Icons.arrow_forward,
              onPressed: controller.onSendOtpPressed,
            ),
          ),
        ],
      ),
    );
  }
}
