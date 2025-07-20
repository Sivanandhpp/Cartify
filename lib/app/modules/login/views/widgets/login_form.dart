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
              prefixIcon: const Icon(
                Icons.phone,
                color: AppColors.lightOnBackground,
              ),
              prefixText: AppStrings.loginCountryCode,
              prefixStyle: AppTextStyles.bodyLarge(AppColors.lightOnBackground),
              hintText: AppStrings.loginEnterMobileNumber,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: AppColors.lightOnBackground.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(
                  color: AppColors.lightOnBackground.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  color: AppColors.lightPrimary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  color: AppColors.lightError,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  color: AppColors.lightError,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              counterText: '',
            ),
          ),
          AppSpacing.spaceMedium,
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



