import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';

/// Production-level reusable cart app bar widget
///
/// Displays location, store name, and action buttons with consistent styling
class CartAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String locationTitle;
  final String storeDescription;
  final VoidCallback? onSharePressed;
  final VoidCallback? onMorePressed;
  final VoidCallback? onBackPressed;

  const CartAppBarWidget({
    super.key,
    required this.locationTitle,
    required this.storeDescription,
    this.onSharePressed,
    this.onMorePressed,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBackPressed ?? () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locationTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            storeDescription,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.black),
          onPressed: onSharePressed ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: onMorePressed ?? () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
