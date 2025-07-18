import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/onboarding_controller.dart';
import '../../../../core/index.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: AppPaddings.all8,
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

