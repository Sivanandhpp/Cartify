// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports (relative)
import '../controllers/otp_check_controller.dart';
import 'widgets/otp_fields_row.dart';

class OtpCheckView extends GetView<OtpCheckController> {
  const OtpCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = Get.arguments?['mobile'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.otpCheckViewTitle,
          style: TextStyle(color: AppColors.primary),
        ),
        centerTitle: true,
        forceMaterialTransparency: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        padding: AppPaddings.all24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSpacers.h12,
            Image.asset(AppImages.otpBackground, fit: BoxFit.cover),
            AppSpacers.h32,
            Text(
              AppStrings.otpCheckEnterOtp,
              style: AppTextStyles.titleLarge(AppColors.lightOnBackground),
              textAlign: TextAlign.center,
            ),
            AppSpacers.h12,
            Text(
              AppStrings.otpCheckHelperTitle,
              style: AppTextStyles.bodyLarge(AppColors.lightOnBackground),
              textAlign: TextAlign.center,
            ),
            Text.rich(
              TextSpan(
                text: '${AppStrings.loginCountryCode} $mobile',
                style: AppTextStyles.bodyLarge(AppColors.lightOnBackground),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => controller.goToLogin(),
                      child: Text(
                        '  ${AppStrings.otpCheckEditMobile}',
                        style: AppTextStyles.labelLarge(AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AppSpacers.h32,
            Form(key: controller.formKey, child: const OtpFieldsRow()),
            AppSpacers.h32,
            SizedBox(
              width: double.infinity,
              child: AppButtons.primary(
                onPressed: controller.verifyOtp,
                text: AppStrings.otpCheckVerifyButton,
              ),
            ),
            AppSpacers.h24,
            Text.rich(
              TextSpan(
                text: AppStrings.otpCheckResendText,
                style: AppTextStyles.labelLarge(AppColors.lightOnBackground),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => controller.resendOtp(mobile),
                      child: Text(
                        AppStrings.otpCheckResendButton,
                        style: AppTextStyles.labelLarge(AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}










