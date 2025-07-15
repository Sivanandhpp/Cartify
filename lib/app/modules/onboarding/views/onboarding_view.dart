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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: TextButton(
                      onPressed: () {
                        controller.isBoarded();
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
              // const SizedBox(height: 16),
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: CustomButtons.primary(
                    text:
                        controller.pageIndex.value < controller.pages.length - 1
                        ? "Next"
                        : "Get Started",
                    onPressed: () {
                      if (controller.pageIndex.value <
                          controller.pages.length - 1) {
                        controller.nextPage();
                      } else {
                        controller.isBoarded();
                      }
                    },
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
