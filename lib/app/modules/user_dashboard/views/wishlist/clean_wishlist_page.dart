import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/wishlist_controller.dart';
import 'widgets/wishlist_app_bar.dart';
import 'widgets/wishlist_empty_state.dart';
import 'widgets/wishlist_grid.dart';
import 'widgets/wishlist_loading.dart';

/// Clean, dumb wishlist page view
/// Contains only UI elements and delegates all logic to controller
class CleanWishlistPage extends StatelessWidget {
  const CleanWishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WishlistController>(
      builder: (controller) => _WishlistScrollView(controller: controller),
    );
  }
}

/// Internal scroll view widget to keep the main widget clean
class _WishlistScrollView extends StatelessWidget {
  final WishlistController controller;

  const _WishlistScrollView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo is ScrollUpdateNotification) {
          controller.handleScrollUpdate(scrollInfo.metrics.pixels);
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          // App bar with wishlist count and clear action
          Obx(
            () => WishlistAppBar(
              itemCount: controller.wishlistItems.length,
              onClearAll: controller.clearAllWishlist,
            ),
          ),

          // Main content
          Obx(() => _buildContent()),

          // Bottom safe area padding
          const SliverToBoxAdapter(child: SizedBox(height: 180)),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final controller = Get.find<WishlistController>();

    if (controller.isLoading.value) {
      return const WishlistLoading();
    }

    if (controller.wishlistItems.isEmpty) {
      return const WishlistEmptyState();
    }

    return WishlistGrid(
      items: controller.wishlistItems,
      onToggleWishlist: controller.toggleWishlist,
      onAddToCart: controller.addToCart,
    );
  }
}
