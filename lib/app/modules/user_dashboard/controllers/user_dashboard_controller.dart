import 'package:bevco/app/core/constants/app_images.dart';
import 'package:bevco/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';

import '../../../core/themes/app_colors.dart';
import '../models/category_model.dart';
import '../models/deal_model.dart';

class UserDashboardController extends GetxController {
  late VideoPlayerController videoPlayerController;
  final isVideoInitialized = false.obs;

  // Replace with your video URL (e.g., from a CDN)
  final String videoUrl = 'assets/videos/banner_video.mp4';
  final storage = GetStorage();
  // State for Bottom Navigation Bar
  final selectedNavIndex = 0.obs;

  // Data for UI sections
  late final List<CategoryModel> categories;
  late final List<DealModel> deals;

  @override
  void onInit() {
    super.onInit();
    _initializeVideoPlayer();
    _loadData();
  }

  void _initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.asset(
      videoUrl, // Uri.parse(videoUrl),
    );
    try {
      await videoPlayerController.initialize();
      videoPlayerController.setLooping(true);
      // Muting is crucial for autoplay on most platforms.
      videoPlayerController.setVolume(0.0);
      videoPlayerController.play();
      isVideoInitialized.value = true;
    } catch (e) {
      Get.snackbar(
        "Video Error",
        "Failed to load banner video.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // A private method to initialize all the data for the screen.
  // In a real app, this data would come from an API call.
  void _loadData() {
    categories = [
      CategoryModel(label: 'All', icon: Icons.grid_view),
      CategoryModel(label: 'Maxxsaver', icon: Icons.local_offer),
      CategoryModel(label: 'Fresh', icon: Icons.eco),
      CategoryModel(label: 'Monsoon', icon: Icons.umbrella),
      CategoryModel(label: 'Gadgets', icon: Icons.phone_iphone),
      CategoryModel(label: 'Home', icon: Icons.home_work),
    ];

    deals = [
      DealModel(
        title: 'UP TO\n80%\nOFF',
        subtitle: 'WOW DEALS',
        color: AppColors.pink,
        imageUrl: AppImages.offer80,
      ),
      DealModel(
        title: 'Apple\niPhone 16 Pro',
        subtitle: 'UP TO 20% OFF',
        color: AppColors.lightBlue,
        imageUrl: AppImages.product1,
      ),
      DealModel(
        title: 'Apple Watch\nSeries 9',
        subtitle: 'STARTING ₹46,000/-',
        color: AppColors.teal,
        imageUrl: AppImages.product2,
      ),
      DealModel(
        title: 'Macbook &\nPro M3',
        subtitle: 'UP TO 25% OFF',
        color: AppColors.purple,
        imageUrl: AppImages.product3,
      ),
    ];
  }

  void onNavItemTapped(int index) {
    selectedNavIndex.value = index;
  }

  void logOut() {
    storage.erase();
    // TODO:
    // storage.remove('isLoggedIn');
    // storage.remove('userRole');
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}
