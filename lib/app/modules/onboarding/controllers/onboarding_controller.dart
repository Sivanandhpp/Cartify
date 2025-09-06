// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {

  late final PageController pageController;
  final RxInt pageIndex = 0.obs;

  final List<OnboardingPageData> pages = onboardingPages;

  String get primaryButtonLabel => pageIndex.value < pages.length - 1
      ? AppStrings.onBoardingButtonInitial
      : AppStrings.onBoardingButtonFinal;

  /* ---------- lifecycle ---------- */
  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /* ---------- public API ---------- */
  void onPageChanged(int index) => pageIndex.value = index;

  void handlePrimaryButtonTap() {
    pageIndex.value < pages.length - 1 ? nextPage() : finishOnboarding();
  }

  /* ---------- private helpers ---------- */
  void nextPage() => pageController.nextPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.ease,
  );

  Future<void> finishOnboarding() async {
    await StorageService().markBoarded();
    Get.offAllNamed(Routes.LOGIN);
  }
}













