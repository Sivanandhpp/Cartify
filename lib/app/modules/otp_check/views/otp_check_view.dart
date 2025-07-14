import 'package:bevco/app/core/constants/app_images.dart';
import 'package:bevco/app/core/constants/app_strings.dart';
import 'package:bevco/app/core/themes/app_text_styles.dart';
import 'package:bevco/app/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../controllers/otp_check_controller.dart';

class OtpCheckView extends GetView<OtpCheckController> {
  const OtpCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    final String mobile = Get.arguments?['mobile'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Account',
          style: TextStyle(color: AppColors.primary),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        iconTheme: IconThemeData(color: AppColors.primary),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              Image.asset(AppImages.otpBg, fit: BoxFit.cover),
              const SizedBox(height: 32),
              Text(
                AppStrings.enterOtp,
                style: AppTextStyles.title.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '${AppStrings.otpHelperTitle} $mobile',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // OTP Input
              Form(
                key: controller.formKey,
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        width: 65,
                        height: 65,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          controller: controller.otpControllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          showCursor: false,
                          autofocus: index == 0,
                          // focusNode: controller.focusNodes[index],

                       enableInteractiveSelection: false,
                          maxLength: 1,
                          style: AppTextStyles.title.copyWith(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: controller.filled[index]
                                ? AppColors.primary
                                : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: controller.filled[index]
                                    ? AppColors.primary
                                    : const Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                          onTap: () {
                            Future.delayed(
                              const Duration(milliseconds: 200),
                              () {
                                controller.scrollController.animateTo(
                                  controller
                                      .scrollController
                                      .position
                                      .maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            );
                          },
                          onChanged: (value) {
                            controller.filled[index] = value.isNotEmpty;
                            if (value.isNotEmpty && index == 3) {
                              FocusScope.of(context).unfocus();
                              controller.verifyOtp();
                            }
                            if (value.isNotEmpty && index < 3) {
                              FocusScope.of(context).nextFocus();
                            }
                            if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          
 
                          validator: (value) =>
                              value == null || value.isEmpty ? '' : null,
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CustomButtons.primary(
                  onPressed: () => controller.verifyOtp(),
                  text: 'Verify OTP',
                ),
              ),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  text: "Didn't receive code? ",
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => controller.resendOtp(mobile),
                        child: Text(
                          'Resend again',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
