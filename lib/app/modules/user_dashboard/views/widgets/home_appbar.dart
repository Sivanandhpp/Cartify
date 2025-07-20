// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';

// Local imports (relative)
import 'bottom_nav_bar.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.primary,
      pinned: true,
      floating: true,
      elevation: 0,
      title: const Row(
        children: [
          Icon(Icons.location_on, color: AppColors.white, size: 20),
          AppSpacing.spaceSmallW,
          Text(
            'Kozhikode Work',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          Icon(Icons.arrow_drop_down, color: AppColors.white),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.white),
          onPressed: () {
            controller.logOut();
          },
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for \'Products\'',
              hintStyle: TextStyle(color: AppColors.grey),
              prefixIcon: Icon(Icons.search, color: AppColors.grey),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: AppSpacing.radiusSmall,
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      ),
    );
  }
}



