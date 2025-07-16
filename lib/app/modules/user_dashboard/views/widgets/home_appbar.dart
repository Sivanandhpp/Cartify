import 'package:bevco/app/core/constants/app_constants.dart';
import 'package:bevco/app/core/themes/app_colors.dart';
import 'package:bevco/app/core/widgets/app_spacers.dart';
import 'package:bevco/app/modules/user_dashboard/views/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.primary,
      pinned: true,
      floating: true,
      elevation: 0,
      title: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.white, size: 20),
          AppSpacers.smallWidth,
          Text(
            'Kozhikode Work',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          const Icon(Icons.arrow_drop_down, color: AppColors.white),
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(64.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for \'Products\'',
              hintStyle: TextStyle(color: AppColors.grey),
              prefixIcon: Icon(Icons.search, color: AppColors.grey),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: AppBorderRadius.secondaryBorder,
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      ),
    );
  }
}
