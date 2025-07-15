import 'package:bevco/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/onboarding_page_data.dart';
import '../data/onboarding_storage_service.dart';
import '../../../core/constants/app_strings.dart';

class OnboardingController extends GetxController {
  OnboardingController(this._storageService);

  final OnboardingStorageService _storageService;

  late final PageController pageController;
  final RxInt pageIndex = 0.obs;

  // Expose pages as an unmodifiable list for the view.
  final List<OnboardingPageData> pages = kOnboardingPages;

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
    await _storageService.markBoarded();
    Get.offAllNamed(Routes.LOGIN);
  }
}
