import 'package:bevco/app/core/constants/app_padding.dart';
import 'package:bevco/app/core/constants/app_strings.dart';
import 'package:bevco/app/core/themes/app_colors.dart';
import 'package:bevco/app/core/widgets/custom_buttons.dart';
import 'package:bevco/app/modules/onboarding/views/widgets/indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: AppPaddings.small,
                    child: TextButton(
                      onPressed: () => controller.isBoarded(),
                      child: const Text(
                        AppStrings.onBoardingSkip,
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.pages.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (_, i) => controller.pages[i],
                ),
              ),
              Obx(
                () => Indicator(
                  current: controller.pageIndex.value,
                  count: controller.pages.length,
                ),
              ),

              Obx(
                () => Container(
                  width: double.infinity,
                  padding: AppPaddings.screenPadding,
                  child: CustomButtons.primary(
                    text: controller.primaryButtonLabel,
                    onPressed: () => controller.handlePrimaryButtonTap(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
