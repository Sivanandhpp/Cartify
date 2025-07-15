import 'package:bevco/app/modules/onboarding/views/widgets/onboarding_widget.dart';
import 'package:bevco/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  var pageIndex = 0.obs;
  late final pageController = PageController();
  final storage = GetStorage();

  final pages = [
    OnboardingPage(
      image: 'assets/images/onboarding1.jpg',
      title: 'Shop Your Favorites',
      subtitle:
          'Discover trending products, curated collections,\nand best deals—all in one place.',
    ),
    OnboardingPage(
      image: 'assets/images/onboarding1.jpg',
      title: 'Safe & Easy Checkout',
      subtitle:
          'Enjoy secure payments with cards, UPI, or COD.\nYour data stays safe with us.',
    ),
    OnboardingPage(
      image: 'assets/images/onboarding1.jpg',
      title: 'Fast Delivery, Easy Returns',
      subtitle:
          'Track orders live, get doorstep delivery,\nand return items hassle-free.',
    ),
  ];

  void nextPage() {
    if (pageIndex.value < 2) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void prevPage() {
    if (pageIndex.value > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void onPageChanged(int index) {
    pageIndex.value = index;
  }

  void isBoarded() {
    storage.write('isBoarded', true);
    Get.toNamed(Routes.LOGIN);
  }
}
