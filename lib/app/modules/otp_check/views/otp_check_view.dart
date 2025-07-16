import 'package:bevco/app/core/constants/app_images.dart';
import 'package:bevco/app/core/constants/app_padding.dart';
import 'package:bevco/app/core/constants/app_strings.dart';
import 'package:bevco/app/core/themes/app_text_styles.dart';
import 'package:bevco/app/core/widgets/app_buttons.dart';
import 'package:bevco/app/core/widgets/app_spacers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
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
        padding: AppPaddings.large,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppSpacers.smallHeight,
            Image.asset(AppImages.otpBg, fit: BoxFit.cover),
            AppSpacers.largeHeight,
            Text(
              AppStrings.otpCheckEnterOtp,
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            AppSpacers.smallHeight,
            Text(
              AppStrings.otpCheckHelperTitle,
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Text.rich(
              TextSpan(
                text: '${AppStrings.loginCountryCode} $mobile',
                style: AppTextStyles.bodyLarge,
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => controller.goToLogin(),
                      child: Text(
                        '  ${AppStrings.otpCheckEditMobile}',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AppSpacers.largeHeight,
            Form(key: controller.formKey, child: const OtpFieldsRow()),
            AppSpacers.largeHeight,
            SizedBox(
              width: double.infinity,
              child: AppButtons.primary(
                onPressed: controller.verifyOtp,
                text: AppStrings.otpCheckVerifyButton,
              ),
            ),
            AppSpacers.mediumHeight,
            Text.rich(
              TextSpan(
                text: AppStrings.otpCheckResendText,
                style: AppTextStyles.labelLarge,
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => controller.resendOtp(mobile),
                      child: Text(
                        AppStrings.otpCheckResendButton,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                        ),
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
