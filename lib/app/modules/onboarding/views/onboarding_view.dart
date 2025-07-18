// Local imports (relative)
import 'widgets/onboarding_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import 'widgets/skip_button.dart';
import 'widgets/bottom_controls.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SkipButton(),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.pages.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (_, index) {
                  final page = controller.pages[index];
                  return OnboardingPage(
                    image: page.image,
                    title: page.title,
                    subtitle: page.subtitle,
                  );
                },
              ),
            ),
            const BottomControls(),
          ],
        ),
      ),
    );
  }
}
