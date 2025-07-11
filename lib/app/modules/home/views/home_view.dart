import 'package:bevco/app/core/constants/app_strings.dart';
import 'package:bevco/app/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/themes/app_theme.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text(AppStrings.loginTitle),
        //   centerTitle: true,
        // ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
               padding: const EdgeInsets.all(32),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                     AppStrings.loginWelcome,
                      style: AppTextStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.loginHelperTitle,
                      style: AppTextStyles.body.copyWith(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: controller.validatePhone,
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                        prefixText: AppStrings.loginCountryCode,
                        prefixStyle: AppTextStyles.body,
                        hintText: AppStrings.enterMobileNumber,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 24),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
