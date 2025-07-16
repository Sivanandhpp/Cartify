import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/user_dashboard_controller.dart';

class VideoBannerView extends GetView<UserDashboardController> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        // Set a fixed height for the banner area, similar to the image.
        // height: 150.0,
        color: Colors.black, // Background color while video loads
        child: Obx(() {
          if (controller.isVideoInitialized.value) {
            // Once initialized, show the video player.
            return AspectRatio(
              // Use the video's aspect ratio to prevent distortion.
              aspectRatio: controller.videoPlayerController.value.aspectRatio,
              child: VideoPlayer(controller.videoPlayerController),
            );
          } else {
            // While loading, you can show a shimmer effect or a simple indicator.
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }
        }),
      ),
    );
  }
}
