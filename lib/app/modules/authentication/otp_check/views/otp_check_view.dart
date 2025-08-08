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
    final phoneNumber = Get.arguments?['phoneNumber'] ?? '';

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
        padding: AppSpacing.paddingLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSpacing.spaceMedium,
            Image.asset(AppImages.otpBackground, fit: BoxFit.cover),
            AppSpacing.spaceLarge,
            Text(
              AppStrings.otpCheckEnterOtp,
              style: AppTextStyles.titleLarge(AppColors.lightOnBackground),
              textAlign: TextAlign.center,
            ),
            AppSpacing.spaceMedium,
            Text(
              AppStrings.otpCheckHelperTitle,
              style: AppTextStyles.bodyLarge(AppColors.lightOnBackground),
              textAlign: TextAlign.center,
            ),
            Text.rich(
              TextSpan(
                text: phoneNumber,
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

            AppSpacing.spaceLarge,
            Form(key: controller.formKey, child: const OtpFieldsRow()),
            AppSpacing.spaceMedium,
            Obx(
              () => AppButton(
                onPressed: () => controller.verifyOtp(),
                text: controller.isVerifying.value
                    ? 'Verifying...'
                    : AppStrings.otpCheckVerifyButton,
                enabled: !controller.isVerifying.value,
                isLoading: controller.isVerifying.value,
              ),
            ),
            AppSpacing.spaceLarge,
            Obx(
              () => controller.canResend.value
                  ? Text.rich(
                      TextSpan(
                        text: AppStrings.otpCheckResendText,
                        style: AppTextStyles.labelLarge(
                          AppColors.lightOnBackground,
                        ),
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: controller.isResending.value
                                  ? null
                                  : () => controller.resendOtp(phoneNumber),
                              child: Text(
                                controller.isResending.value
                                    ? 'Resending...'
                                    : AppStrings.otpCheckResendButton,
                                style: AppTextStyles.labelLarge(
                                  controller.isResending.value
                                      ? AppColors.primary.withValues(alpha: 0.5)
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      'OTP sent. Try again in ${controller.formattedCountdown}',
                      style: AppTextStyles.labelLarge(
                        AppColors.lightOnBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
