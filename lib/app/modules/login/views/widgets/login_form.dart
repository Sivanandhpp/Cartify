import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../../controllers/login_controller.dart';

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
            style: AppTextStyles.bodyLarge(AppColors.lightOnBackground),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone, color: AppColors.lightOnBackground),
              prefixText: AppStrings.loginCountryCode,
              prefixStyle: AppTextStyles.bodyLarge(AppColors.lightOnBackground),
              hintText: AppStrings.loginEnterMobileNumber,
              border: OutlineInputBorder(
                borderRadius: AppBorderRadius.circular8,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              counterText: '',
            ),
          ),
          AppSpacers.h12,
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

