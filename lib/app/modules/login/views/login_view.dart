import 'package:bevco/app/core/constants/app_constants.dart';
import 'package:bevco/app/core/constants/app_images.dart';
import 'package:bevco/app/core/constants/app_strings.dart';
import 'package:bevco/app/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bevco/app/core/themes/app_theme.dart';
import 'package:bevco/app/core/themes/app_colors.dart';
import 'package:bevco/app/core/themes/app_text_styles.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(AppImages.loginBg, fit: BoxFit.cover),
                  SizedBox(height:20),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppStrings.loginWelcome,
                          style: AppTextStyles.title,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.loginHelperTitle,
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: controller.validatePhone,
                          onFieldSubmitted: (_) => controller.sendOtp(),
                          style: AppTextStyles.body,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              
                              Icons.phone,
                              color: AppColors.textPrimary,
                            ),
                            prefixText: AppStrings.loginCountryCode,
                            prefixStyle: AppTextStyles.body,
                            hintText: AppStrings.enterMobileNumber,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppConstants.cornerRadius),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            counterText: '',
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButtons.primary(
                            text: AppStrings.sendOtp,
                            onPressed: controller.sendOtp,
                            icon: Icons.arrow_forward,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppStrings.loginTermsPolicy,
                          style: AppTextStyles.caption,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
