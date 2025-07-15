import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/onboarding_controller.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_padding.dart';
import '../../../../core/themes/app_colors.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: AppPaddings.small,
        child: TextButton(
          onPressed: controller.finishOnboarding,
          child: const Text(
            AppStrings.onBoardingSkip,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
