import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/onboarding_controller.dart';
import 'indicator_widget.dart';
import '../../../../core/index.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Indicator(
            current: controller.pageIndex.value,
            count: controller.pages.length,
          ),
          Container(
            width: double.infinity,
            padding: AppPaddings.all16,
            child: AppButtons.primary(
              text: controller.primaryButtonLabel,
              onPressed: controller.handlePrimaryButtonTap,
            ),
          ),
        ],
      ),
    );
  }
}

